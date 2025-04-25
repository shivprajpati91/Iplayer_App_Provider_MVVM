import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import 'onboarding_screen.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}
class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    // Fetch the user profile after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileProvider>(context, listen: false).fetchUserProfile();
    });
  }

  Future<String> getEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ?? 'Working on it......';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context); // 👈 Added MediaQuery once

    return Drawer(
      child: Stack(
        children: [
          Consumer<UserProfileProvider>(
            builder: (context, profile, child) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade700,
                          Colors.purpleAccent.shade400
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: mediaQuery.size.height * 0.1), // 👈 10% screen height
                        FutureBuilder<String>(
                          future: getEmail(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: mediaQuery.size.width * 0.03, // 👈 3% screen width
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error loading email',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: mediaQuery.size.width * 0.03,
                                ),
                              );
                            } else {
                              return Text(
                                snapshot.data ?? 'Email not set',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: mediaQuery.size.width * 0.045, // 👈 4.5% screen width
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: mediaQuery.size.width * 0.07, // 👈 Icon responsive
                    ),
                    title: Text(
                      'Follow Me on Instagram',
                      style: TextStyle(fontSize: mediaQuery.size.width * 0.045), // 👈 Text responsive
                    ),
                    onTap: () async {
                      const instagramUrl = 'https://www.instagram.com/flutter_with_prince?igsh=bTF4M3lpbDdkdmxj';
                      if (await canLaunch(instagramUrl)) {
                        await launch(instagramUrl);
                      } else {
                        throw 'Could not launch $instagramUrl';
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}



class UserProfileProvider with ChangeNotifier {
  String name = 'Not set';


  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Fetch user profile from Realtime Database
  Future<void> fetchUserProfile() async {
    try {
      if (userId.isEmpty) {
        print("User not logged in");
        return;
      }

      DatabaseReference userRef = _database.ref().child('users/$userId');
      DatabaseEvent event = await userRef.once();

      if (event.snapshot.exists) {
        Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);

        name = data['name'] ?? 'Not set';



        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  // Update a single field in Realtime Database
  Future<void> updateUserProfile(String key, String value) async {
    try {
      if (userId.isEmpty) {
        print("User not logged in");
        return;
      }

      DatabaseReference userRef = _database.ref().child('users/$userId');
      await userRef.update({key: value});
      await fetchUserProfile();
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }

}

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context); // 👈 Added MediaQuery

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: Icon(
              Icons.logout,
              color: Colors.white,
              size: mediaQuery.size.width * 0.07, // 👈 Responsive Icon
            ),
          ),
        ],
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: mediaQuery.size.width * 0.05,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade800, Colors.purpleAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade800,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                'We are here to assist you. Reach out to us through any of the following channels:',
                style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.04, // 👈 Body text responsive
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.03),
              _buildSupportCard(
                context: context,
                title: 'WhatsApp Support',
                subtitle: '+9644250027',
                color: Colors.green,
                onTap: () async {
                  final phoneUrl = Uri(scheme: 'tel', path: '+9644250027');
                  if (await canLaunchUrl(phoneUrl)) {
                    await launchUrl(phoneUrl);
                  }
                },
              ),
              _buildSupportCard(
                context: context,
                title: 'Instagram Support',
                subtitle: '@flutter_with_prince',
                color: Colors.pink,
                onTap: () async {
                  const websiteUrl = 'https://www.instagram.com/flutter_with_prince?igsh=bTF4M3lpbDdkdmxj';
                  if (await canLaunch(websiteUrl)) {
                    await launch(websiteUrl);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color color,
    required Function() onTap,
  }) {
    final mediaQuery = MediaQuery.of(context); // 👈 MediaQuery inside card too

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(vertical: mediaQuery.size.height * 0.015), // 👈 Responsive margin
        padding: EdgeInsets.all(mediaQuery.size.width * 0.04), // 👈 Responsive padding
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(mediaQuery.size.width * 0.04), // 👈 Border Radius responsive
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: mediaQuery.size.width * 0.04, // 👈 Blur radius responsive
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: mediaQuery.size.width * 0.03), // 👈 Space at start
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.size.width * 0.045, // 👈 Title responsive
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: mediaQuery.size.width * 0.035, // 👈 Subtitle responsive
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: mediaQuery.size.width * 0.05, // 👈 Arrow Icon responsive
            ),
          ],
        ),
      ),
    );
  }
}




