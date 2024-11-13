import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:suraksha/db/deservices.dart';
import 'package:suraksha/model/contactsm.dart';
import 'package:permission_handler/permission_handler.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _curentPosition;
  String? _curentAddress;

  // Request permissions at runtime
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.sms,
    ].request();

    if (statuses[Permission.location]!.isDenied ||
        statuses[Permission.sms]!.isDenied) {
      Fluttertoast.showToast(
          msg: "Location or SMS permission is denied. Please allow them.");
    }
  }

  // Check if permissions are granted
  Future<void> _checkPermissions() async {
    if (await Permission.sms.isGranted && await Permission.location.isGranted) {
      // Permissions granted, continue with location fetching and SMS sending
    } else {
      _requestPermissions();
    }
  }

  // Send SMS
  _sendSms(String phoneNumber, String message) async {
    if (await Permission.sms.isGranted) {
      SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber,
        message: message,
      );

      if (result == SmsStatus.sent) {
        Fluttertoast.showToast(msg: "Message sent");
      } else {
        Fluttertoast.showToast(msg: "Failed to send message");
      }
    } else {
      Fluttertoast.showToast(msg: "SMS permission not granted");
    }
  }

  // Handle location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable location services.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg: 'Location permissions are permanently denied.');
        return false;
      }
    }

    return true;
  }

  // Get current location
  _getCurrentLocation() async {
    if (await _handleLocationPermission()) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _curentPosition = position;
          _getAddressFromLatLon();
        });
      } catch (e) {
        Fluttertoast.showToast(msg: "Error fetching location: $e");
      }
    }
  }

  // Get address from latitude and longitude
  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
        "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _getCurrentLocation();
  }

  // Updated method name to 'showModalSafeHome'
  showModalSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOUR EMERGENCY CONTACTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                if (_curentPosition != null) Text(_curentAddress ?? ""),
                PrimaryButton(
                    title: "GET LOCATION",
                    onPressed: () {
                      _getCurrentLocation();
                    }),
                SizedBox(height: 10),
                PrimaryButton(
                    title: "SEND ALERT",
                    onPressed: () async {
                      List<TContact> contactList =
                      await DatabaseHelper().getContactList();
                      if (contactList.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Emergency contact list is empty");
                      } else {
                        String messageBody =
                            "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";

                        if (await Permission.sms.isGranted) {
                          contactList.forEach((element) {
                            _sendSms(
                                "${element.number}",
                                "I am in trouble. $messageBody");
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "SMS permission not granted");
                        }
                      }
                    }),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalSafeHome(context), // Corrected method call
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Send Location"),
                        subtitle: Text("Share Location"),
                      ),
                    ],
                  )),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/route.jpg')),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  PrimaryButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          title,
          style: TextStyle(fontSize: 17),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}
