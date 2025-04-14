import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iplayer/view/ProfileScreen.dart';
import 'package:iplayer/view/Subsciption_Screen.dart';
import 'package:iplayer/view/video_player_screen.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';


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

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  Future<String> getEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ?? 'Email not set';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: (profile.profileImage.isNotEmpty)
                              ? NetworkImage(profile.profileImage) // Use NetworkImage for Firebase URL
                              : AssetImage('assets/default_avatar.png') as ImageProvider,
                        ),
                        SizedBox(height: 10),
                        Text(
                          profile.name.isNotEmpty ? profile.name : 'User Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FutureBuilder<String>(
                          future: getEmail(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text('Loading...',
                                  style: TextStyle(color: Colors.white70, fontSize: 12));
                            } else if (snapshot.hasError) {
                              return Text('Error loading email',
                                  style: TextStyle(color: Colors.white70, fontSize: 12));
                            } else {
                              return Text(snapshot.data ?? 'Email not set',
                                  style: TextStyle(color: Colors.white70, fontSize: 12));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home_outlined, color: Colors.deepPurple),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VideoApp()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.paid_outlined, color: Colors.deepPurple),
                    title: Text('Subscription'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VideoApp()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: Colors.deepPurple),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(email: profile.name)),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.blue),
                    title: Text('Help and Support'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpAndSupportScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Colors.pink),
                    title: Text('Follow Me on Instagram'),
                    onTap: () async {
                      const instagramUrl =
                          'https://www.instagram.com/flutter_with_prince?igsh=bTF4M3lpbDdkdmxj';
                      if (await canLaunch(instagramUrl)) {
                        await launch(instagramUrl);
                      } else {
                        throw 'Could not launch $instagramUrl';
                      }
                    },
                  ),
                  SizedBox(height: 180),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: _logout,
                      child: Text("Log Out"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.015,
                          horizontal: MediaQuery.of(context).size.width * 0.2,
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.04),
                        ),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ),
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
  String age = 'Not set';
  String dob = 'Not set';
  String phone = 'Not set';
  String gender = 'Not set';
  String profileImage = '';

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
        age = data['age'] ?? 'Not set';
        dob = data['dob'] ?? 'Not set';
        phone = data['phone'] ?? 'Not set';
        gender = data['gender'] ?? 'Not set';
        profileImage = data['profileImage'] ?? '';

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

  // Upload image to Firebase Storage and update URL in Realtime Database
  Future<void> updateProfileImage(XFile image) async {
    try {
      if (userId.isEmpty) {
        print("User not logged in");
        return;
      }

      File file = File(image.path);
      String fileName = path.basename(file.path);

      Reference storageRef = _firebaseStorage.ref().child('profile_images/$fileName');

      await storageRef.putFile(file);
      String downloadUrl = await storageRef.getDownloadURL();

      DatabaseReference userRef = _database.ref().child('users/$userId');
      await userRef.update({'profileImage': downloadUrl});

      profileImage = downloadUrl;
      notifyListeners();
    } catch (e) {
      print("Error uploading profile image: $e");
    }
  }
}





class HelpAndSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VideoApp()));
          },
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: Text('Help & Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        decoration: BoxDecoration(
         color: Colors.white,),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We are here to assist you. Reach out to us through any of the following channels:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),
              _buildSupportCard(
                context: context,

                title: 'Email Support',
                subtitle: 'shivprajapati3435@gmail.com',
                color: Colors.deepPurple,
                onTap: () async {
                  final emailUrl = Uri(
                    scheme: 'mailto',
                    path: 'shivprajapati3435@gmail.com',
                    query: 'subject=Help%20and%20Support&body=Describe%20your%20issue%20here',
                  );
                  if (await canLaunchUrl(emailUrl)) {
                    await launchUrl(emailUrl);
                  }
                },
              ),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [

            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.black54)),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


