import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
      appBar: AppBar( 
        backgroundColor: Colors.black,
        title: Text("DaySpend",
        style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),*/
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Colors.blue,
            Colors.red,
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              "Welcome To DaySpend!",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 3
                    ..color = Colors.white),
              textAlign: TextAlign.center,
            ),
            margin: EdgeInsets.only(bottom: 50),
          ),
          Container(
            child: new RaisedButton(
              onPressed: () {},
              child: new Text("Calender"),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
          ),
          Container(
            child: new RaisedButton(
              onPressed: () {},
              child: new Text("To-Do List"),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
          )
        ],
      ),
    ));
  }
}
