import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:DaySpend/fonts/header.dart';
<<<<<<< HEAD
import 'package:DaySpend/database/db_models.dart';
import 'package:DaySpend/database/DatabaseBloc.dart';
=======
import 'package:DaySpend/expenses/database/db_models.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'dart:math';
>>>>>>> parent of c4e349c... design improvments and bug fixes

class HomePageExpenses extends StatefulWidget {
  @override
  _HomePageExpensesState createState() => _HomePageExpensesState();
}

class _HomePageExpensesState extends State<HomePageExpenses> {
  CategoryBloc categoryBloc = CategoryBloc();
  VariablesBloc variablesBloc = VariablesBloc();
  final _random = Random();
  var list = [
    RoundedProgressBarTheme.blue,
    RoundedProgressBarTheme.red,
    RoundedProgressBarTheme.green,
    RoundedProgressBarTheme.purple,
    RoundedProgressBarTheme.yellow,
    RoundedProgressBarTheme.midnight
  ];

  @override
  void dispose() {
    categoryBloc.dispose();
    variablesBloc.dispose();
    super.dispose();
  }

  Widget budgetBars() {
    return StreamBuilder(
        stream: categoryBloc.categories,
        builder:
            (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
          return snapshot.hasData
              ? FutureBuilder(
                  future: variablesBloc.getMaxSpend(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot1) {
                    return snapshot1.hasData
                        ? SingleChildScrollView(
                            child: Column(children: <Widget>[
                            SizedBox(
                                height: 220,
                                child: ListView.builder(
                                    itemCount: snapshot.data
                                        .where((element) =>
                                            element.budgetPercentage !=
                                            "Not Set")
                                        .length,
                                    itemBuilder: (context, int position) {
                                      final item = snapshot.data[position];
                                      double percentSpent = snapshot1.data !=
                                              "Not Set"
                                          ? (item.amount /
                                                  (double.parse(item
                                                          .budgetPercentage) *
                                                      0.01 *
                                                      double.parse(
                                                          snapshot1.data))) *
                                              100
                                          : null;
                                      return Column(children: [
                                        SizedBox(
                                            width: 300,
                                            child: Row(children: <Widget>[
                                              Text(
                                                item.name,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                              Spacer(),
                                              Icon(
                                                percentSpent == null
                                                    ? Icons.warning
                                                    : percentSpent >= 100
                                                        ? Icons.mood_bad
                                                        : percentSpent >= 80
                                                            ? Icons
                                                                .sentiment_dissatisfied
                                                            : Icons.mood,
                                                color: percentSpent == null
                                                    ? Colors.red
                                                    : percentSpent >= 100
                                                        ? Colors.red
                                                        : percentSpent >= 80
                                                            ? Colors.orange
                                                            : Colors.green,
                                              )
                                            ])),
                                        SizedBox(
                                            width: 300,
                                            child: RoundedProgressBar(
                                              percent: percentSpent == null
                                                  ? 100
                                                  : percentSpent,
                                              height: 12,
                                              theme: list[
                                                  _random.nextInt(list.length)],
                                              style: RoundedProgressBarStyle(
                                                  borderWidth: 0,
                                                  widthShadow: 0),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            )),
                                        percentSpent == null
                                            ? SizedBox(
                                                child: Text(
                                                  "Start Budgeting Today!",
                                                  textAlign: TextAlign.center,
                                                ),
                                                width: 300,
                                              )
                                            : Container()
                                      ]);
                                    }))
                          ]))
                        : Container();
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: MyClipper(),
        child: Container(
            height: 350,
            width: double.infinity,
            color: Color(0xffF7F7F7),
            child: Container(
                child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Header(
                    text: 'DaySpend',
                    size: 20,
                    italic: true,
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings, size: 25),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications, size: 25),
                  ),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.assessment, size: 25))
                ],
              ),
              Center(
                heightFactor: 1,
                child: Header(
                  text: 'BUDGETS',
                  size: 20,
                  italic: false,
                ),
              ),
              SizedBox(height: 40),
              budgetBars()
            ]))));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 20;
    while (curXPos < size.width) {
      curXPos += increment;
      path.arcToPoint(Offset(curXPos, curYPos), radius: Radius.circular(5));
    }
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
