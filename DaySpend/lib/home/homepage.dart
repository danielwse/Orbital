import 'package:DaySpend/planner/homepage/planner_view.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/homepage_expenses.dart';

class Homepage extends StatefulWidget {
  final Function notificationFn;
  final Function disableNotificationFn;

  Homepage({this.notificationFn, this.disableNotificationFn});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        brightness: Brightness.light,
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HomePageExpenses(),
            PlannerHome(
              notificationFn: widget.notificationFn,
              disableNotificationFn: widget.disableNotificationFn,
            )
          ],
        ),
      ),
    );
  }
}
