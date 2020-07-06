import 'homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:DaySpend/planner/planner.dart';
import 'package:DaySpend/expenses/expenses.dart';

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

  List<Widget> pages = [Expenses(),Homepage(), Planner()];

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
