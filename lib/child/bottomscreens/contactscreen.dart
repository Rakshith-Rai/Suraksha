import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suraksha/db/deservices.dart';
import 'package:suraksha/model/contactsm.dart';
import 'package:suraksha/ulits/constant.dart';
import 'package:permission_handler/permission_handler.dart';

class Contactscreen extends StatefulWidget {
  const Contactscreen({super.key});

  @override
  State<Contactscreen> createState() => _ContactscreenState();
}

class _ContactscreenState extends State<Contactscreen> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = []; // List for filtered contacts
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String searchQuery = ''; // To hold the search query

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissons();
    if (permissionStatus == PermissionStatus.granted) {
      getAllcontacts();
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access to the contacts denied");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context, "Contact permissions are permanently denied.");
    }
  }

  Future<PermissionStatus> getContactsPermissons() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> getAllcontacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
      filteredContacts = _contacts; // Initialize filtered contacts
    });
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredContacts = contacts; // Reset to all contacts
      });
    } else {
      setState(() {
        filteredContacts = contacts.where((contact) {
          return (contact.displayName ?? '')
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Contacts',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                filterContacts(value); // Call filter function on text change
              },
            ),
          ),
          // List of Contacts
          Expanded(
            child: contacts.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = filteredContacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? 'No Name Available'),
                  leading: contact.avatar != null && contact.avatar!.isNotEmpty
                      ? CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 86, 176, 245),
                    backgroundImage: MemoryImage(contact.avatar!),
                  )
                      : CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 32, 101, 204),
                    child: Text(contact.initials()),
                  ),
                  onTap: () {
                    if (contact.phones!.isNotEmpty) {
                      final String phoneNum = contact.phones!.elementAt(0).value!;
                      final String name = contact.displayName!;
                      _addContact(TContact(phoneNum, name));
                    } else {
                      Fluttertoast.showToast(msg: "Oops! No phone number available");
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }
}
