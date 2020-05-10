import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(  
        backgroundColor: Colors.black,
        title: Text("DaySpend",
        style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(  
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome To DaySpend!",
            style: TextStyle( 
              fontSize: 32,
              fontWeight: FontWeight.bold,
              foreground: Paint()
              ..style = PaintingStyle.fill
              ..strokeWidth = 3
              ..color = Colors.blue
            )
            ),
          new RaisedButton(onPressed: () {},
          child: new Text("Calender"),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          new RaisedButton(onPressed: () {},
          child : new Text("To-Do List"),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          )
          ],
        ),)
      );
    }
  }
