import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iplayer/view/video_player_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  String dob = "";
  String phone = "";
  String gender = "";
  String address = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String storedEmail = prefs.getString('email') ?? "";
    if (storedEmail.isNotEmpty) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(storedEmail).get();
      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'];
          email = userDoc['email'];
          dob = userDoc['dob'];
          phone = userDoc['phone'];
          gender = userDoc['gender'];
          address = userDoc['address'];
          profileImage = userDoc['profileImage'];
        });

        // Store locally for offline access
        await prefs.setString('name', name);
        await prefs.setString('dob', dob);
        await prefs.setString('phone', phone);
        await prefs.setString('gender', gender);
        await prefs.setString('address', address);
        await prefs.setString('profileImage', profileImage);
      }
    }
  }


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', pickedFile.path);
      setState(() {
        profileImage = pickedFile.path;
      });
    }
  }

  double _calculateProfileCompletion() {
    int completedFields = 0;
    if (name.isNotEmpty) completedFields++;
    if (email.isNotEmpty) completedFields++;
    if (dob.isNotEmpty) completedFields++;
    if (phone.isNotEmpty) completedFields++;
    if (gender.isNotEmpty) completedFields++;
    if (address.isNotEmpty) completedFields++;
    if (profileImage.isNotEmpty) completedFields++;
    return completedFields / 7;
  }

  @override
  Widget build(BuildContext context) {
    double completionPercentage = _calculateProfileCompletion();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(child: Icon(Icons.turn_left,color: Colors.white,),onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VideoApp()));
        },),
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    name: name,
                    email: email,
                    dob: dob,
                    phone: phone,
                    gender: gender,
                    image: profileImage, // Pass the existing image
                    address: address,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  name = result['name'];
                  email = result['email'];
                  dob = result['dob'];
                  phone = result['phone'];
                  gender = result['gender'];
                  address = result['address'];
                  profileImage = result['profileImage']; // Update profile image
                });
              }
            },

          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent),
            borderRadius: BorderRadius.circular(60)
            ),
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage.isNotEmpty
                      ? FileImage(File(profileImage))
                      : AssetImage("assets/default_avatar.png") as ImageProvider,
                  child: profileImage.isEmpty ? Icon(Icons.camera_alt, size: 40, color: Colors.white) : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: completionPercentage,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text("Profile Completion: ${(completionPercentage * 100).toInt()}%",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.1),
                    blurRadius: 2,
                    spreadRadius: 3,
                  )
                ],
              ),
              child: Column(
                children: [
                  _profileDetail("Name", name, Icons.person),
                  _divider(),
                  _profileDetail("Email", email, Icons.email),
                  _divider(),
                  _profileDetail("Date of Birth", dob, Icons.calendar_today),
                  _divider(),
                  _profileDetail("Phone", phone, Icons.phone),
                  _divider(),
                  _profileDetail("Gender", gender, Icons.wc),
                  _divider(),
                  _profileDetail("Address", address, Icons.home),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileDetail(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purpleAccent),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Divider(
        thickness: 1.5,
        color: Colors.purpleAccent.withOpacity(0.6),
        endIndent: 10,
        indent: 10,
      ),
    );
  }
}


class EditProfileScreen extends StatefulWidget {
  final String name, email, dob,
      phone, gender, image, address;
  EditProfileScreen({
    required this.name,
    required this.email,
    required this.dob,
    required this.phone,
    required this.gender,
    required this.image,
    required this.address,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  String selectedGender = "Male";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    dobController = TextEditingController(text: widget.dob);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
    selectedGender = widget.gender.isNotEmpty ? widget.gender : "Male";
    profileImage = widget.image;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _saveProfile() async {
    if (nameController.text.isEmpty) {
      _showError("Full Name is required!");
      return;
    }

    if (!_isValidEmail(emailController.text)) {
      _showError("Enter a valid email address!");
      return;
    }

    if (dobController.text.isEmpty) {
      _showError("Date of Birth is required!");
      return;
    }

    if (phoneController.text.isEmpty || phoneController.text.length < 10) {
      _showError("Phone number must be at least 10 digits!");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('dob', dobController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('gender', selectedGender);
    await prefs.setString('address', addressController.text);
    await prefs.setString('profileImage', profileImage);

    // Save to Firestore
    await FirebaseFirestore.instance.collection('users').doc(emailController.text).set({
      'name': nameController.text,
      'email': emailController.text,
      'dob': dobController.text,
      'phone': phoneController.text,
      'gender': selectedGender,
      'address': addressController.text,
      'profileImage': profileImage,
    });

    Navigator.pop(context, {
      'name': nameController.text,
      'email': emailController.text,
      'dob': dobController.text,
      'phone': phoneController.text,
      'gender': selectedGender,
      'address': addressController.text,
      'profileImage': profileImage,
    });
  }


  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(email);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(child: Icon(Icons.turn_left,color: Colors.white,),onTap: (){
          Navigator.pop(context);
        },),
        title: Text("Edit Profile", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image Picker with Overlay
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purpleAccent),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: profileImage.isNotEmpty
                        ? FileImage(File(profileImage))
                        : AssetImage("assets/default_avatar.png") as ImageProvider,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.purple.shade400,
                      radius: 22,
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purpleAccent.shade100),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _buildTextField("Full Name", nameController, TextInputType.text),
                      _divider(),
                      _buildTextField("Email", emailController, TextInputType.emailAddress),
                      _divider(),
                      _buildDatePickerField("Date of Birth", dobController),
                      _divider(),
                      _buildTextField("Phone", phoneController, TextInputType.phone),
                      _divider(),
                      _buildGenderDropdown(),
                      _divider(),
                      _buildTextField("Address", addressController, TextInputType.text),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 25),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.shade100,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return InkWell(
      onTap: _selectDate,
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          suffixIcon: Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      items: ["Male", "Female"].map((gender) {
        return DropdownMenuItem(value: gender, child: Text(gender));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedGender = value!;
        });
      },
      decoration: InputDecoration(border: InputBorder.none, labelText: "Gender"),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.purpleAccent, thickness: 1, height: 1);
  }
}
