import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'home.dart';
import 'planner.dart';
import 'expenses.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> pages = [Expenses(), Home(), Planner()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageView(
        children: pages,
        scrollDirection: Axis.horizontal,
        controller: controller,
      ),
    );
  }
}
