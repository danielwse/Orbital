import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:DaySpend/planner/homepage/planner_view.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/homepage_expenses.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:DaySpend/pdf/report.dart';
import 'package:pdf/pdf.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Header(
              text: 'DaySpend',
              size: 20,
              italic: true,
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, size: 25, color: Colors.black),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, size: 25, color: Colors.black),
            ),
            IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PDFViewerScaffold(
                              path:
                                  '/data/user/0/com.example.DaySpend/cache/example.pdf')),
                    ),
                icon: Icon(
                  Icons.assessment,
                  size: 25,
                  color: Colors.black,
                ))
          ],
        ),
      ),
      floatingActionButton: AddExpense(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
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
