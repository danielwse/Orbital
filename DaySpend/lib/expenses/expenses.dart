import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/expense_db.dart';
import 'expense_db.dart';
import 'package:DaySpend/expenses/DatabaseBloc.dart';

class Expenses extends StatelessWidget {
  const Expenses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ClipPath(clipper: MyClipper(), child: MaxSpend()));
  }
}

class MaxSpend extends StatefulWidget {
  MaxSpend({Key key}) : super(key: key);

  @override
  _MaxSpendState createState() => _MaxSpendState();
}

class _MaxSpendState extends State<MaxSpend> {
  final _formKey = GlobalKey<FormState>();
  final bloc = VariablesBloc();
  String spend;
  TextEditingController _maxSpendController = TextEditingController();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    spend = DBProvider.db.maxSpend;
    print(spend);
    return Scaffold(
        body: SafeArea(
            child: Form(
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
                                padding: EdgeInsets.only(
                                    left: 100, right: 80, top: 5),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: _maxSpendController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Max Spend: $spend',
                                      labelStyle: TextStyle(fontSize: 18),
                                      hintText: "Enter This Week's Max Spend",
                                      hintMaxLines: 1),
                                  keyboardType: TextInputType.number,
                                  onEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    bloc.updateMaxSpend(
                                        _maxSpendController.text);

                                    setState(() {});
                                  },
                                )))),
                  ],
                ))));
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
