import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/db/deservices.dart';
import 'package:suraksha/model/user_model.dart';
import 'package:suraksha/parent/chil_login_scren.dart'; // Make sure this import is correct

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final dbHelper = DatabaseHelper();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _workAddressController = TextEditingController();
  final TextEditingController _nearestSafePlaceController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _medicalConditionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadImage();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      user = await dbHelper.getUserByEmail(email);
      if (user != null) {
        _usernameController.text = user!.username;
        _emailController.text = user!.email;
        _fullNameController.text = user!.fullName ?? '';
        _dateOfBirthController.text = user!.dateOfBirth ?? '';
        _genderController.text = user!.gender ?? '';
        _homeAddressController.text = user!.homeAddress ?? '';
        _workAddressController.text = user!.workAddress ?? '';
        _nearestSafePlaceController.text = user!.nearestSafePlace ?? '';
        _phoneNumberController.text = user!.phoneNumber ?? '';
        _emergencyContactController.text = user!.emergencyContact ?? '';
        _medicalConditionsController.text = user!.medicalConditions ?? '';
      }
    }
    setState(() {});
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _saveImage(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _saveImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Check if image exists and delete it if so
    if (_image != null && await _image!.exists()) {
      await _image!.delete();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  Future<void> _saveChanges() async {
    if (user != null) {
      User updatedUser = User(
        id: user!.id,
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: user!.password,
        fullName: _fullNameController.text.trim(),
        dateOfBirth: _dateOfBirthController.text.trim(),
        gender: _genderController.text.trim(),
        homeAddress: _homeAddressController.text.trim(),
        workAddress: _workAddressController.text.trim(),
        nearestSafePlace: _nearestSafePlaceController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim(),
        medicalConditions: _medicalConditionsController.text.trim(),
      );

      await dbHelper.updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? Icon(Icons.camera_alt) : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField('Username', _usernameController),
            _buildTextField('Email', _emailController, readOnly: true),
            _buildTextField('Full Name', _fullNameController),
            _buildTextField('Date of Birth', _dateOfBirthController),
            _buildTextField('Gender', _genderController),
            _buildTextField('Home Address', _homeAddressController),
            _buildTextField('Work Address', _workAddressController),
            _buildTextField('Nearest Safe Place', _nearestSafePlaceController),
            _buildTextField('Phone Number', _phoneNumberController),
            _buildTextField('Emergency Contact', _emergencyContactController),
            _buildTextField('Medical Conditions', _medicalConditionsController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
