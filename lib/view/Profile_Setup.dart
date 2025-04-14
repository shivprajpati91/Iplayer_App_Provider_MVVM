// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:iplayer/view/video_player_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_animate/flutter_animate.dart';
//
// class ProfileSetupScreen extends StatefulWidget {
//   @override
//   _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
// }
//
// class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController bioController = TextEditingController();
//   String gender = "Male";
//   String? profileImagePath;
//   File? _image;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }
//
//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       nameController.text = prefs.getString('name') ?? '';
//       ageController.text = prefs.getString('age') ?? '';
//       dobController.text = prefs.getString('dob') ?? '';
//       phoneController.text = prefs.getString('phone') ?? '';
//       gender = prefs.getString('gender') ?? 'Male';
//       profileImagePath = prefs.getString('profileImagePath');
//       if (profileImagePath != null) {
//         _image = File(profileImagePath!);
//       }
//     });
//   }
//
//   Future<void> _saveProfileData() async {
//     if (nameController.text.isEmpty ||
//         ageController.text.isEmpty ||
//         dobController.text.isEmpty ||
//         phoneController.text.isEmpty ||
//         profileImagePath == null) {
//       Fluttertoast.showToast(
//         msg: "Please fill in all fields & select a profile image!",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('name', nameController.text);
//     await prefs.setString('age', ageController.text);
//     await prefs.setString('dob', dobController.text);
//     await prefs.setString('phone', phoneController.text);
//     await prefs.setString('gender', gender);
//     await prefs.setString('profileImagePath', profileImagePath!);
//
//     Fluttertoast.showToast(
//       msg: "Profile Saved Successfully!",
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//     );
//
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => VideoApp()));
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         profileImagePath = pickedFile.path;
//       });
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('profileImagePath', profileImagePath!);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Profile Setup",
//           style: GoogleFonts.lato(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: Container(
//         padding:
//         EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Dynamic padding
//         decoration: BoxDecoration(color: Colors.white),
//         height: double.infinity,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Center(
//                 child: InkWell(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: MediaQuery.of(context).size.width * 0.13,
//                     backgroundColor: Colors.grey,
//                     backgroundImage: _image != null
//                         ? FileImage(_image!)
//                         : (profileImagePath != null
//                         ? FileImage(File(profileImagePath!))
//                         : AssetImage('assets/default_avatar.png'))
//                     as ImageProvider,
//                     child: _image == null && profileImagePath == null
//                         ? Icon(
//                       Icons.camera_alt,
//                       color: Colors.white70,
//                       size:
//                       MediaQuery.of(context).size.width * 0.08,
//                     )
//                         : null,
//                   ),
//                 ),
//               ).animate().fadeIn(duration: 1000.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOut),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//               _buildTextField("Name", nameController, Icons.person),
//               _buildTextField(
//                 "Age",
//                 ageController,
//                 Icons.cake,
//                 keyboardType: TextInputType.number,
//               ),
//               _buildTextField("Date of Birth", dobController, Icons.calendar_today, isDateField: true),
//               _buildTextField(
//                 "Phone Number",
//                 phoneController,
//                 Icons.phone,
//                 keyboardType: TextInputType.phone,
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//               DropdownButtonFormField<String>(
//                 value: gender,
//                 dropdownColor: Colors.purple.shade50,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     gender = newValue!;
//                   });
//                 },
//                 icon: Icon(Icons.arrow_drop_down, color: Colors.black),
//                 items: ["Male", "Female", "Other"]
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value, style: TextStyle(color: Colors.black)),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.1),
//               ElevatedButton(
//                 onPressed: _saveProfileData,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple.shade200,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: Text(
//                   "Save Profile",
//                   style: GoogleFonts.lato(
//                     fontSize:
//                     MediaQuery.of(context).size.width * 0.05,
//                     color: Colors.white,
//                   ),
//                 ),
//               ).animate().fadeIn(duration: 1200.ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
//             ],
//           ),),
//       ),);
//   }
//   Widget _buildTextField(String label,
//       TextEditingController controller, IconData icon, {
//         TextInputType keyboardType = TextInputType.text,
//         bool isDateField = false,
//       }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         readOnly: isDateField,
//         onTap: isDateField
//             ? () async {
//
//           DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(1900),
//             lastDate: DateTime.now(),
//           );
//           if (pickedDate != null) {
//             String formattedDate =
//                 "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//             setState(() {
//               controller.text = formattedDate;
//             });
//           }}
//             : null,
//         style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
//         decoration: InputDecoration(
//           hintText: label,
//           prefixIcon: Icon(icon, color: Colors.purpleAccent),
//           filled: true,
//           fillColor: Colors.purple.shade50,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide.none),
//         ),
//       ),
//     );
//   }
//
//
// }
