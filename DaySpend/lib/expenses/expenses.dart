//entitre page when swipe right on homepage

import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'package:DaySpend/expenses/categories.dart';
import 'package:DaySpend/expenses/database/variables_db.dart';


class Expenses extends StatelessWidget {
  const Expenses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                    child: Column(
          children: <Widget>[MaxSpend(), SizedBox(height: 10),  BudgetList()],
        ))]))));
  }
}


//max spend part at top of page
class MaxSpend extends StatefulWidget {
  MaxSpend({Key key}) : super(key: key);

  @override
  _MaxSpendState createState() => _MaxSpendState();
}

class _MaxSpendState extends State<MaxSpend> {
  final _formKey = GlobalKey<FormState>();
  final VariablesBloc variableBloc = VariablesBloc();

  String spend;
  TextEditingController _maxSpendController = TextEditingController();

  @override
  void dispose() {
    variableBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: variableBloc.getMaxSpend(),
        builder: (context, snapshot) {
          return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                              padding:
                                  EdgeInsets.only(left: 100, right: 80, top: 5),
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _maxSpendController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText:
                                        'Max Spend: ${VariablesDao.maxSpend}',
                                    labelStyle: TextStyle(fontSize: 18),
                                    hintText: "Enter This Week's Max Spend",
                                    hintMaxLines: 1),
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  variableBloc
                                      .updateMaxSpend(_maxSpendController.text);

                                  setState(() {});
                                },
                              )))),
                ],
              ));
        });
  }
}
