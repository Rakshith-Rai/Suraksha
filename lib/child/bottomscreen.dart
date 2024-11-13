import 'package:flutter/material.dart';
import 'package:suraksha/child/bottomscreens/add_contacts.dart';
import 'package:suraksha/child/bottomscreens/chat_screen.dart';

//import 'package:suraksha/child/bottomscreens/contactscreen.dart';
import 'package:suraksha/child/bottomscreens/profilepage.dart';
import 'package:suraksha/child/bottomscreens/rating.dart';

import 'package:suraksha/home_screen.dart';

import 'bottomscreens/guide.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int _currentIndex = 0;

  // List of pages corresponding to each BottomNavigationBar item
  final List<Widget> _pages = [
    HomeScreen(),
    AddContactsPage(),
    ChatScreen(),
    ProfilePage(),
    Rating(),
    Guide(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the index when a tab is selected
          });
        },
        backgroundColor: Colors.white, // Set the background color
        selectedItemColor: Colors.blue, // Color of selected item
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'chat',
          ),
        ],
      ),
    );
  }
}