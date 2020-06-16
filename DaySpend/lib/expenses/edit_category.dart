import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final ExpensesBloc expensesBloc;
  final CategoryBloc categoryBloc;
  final String initialName;

  EditCategory(this.expensesBloc, this.categoryBloc, this.initialName);
  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final _renameController = TextEditingController();
  bool isChanged = false;
  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _renameController.text = widget.initialName;
    return super.initState();
  }

  void change() {
    setState(() {
      isChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
        height: 350,
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 450,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey[300],
                            spreadRadius: 5)
                      ]),
                  child: Column(children: [
                    Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.clear, size: 40)),
                              Text('Cancel')
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: <Widget>[
                              FlatButton(
                                  onPressed: isChanged
                                      ? () {
                                          widget.categoryBloc.renameCategory(
                                              widget.initialName,
                                              _renameController.text);
                                          widget.expensesBloc
                                              .getExpensesByCategory(
                                                  widget.initialName)
                                              .then((list) => list.isNotEmpty
                                                  ? list.forEach((expense) => {
                                                        widget.expensesBloc
                                                            .changeExpenseCategory(
                                                                _renameController
                                                                    .text,
                                                                expense.id)
                                                      })
                                                  : null);
                                          Navigator.of(context).pop();
                                        }
                                      : () {
                                          Navigator.of(context).pop();
                                        },
                                  child: Icon(Icons.done, size: 40)),
                              Text('Done')
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                            controller: _renameController,
                            onChanged: (value) {
                              change();
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
                    ]),
                  ]),
                )
              ]),
        ));
  }
}
