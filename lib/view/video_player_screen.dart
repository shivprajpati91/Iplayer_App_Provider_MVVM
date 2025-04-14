import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path ;
import 'package:permission_handler/permission_handler.dart';

import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'Library_Screen.dart';
import 'Play_Screen.dart';
import 'ProfileScreen.dart';
import 'Subsciption_Screen.dart';
import 'login_screen.dart';
import 'package:animate_do/animate_do.dart';

import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animate_do/animate_do.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';

import 'Library_Screen.dart';
import 'Play_Screen.dart';
import 'Subsciption_Screen.dart';
import 'login_screen.dart';

import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'Library_Screen.dart';
import 'Play_Screen.dart';
import 'Subsciption_Screen.dart';
import 'login_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'Library_Screen.dart';
import 'Play_Screen.dart';
import 'Subsciption_Screen.dart';
import 'login_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}
class _VideoAppState extends State<VideoApp> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  final List<Widget> _screens = [
    LibraryScreen(),
    SubscriptionScreen(),
  ];
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.forward(from: 0.0);
    });
  }
  Future<void> _pickVideo(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlayScreen(videoPath: pickedFile.path)),
      );}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      FloatingNavBar(
        resizeToAvoidBottomInset: false,
        color: Colors.purpleAccent.shade700,
        items: [
          FloatingNavBarItem(
            iconData: Icons.video_library,
            title: 'Library',
            page: LibraryScreen(),
          ),
          FloatingNavBarItem(
            iconData: Icons.attach_money,
            title: 'Subscription',
            page: SubscriptionScreen(),
          ),
          FloatingNavBarItem(
            iconData: Icons.person_2_outlined,
            title: 'Profile',
            page:ProfileScreen(email: ' emailController.text',),
          ),

        ],
        selectedIconColor: Colors.white,
        hapticFeedback: true,
        horizontalPadding: 40,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120,left: 280),
        child: FloatingActionButton(
          onPressed: () => _pickVideo(context),
          child: Icon(Icons.play_arrow_rounded, size: 35, color: Colors.white),
          backgroundColor: Colors.purpleAccent,
          elevation: 10,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );}
}
class CurvedBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final AnimationController animationController;

  const CurvedBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedNavBarClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1, // Responsive height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade700,
              Colors.purpleAccent.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: MediaQuery.of(context).size.width * 0.03,
              spreadRadius: MediaQuery.of(context).size.width * 0.01,
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          notchMargin: MediaQuery.of(context).size.width * 0.02,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.video_library, "Library", 0),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              _buildNavItem(Icons.attach_money, "Subscription", 2),
            ],
          ),),
      ),);}
  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: selectedIndex == index
                    ? 1.1 + (animationController.value * 0.1)
                    : 0.9,
                child: child,
              );
            },
            child: Icon(
              icon,
              color: selectedIndex == index ? Colors.white : Colors.white70,
              size: 28,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: selectedIndex == index ? Colors.white : Colors.white60,
              fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),],
      ),);
  }}
class CurvedNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 35;

    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(
        size.width * 0.5, curveHeight, size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 60);

    // Create a smooth bottom curve
    path.quadraticBezierTo(
        size.width / 4, size.height + 20, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 60, size.width, size.height - 30);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
