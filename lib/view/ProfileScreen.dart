
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:iplayer/view/video_player_screen.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class ProfileScreen extends StatefulWidget {
  @override
  final String email;

  const ProfileScreen({Key? key, required this.email}) : super(key: key);
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedGender = '';
  String profileImage = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _loadProfile() async {
    try {
      final String emailKey = widget.email.replaceAll('.', '_');
      DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/$emailKey");

      // Fetch data once using .get()
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          dobController.text = data['dob'] ?? '';
          phoneController.text = data['phone'] ?? '';
          selectedGender = data['gender'] ?? '';
          addressController.text = data['address'] ?? '';
          profileImage = data['profileImage'] ?? '';
        });
      } else {
        _showError("No profile found for this user.");
      }
    } catch (error) {
      _showError("Error loading profile: $error");
    }
  }



  double _calculateProfileCompletion() {
    int completedFields = 0;
    if (nameController.text.isNotEmpty) completedFields++;
    if (emailController.text.isNotEmpty) completedFields++;
    if (dobController.text.isNotEmpty) completedFields++;
    if (phoneController.text.isNotEmpty) completedFields++;
    if (selectedGender.isNotEmpty) completedFields++;
    if (addressController.text.isNotEmpty) completedFields++;
    if (profileImage.isNotEmpty) completedFields++;
    return completedFields / 7;
  }

  @override
  Widget build(BuildContext context) {
    double completionPercentage = _calculateProfileCompletion();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(child: Icon(Icons.turn_left,color: Colors.white,),onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VideoApp()));
        }),
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
                    name: nameController.text,
                    email: emailController.text,
                    dob: dobController.text,
                    phone: phoneController.text,
                    gender: selectedGender,
                    image: profileImage,
                    address: addressController.text,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  nameController.text = result['name'];
                  emailController.text = result['email'];
                  dobController.text = result['dob'];
                  phoneController.text = result['phone'];
                  selectedGender = result['gender'];
                  addressController.text = result['address'];
                  profileImage = result['profileImage'];
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purpleAccent),
                borderRadius: BorderRadius.circular(60),
              ),
              child: GestureDetector(
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
                  _profileDetail("Name", nameController.text, Icons.person),
                  _divider(),
                  _profileDetail("Email", emailController.text, Icons.email),
                  _divider(),
                  _profileDetail("Date of Birth", dobController.text, Icons.calendar_today),
                  _divider(),
                  _profileDetail("Phone", phoneController.text, Icons.phone),
                  _divider(),
                  _profileDetail("Gender", selectedGender, Icons.wc),
                  _divider(),
                  _profileDetail("Address", addressController.text, Icons.home),
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
  final String name, email, dob, phone, gender, image, address;
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
      File imageFile = File(pickedFile.path);
      String imageUrl = await _uploadImage(imageFile);

      setState(() {
        profileImage = imageUrl;
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = 'profiles/${DateTime.now().millisecondsSinceEpoch}.jpg';
    firebase_storage.UploadTask uploadTask = firebase_storage.FirebaseStorage.instance
        .ref(fileName)
        .putFile(imageFile);

    firebase_storage.TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();

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

    // Save to Realtime Database
    DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/${emailController.text.replaceAll('.', '_')}");

    await dbRef.set({
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
        leading: InkWell(
          child: Icon(Icons.turn_left, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
        title: Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                        ? NetworkImage(profileImage)
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
