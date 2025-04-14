import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplayer/view/Profile_Setup.dart';
import 'package:iplayer/view/login_screen.dart';
import 'package:iplayer/view/video_player_screen.dart';
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  bool _showAnimation = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
        "email": email,
        "uid": userCredential.user!.uid,
      });
      Utils.toastMessage("Account created successfully!");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => VideoApp()),
            (route) => false,
      );
    } catch (e) {
      Utils.toastMessage("Sign up failed: ${e.toString()}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
          ),

          Positioned(
            top: 200,
            left: 30,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 2),
              child: Text("Ready to Explore?\nLet’s Get You Signed Up!", style: TextStyle(color: Colors.purple.shade700, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 190),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildInputField(_emailController, "Email", Icons.email, false,),
                                SizedBox(height: 15),
                                _buildInputField(_passwordController, "Password", Icons.lock, false),
                                SizedBox(height: 55),
                                Card(elevation: 10,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: MouseRegion(
                                      onEnter: (_) => setState(() {}),
                                      child: ElevatedButton(
                                        onPressed: _signUp,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          padding: EdgeInsets.symmetric(vertical: 14),
                                        ),
                                        child: Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.black)),
                                      ),),
                                  ),),
                              ],),
                          ),),
                        Padding(
                          padding: const EdgeInsets.only(top: 160.0,left: 90),
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.black54, fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      String label, IconData icon, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,style: TextStyle(color: Colors.white,),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.white),

        filled: true,
        fillColor: Colors.purpleAccent.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),

      ),
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
    );
  }
}
