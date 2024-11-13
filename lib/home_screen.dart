import 'dart:math';
import 'package:flutter/material.dart';
//import 'package:liki_pro/child/bottomscreen.dart';
import 'package:suraksha/wigets/custom_appbar.dart';
import 'package:suraksha/wigets/customcaro.dart';
import 'package:suraksha/wigets/home_widgets/emergency.dart';
import 'package:suraksha/wigets/home_widgets/safehome/Safehome.dart';
import 'package:suraksha/wigets/livesafe.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int qIndex = 0;



  getRandomquote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(5);
    });
  }

  @override
  void initState() {
    getRandomquote();
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 206, 175),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomAppbar(
                  quoteIndex: qIndex,
                  onTap: getRandomquote,
                ),
                Customcaro(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Emergency",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Emergency(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Explore LiveSafe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Livesafe(),
                SafeHome(),

                 // Placed BottomPage() here



              ],
            ),
          ),
        ),
      ),
       // Placed BottomPage() here
    );
  }
}