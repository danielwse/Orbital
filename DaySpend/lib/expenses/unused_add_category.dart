import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DaySpend/expenses/db_models.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';

//widget inside the pop-up
class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      height: 190,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 190,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey[300],
                        spreadRadius: 5)
                  ]),
              child: Column(children: [DecoratedTextField()]),
            )
          ]),
    ));
  }
}

class DecoratedTextField extends StatefulWidget {
  DecoratedTextField({Key key}) : super(key: key);

  @override
  _DecoratedTextFieldState createState() => _DecoratedTextFieldState();
}

class _DecoratedTextFieldState extends State<DecoratedTextField> {
  final categoryController = TextEditingController();
  CategoryBloc _categoriesBloc = CategoryBloc();
  bool isButtonEnabled = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _categoriesBloc.dispose();
    categoryController.dispose();
    super.dispose();
  }

  bool isEmpty() {
    setState(() {
      if (categoryController.text.isEmpty) {
        isButtonEnabled = false;
      } else {
        isButtonEnabled = true;
      }
    });
    return isButtonEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Spacer(),
          Column(
            children: <Widget>[
              FlatButton(
                  onPressed: isButtonEnabled
                      ? () {
                          _categoriesBloc.addCategory(Categories(
                              name: categoryController.text,
                              amount: 0,
                              budget: 0));
                          Navigator.of(context).pop();
                          setState(() {});
                        }
                      : null,
                  child: Icon(Icons.check, size: 40)),
              Text('Add')
            ],
          ),
        ],
      ),
      Container(
        height: 60,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: TextField(
            controller: categoryController,
            onChanged: (val) {
              isEmpty();
            },
            autocorrect: true,
            showCursor: true,
            maxLengthEnforced: true,
            maxLength: 20,
            textAlign: TextAlign.start,
            decoration: InputDecoration.collapsed(
              hintText: 'Category Name',
            )),
      ),
    ]);
  }
}
