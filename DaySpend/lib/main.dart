import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Expenses.dart';
import 'Planner.dart';
import 'constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  final _pageOptions = [
    HomePage(),
    PlannerPage(),
    ExpensePage(),
  ];
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent, 
        currentIndex: _selectedPage,
        onTap: (int index) { 
          setState(() {
            _selectedPage = index;
          });
        },
        items:[ 
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.home),
            title: Text("Home")),
            BottomNavigationBarItem(  
              icon: Icon(EvaIcons.calendar),
              title: Text("Calender"),
            ),
            BottomNavigationBarItem( 
              icon: Icon(EvaIcons.pieChart),
              title: Text("Expenses")
            ),])
            ));
  }      
}
