import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:DaySpend/planner/homepage/planner_view.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/homepage_expenses.dart';
<<<<<<< HEAD
=======
import 'package:DaySpend/fonts/header.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:DaySpend/pdf/report.dart';
import 'package:pdf/pdf.dart';
>>>>>>> 0ca75e0a0bb6a730a037db7b7564aceb58fb1c79

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
