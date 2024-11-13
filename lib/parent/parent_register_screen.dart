import 'package:flutter/material.dart';
import 'package:suraksha/db/deservices.dart'; // Import the DBHelper
import 'package:suraksha/model/user_model.dart';
import '../componets/custom_text.dart';
import '../componets/secondarybuttons.dart';
import '../wigets/home_widgets/safehome/Safehome.dart'; // Import the User model

class ParentRegisterScreen extends StatefulWidget {
  @override
  State<ParentRegisterScreen> createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, String>();
  bool isLoading = false;
  bool isPasswordVisible = false;

  _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      final dbHelper = DatabaseHelper();
      final newUser = User(
        username: _formData['username'] ?? '', // Use null-aware operators
        email: _formData['email'] ?? '',
        password: _formData['password'] ?? '',
        fullName: _formData['fullName'] ?? '',
        dateOfBirth: _formData['dateOfBirth'] ?? '',
        gender: _formData['gender'] ?? '',
        homeAddress: _formData['homeAddress'] ?? '',
        workAddress: _formData['workAddress'] ?? '',
        nearestSafePlace: _formData['nearestSafePlace'] ?? '',
        phoneNumber: _formData['phoneNumber'] ?? '',
        emergencyContact: _formData['emergencyContact'] ?? '',
        medicalConditions: _formData['medicalConditions'] ?? '',
      );

      // Check if email already exists
      bool emailExists = await dbHelper.isEmailExist(newUser.email);
      if (emailExists) {
        _showDialog('Email already exists. Please use another one.');
      } else {
        await dbHelper.insertUser(newUser);
        Navigator.pop(context); // Go back to login screen after registration
      }
    } catch (e) {
      _showDialog(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows resizing when keyboard opens
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "REGISTER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink),
                          ),
                          Image.asset(
                            'assets/logo.png',
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Full Name Field
                          CustomTextField(
                            hintText: 'Enter Full Name',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.name,
                            prefix: Icon(Icons.person),
                            onsave: (value) {
                              _formData['fullName'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                          ),
                          // Username Field
                          CustomTextField(
                            hintText: 'Enter Username',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.name,
                            prefix: Icon(Icons.person),
                            onsave: (value) {
                              _formData['username'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty || value.length < 3) {
                                return 'Please enter a valid username';
                              }
                              return null;
                            },
                          ),
                          // Email Field
                          CustomTextField(
                            hintText: 'Enter Email',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.email),
                            onsave: (value) {
                              _formData['email'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          // Date of Birth Field
                          CustomTextField(
                            hintText: 'Enter Date of Birth (YYYY-MM-DD)',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.datetime,
                            prefix: Icon(Icons.calendar_today),
                            onsave: (value) {
                              _formData['dateOfBirth'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your date of birth';
                              }
                              return null;
                            },
                          ),
                          // Gender Field
                          CustomTextField(
                            hintText: 'Enter Gender',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.text,
                            prefix: Icon(Icons.person_outline),
                            onsave: (value) {
                              _formData['gender'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your gender';
                              }
                              return null;
                            },
                          ),
                          // Home Address Field
                          CustomTextField(
                            hintText: 'Enter Home Address',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.streetAddress,
                            prefix: Icon(Icons.home),
                            onsave: (value) {
                              _formData['homeAddress'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your home address';
                              }
                              return null;
                            },
                          ),
                          // Work Address Field
                          CustomTextField(
                            hintText: 'Enter Work Address',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.streetAddress,
                            prefix: Icon(Icons.work),
                            onsave: (value) {
                              _formData['workAddress'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your work address';
                              }
                              return null;
                            },
                          ),
                          // Phone Number Field
                          CustomTextField(
                            hintText: 'Enter Phone Number',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.phone,
                            prefix: Icon(Icons.phone),
                            onsave: (value) {
                              _formData['phoneNumber'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          // Emergency Contact Field
                          CustomTextField(
                            hintText: 'Enter Emergency Contact',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.phone,
                            prefix: Icon(Icons.contact_phone),
                            onsave: (value) {
                              _formData['emergencyContact'] = value ?? "";
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an emergency contact';
                              }
                              return null;
                            },
                          ),
                          // Medical Conditions Field (Optional)
                          CustomTextField(
                            hintText: 'Enter Medical Conditions (Optional)',
                            textInputAction: TextInputAction.done,
                            keyboardtype: TextInputType.text,
                            prefix: Icon(Icons.medical_services),
                            onsave: (value) {
                              _formData['medicalConditions'] = value ?? "";
                            },
                          ),
                          // Password Field
                          CustomTextField(
                            hintText: 'Enter Password',
                            isPassword: !isPasswordVisible,
                            prefix: Icon(Icons.lock),
                            validate: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Password must be at least 7 characters';
                              }
                              return null;
                            },
                            onsave: (value) {
                              _formData['password'] = value ?? "";
                            },
                            suffix: IconButton(
                              icon: Icon(isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          // Register Button
                          PrimaryButton(
                            title: 'REGISTER',
                            onPressed: _onSubmit,
                          ),
                        ],
                      ),
                    ),
                    // Secondary Button for Login
                    Secondarybuttons(
                      title: 'Already have an account? Login',
                      onPressed: () {
                        Navigator.pop(context); // Navigate to Login
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
