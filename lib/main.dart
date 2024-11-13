import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha/parent/chil_login_scren.dart'; // Ensure this points to the correct login screen
import 'package:suraksha/child/bottomscreen.dart'; // Ensure this points to the bottom screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suraksha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.playfairDisplayTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 162, 26)),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Use the splash screen as the home
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with your app logo
            Image.asset(
              'assets/app_logo.jpg',
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
