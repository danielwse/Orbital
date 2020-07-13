
import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:DaySpend/planner/homepage/planner_view_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/homepage_expenses.dart';


class Homepage extends StatefulWidget {
  final Function notificationFn;
  final Function disableNotificationFn;

  Homepage({this.notificationFn,this.disableNotificationFn});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xffF7F7F7),
            floatingActionButton: AddExpense(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
            body: SingleChildScrollView(child:Column(children: <Widget>[
              HomePageExpenses(),
              PlannerHome(notificationFn: widget.notificationFn, disableNotificationFn: widget.disableNotificationFn,)
              //replace with planner homepage widget
            ],),),),);
  }
}
