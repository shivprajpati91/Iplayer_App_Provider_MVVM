import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplayer/view/video_player_screen.dart';
import '../FadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../res/component/round_button.dart';
import '../utils/utils.dart';
import 'Profile_Setup.dart';
import 'Sign_In.dart';

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

  void _showPuzzleToast() {
    TextEditingController answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Solve the Puzzle 🧩",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$_num1 + $_num2 = ?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                hintText: "Enter your answer",
                filled: true,
                fillColor: Colors.purpleAccent.shade100.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              int? userAnswer = int.tryParse(answerController.text);
              if (userAnswer == _correctAnswer) {
                Fluttertoast.showToast(
                  msg: "It's Correct!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.purpleAccent,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

                setState(() {
                  _showAnimation = true;
                });

                await Future.delayed(Duration(seconds: 1));

                setState(() {
                  _showAnimation = false;
                });

                Navigator.pop(context); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileSetupScreen()),
                );
              } else {
                Fluttertoast.showToast(
                  msg: "Wrong! Try Again!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.purpleAccent,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            child: Text(
              "Submit",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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

      Utils.toastMessage("Login Successful!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoApp()));

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
                      key: _formKey, // Assign the form key
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
                                onPressed: _showPuzzleToast, // Call _login method
                                child: Text(
                                  "PUZZLE",
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
