import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suraksha/ulits/quotes.dart';
import 'package:suraksha/wigets/safewebview.dart';

class Customcaro extends StatelessWidget {
  const Customcaro({super.key});

  void nagvigateToRoute(BuildContext context,Widget route){
    Navigator.push(context,CupertinoPageRoute(builder: (context)=>route));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(items: List.generate(imageSliders.length,(index) => Card(elevation: 5.0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,image: NetworkImage(imageSliders[index]))
      ) ,child:InkWell(
        onTap:(){
            if(index==0)
            {
              nagvigateToRoute(context, Safewebview(
                url: "https://olympics.com/en/news/get-inspired-by-these-indian-women-athletes",
              ));
            } 
            else if(index==1){
              nagvigateToRoute(
                      context,
                      Safewebview(
                          url:
                              "https://plan-international.org/ending-violence/16-ways-end-violence-girls"));
            }
            else if(index==2){
              nagvigateToRoute(
                      context,
                      Safewebview(
                          url:
                              "https://www.healthline.com/health/womens-health/self-defense-tips-escape"));
            } 
            else{
              nagvigateToRoute(
                      context,
                      Safewebview(
                          url:
                              "https://www.healthline.com/health/womens-health/self-defense-tips-escape"));
            }   
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black.withOpacity(0.5),
            Colors.transparent,])
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(articleTitle[index],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            )),
        ),
      ),),
      )), options: CarouselOptions(aspectRatio: 2.0,autoPlay: true)),
    );
  }
}