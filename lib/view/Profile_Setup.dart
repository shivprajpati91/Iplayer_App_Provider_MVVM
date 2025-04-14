// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iplayer/view/video_player_screen.dart';
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
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/${user.uid}");
//       DataSnapshot snapshot = await dbRef.get();
//
//       if (snapshot.exists) {
//         Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
//         setState(() {
//           nameController.text = userData['name'] ?? '';
//           ageController.text = userData['age'] ?? '';
//           dobController.text = userData['dob'] ?? '';
//           phoneController.text = userData['phone'] ?? '';
//           gender = userData['gender'] ?? 'Male';
//           profileImagePath = userData['profileImagePath'];
//           if (profileImagePath != null) {
//             _image = File(profileImagePath!);
//           }
//         });
//       }
//     }
//   }
//
//   Future<void> _saveProfileData() async {
//     if (nameController.text.isEmpty ||
//         ageController.text.isEmpty ||
//         dobController.text.isEmpty ||
//         phoneController.text.isEmpty ||
//         profileImagePath == null) {
//       // Fluttertoast.showToast(
//       //   msg: "Please fill in all fields & select a profile image!",
//       //   backgroundColor: Colors.red,
//       //   textColor: Colors.white,
//       // );
//       return;
//     }
//
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/${user.uid}");
//       await dbRef.set({
//         "name": nameController.text,
//         "age": ageController.text,
//         "dob": dobController.text,
//         "phone": phoneController.text,
//         "gender": gender,
//         "profileImagePath": profileImagePath,
//       });
//       //
//       // Fluttertoast.showToast(
//       //   msg: "Profile Saved Successfully!",
//       //   backgroundColor: Colors.green,
//       //   textColor: Colors.white,
//       // );
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => VideoApp()),
//       );
//     }
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
//         padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
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
//                         : AssetImage('assets/default_avatar.png')
//                     as ImageProvider),
//                     child: _image == null && profileImagePath == null
//                         ? Icon(
//                       Icons.camera_alt,
//                       color: Colors.white70,
//                       size: MediaQuery.of(context).size.width * 0.08,
//                     )
//                         : null,
//                   ),
//                 ),
//               ),
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
//                     fontSize: MediaQuery.of(context).size.width * 0.05,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label,
//       TextEditingController controller, IconData icon,
//       {TextInputType keyboardType = TextInputType.text, bool isDateField = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         readOnly: isDateField,
//         onTap: isDateField
//             ? () async {
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
//           }
//         }
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
// }
