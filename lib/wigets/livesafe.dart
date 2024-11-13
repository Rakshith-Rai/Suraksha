import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suraksha/wigets/home_widgets/lifesafe/Hospitlcard.dart';
import 'package:suraksha/wigets/home_widgets/lifesafe/busstatioincard.dart';
import 'package:suraksha/wigets/home_widgets/lifesafe/pharmacycard.dart';
import 'package:suraksha/wigets/home_widgets/lifesafe/policesation.dart';
import 'package:url_launcher/url_launcher.dart';

class  Livesafe extends StatelessWidget {
  const  Livesafe({super.key});

  static Future<void> openMap(String location) async{
    String googleUrl='https://www.google.com/maps/search/$location';
    final Uri _url = Uri.parse(googleUrl);
    try {
      await launchUrl(_url);
    } catch (e) {
      Fluttertoast.showToast(msg: 'somthing went wrong call emergency number');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
         Policesation(onMapFunction:openMap),
         Hospitlcard(onMapFunction:openMap),
         Pharmacycard (onMapFunction:openMap),
         Busstatioincard (onMapFunction:openMap),

        ],

      ),//
    );
  }
}