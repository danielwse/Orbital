import 'package:flutter/material.dart';
//import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:DaySpend/constants.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      /*
      appBar: AppBar( 
        backgroundColor: Colors.black,
        title: Text("DaySpend",
        style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),*/
      body: Column(
        children: <Widget>[
          ClipPath( 
            clipper: MyClipper(),
            child: Container(
            height: 350,
            width: double.infinity,
            color: expensesColor,
            child: Container( 
              alignment: Alignment(-0.9, -0.80),
              child: Text(
              "Planner",
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Poppins",
              ),
            ),
          ),),),
          Expanded( 
             child: Container( 
               alignment: Alignment(-0.9,-0.9),
               width: double.infinity,
               child:  Text(
              "Planner",
              style: TextStyle(
                fontFamily: 'PlayfairDisplaySCBlack',
                  fontSize: 30,
              ),
              textAlign: TextAlign.center
            ),
          ),)
          
        ],
      ),
      ),
    );
  
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height-40, 
    size.width/2, size.height - 20);
    path.quadraticBezierTo(3/4 * size.width, size.height,
    size.width, size.height-30);
    path.lineTo(size.width,0);
    //path.close();
    return path;
  }
  @override 
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
