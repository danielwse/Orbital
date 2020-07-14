import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/expenses/database/db_models.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';

class HomePageExpenses extends StatefulWidget {
  @override
  _HomePageExpensesState createState() => _HomePageExpensesState();
}

class _HomePageExpensesState extends State<HomePageExpenses> {
  CategoryBloc categoryBloc = CategoryBloc();
  VariablesBloc variablesBloc = VariablesBloc();
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

  Color stringToColor(String stringColor) {
    String valueString = stringColor.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return new Color(value);
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
                                    // itemCount: snapshot.data
                                    //     .where((element) =>
                                    //         element.budgetPercentage !=
                                    //         "Not Set")
                                    //     .length,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, int position) {
                                      final item = snapshot.data[position];
                                      double percentSpent = snapshot1.data !=
                                                  "Not Set" &&
                                              item.budgetPercentage != "Not Set"
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
                                            height: 30,
                                            child: Row(children: <Widget>[
                                              NeumorphicText(
                                                item.name,
                                                textStyle: NeumorphicTextStyle(
                                                    fontSize: 15),
                                                style: NeumorphicStyle(
                                                  color: Colors.black,
                                                ),
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
                                            child: NeumorphicIndicator(
                                              orientation:
                                                  NeumorphicIndicatorOrientation
                                                      .horizontal,
                                              percent: percentSpent == null
                                                  ? 1
                                                  : percentSpent * 0.01,
                                              height: 15,
                                              style: IndicatorStyle(
                                                  lightSource:
                                                      LightSource.topLeft,
                                                  depth: 10,
                                                  accent: stringToColor(
                                                      item.color)),
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
    return Container(
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
        ])));
  }
}
