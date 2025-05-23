import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:iplayer/view/video_player_screen.dart';
import '../FadeAnimation.dart';

import 'package:lottie/lottie.dart';
import '../res/component/round_button.dart';
import '../utils/utils.dart';
import 'Profile_Setup.dart';
import 'Sign_In.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showAnimation = false;

  int _num1 = 0;
  int _num2 = 0;
  int _correctAnswer = 0;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }
  void _generatePuzzle() {
    Random  random = Random();
    _num1 = random.nextInt(10) +1;
    _num2 = random.nextInt(10) +1;
    _correctAnswer = _num1 + _num2;
  }





  void _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Create user data
        Map<String, dynamic> userData = {
          "uid": user.uid,

          "email": user.email ?? "",

          "provider": "google",
          "lastLogin": DateTime.now().toIso8601String(),
        };

        // Save to Firebase Realtime Database
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(user.uid);
        await userRef.set(userData);

        Utils.toastMessage("Signed in as ${user.displayName}");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VideoApp()),
        );
      }
    } catch (e) {
      Utils.toastMessage("Sign-in failed: $e");
    }
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Utils.toastMessage("Please enter email and password");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Store user data in Realtime Database
        Map<String, dynamic> userData = {
          "uid": user.uid,
          "email": user.email ?? "",
          "provider": "email",
          "lastLogin": DateTime.now().toIso8601String(),
        };

        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(user.uid);
        await userRef.set(userData);

        Utils.toastMessage("Login Successful!");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoApp()));
      }

    } catch (e) {
      Utils.toastMessage("Login failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04, ),
          child: Stack(
            children: [

              Container(
                height: MediaQuery.of(context).size.height * 0.96,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // Dynamic padding
                    child: Form(
                      key: _formKey, 
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                          FadeAnimation(
                            delay: 1,
                            child: TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.purpleAccent.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          FadeAnimation(
                            delay: 1,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.purpleAccent.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          FadeAnimation(
                            delay: 2,
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.07, // Dynamic height for button
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.grey.shade300, width: 2), // Green border
                                  ),
                                ),
                                onPressed: _login, // Call _login method
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0, top: 0),
                                  child: RoundButton(
                                    title: 'Login',
                                    loading: false, // You can manage loading state if needed
                                    onPress: () {
                                      _login(); // Call the updated _login method
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                          FadeAnimation(
                            delay: 2,
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.07, // Dynamic height for button
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.grey.shade400)
                                  ),
                                ),
                                onPressed: _handleGoogleSignIn, // Call _login method
                                child: Text(
                                  "Google-Sign",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purpleAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 180,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    FadeAnimation(
                      delay: 2,
                      translateX: -50,
                      child: Text(
                        "स्वागतम् 🪔",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.10,
                          fontWeight: FontWeight.w600,
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),


                    FadeAnimation(
                      delay: 4,
                      translateX: -50,
                      child: Text(
                        "Login Now to Unlock the Experience!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 300,
                child: _showAnimation
                    ? Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset("Anim/login2.json"),
                )
                    : SizedBox.shrink(),
              ),
              Positioned(
                bottom: 10,
                left: 80,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  ),
                  child: Row(
                    children: [
                      Text("Dont have an account?", style: TextStyle(color: Colors.black54, fontSize: 14)),
                      Text("  Sign-Up",style: TextStyle(color: Colors.blue),),
                    ],
                  ),
                ),
              ),


              Positioned(
                top: 0,
                right: -170,
                child: FadeAnimation(
                  delay: -5,
                  translateX: -50,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.22,
                    width: MediaQuery.of(context).size.width * 2,
                    child: Lottie.asset("Anim/bird.json"),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
