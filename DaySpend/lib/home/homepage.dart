import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:DaySpend/planner/homepage/planner_view.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/homepage_expenses.dart';
import 'package:DaySpend/fonts/header.dart';

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
      appBar: AppBar(
        brightness: Brightness.light,
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: AddExpense(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
