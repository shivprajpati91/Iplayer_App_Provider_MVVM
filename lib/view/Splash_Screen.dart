import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplayer/view/video_player_screen.dart';
import 'package:lottie/lottie.dart';
import '../Data/App_excaptions.dart';
import 'onboarding_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  Future<void> _startTimer() async {

    await Future.delayed(Duration(minutes: 20));
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw FetchDataException("No Internet Connection");
      }
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoApp()));
      } else {

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
      }
    } catch (e) {
      _showErrorDialog("An error occurred: ${e.toString()}");
    }
  }
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shadowColor: Colors.purpleAccent,
        title: Text(
          "Net On Krlo!",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.purpleAccent),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkLoginStatus();
            },
            child: Text("Retry", style: TextStyle(color: Colors.lightBlueAccent)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.47,
            left: screenWidth * 0.13,
            child: Lottie.asset("Anim/splash.json", height: screenHeight * 0.15),
          ),
          Positioned(
            top: screenHeight * 0.52,
            left: screenWidth * 0.25,
            child: Text(
              "EGOSTA DEVLOGS",
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
