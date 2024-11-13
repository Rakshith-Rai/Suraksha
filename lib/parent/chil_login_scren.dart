import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:suraksha/db/deservices.dart'; // Import the DBHelper
import 'package:suraksha/parent/parent_register_screen.dart'; // Import the Registration screen
import 'package:suraksha/child/bottomscreen.dart';

import '../model/user_model.dart'; // Import BottomPage

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, String?>{};
  bool isLoading = false;
  bool isPasswordShown = false;

  _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      final dbHelper = DatabaseHelper();
      final email = _formData['email'] ?? '';
      final password = _formData['password'] ?? '';

      User? user = await dbHelper.loginUser(email, password);
      if (user != null) {
        // Save user details and login status in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', user.username);
        await prefs.setString('email', user.email);
        await prefs.setBool('isLoggedIn', true); // Store login status

        // Navigate to the profile page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomPage()),
        );
      } else {
        _showDialog('Invalid email or password. Please try again.');
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "USER LOGIN",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 102, 102),
                  ),
                ),
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                  width: 120,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    prefixIcon: Icon(Icons.person),
                  ),
                  onSaved: (value) {
                    _formData['email'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: !isPasswordShown,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordShown
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordShown = !isPasswordShown;
                        });
                      },
                    ),
                  ),
                  onSaved: (value) {
                    _formData['password'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid password';
                    }
                    return null;
                  },
                ),
                if (isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text("Login"),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParentRegisterScreen()),
                        );
                      },
                      child: Text("Register"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
