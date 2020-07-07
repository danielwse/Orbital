import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/homepage_expenses.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Color(0xffF7F7F7),
                floatingActionButton: AddExpense(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                body: ListView(children: [
                  Column(children: <Widget>[
                    HomePageExpenses(),
                    //replace with planner homepage widget
                    Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        height: 200,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.tealAccent,
                        ),
                        child: Column(children: <Widget>[
                          Text('HAPPENING TODAY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.blueGrey,
                                fontSize: 20,
                                //insert planner widget
                              ))
                        ]))
                  ])
                ]))));
  }
}
