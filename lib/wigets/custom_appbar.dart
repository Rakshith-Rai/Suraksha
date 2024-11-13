import 'package:flutter/material.dart';
import 'package:suraksha/ulits/quotes.dart';

// ignore: must_be_immutable
class CustomAppbar extends StatelessWidget {
  //const CustomAppbar({super.key});
  Function? onTap;
  int? quoteIndex;
  CustomAppbar({this.onTap,this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){onTap!();},
      child: Container(
        child: Text(sweetsayings[quoteIndex!],
        style: TextStyle(fontSize: 22),)
      
      ),
    );
  }
}