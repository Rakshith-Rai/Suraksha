import 'package:flutter/cupertino.dart';
import 'package:suraksha/wigets/home_widgets/emergencys/ambulanceemergency.dart';
import 'package:suraksha/wigets/home_widgets/emergencys/armyemergency.dart';
import 'package:suraksha/wigets/home_widgets/emergencys/fireemergency.dart';
import 'package:suraksha/wigets/home_widgets/emergencys/policeemergency.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceEmergency(),
          Ambulanceemergency(),
          FirebrigadeEmergency(),
          ArmyEmergency()
        ],
      ),

    );
  }
}