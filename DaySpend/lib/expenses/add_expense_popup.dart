//bottom sheet when clicking on add button on homepage

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'package:DaySpend/expenses/database/db_models.dart';

class AddExpense extends StatefulWidget {
  AddExpense({Key key}) : super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  bool showFab = true;
  PersistentBottomSheetController bottomSheetController;
  @override
  Widget build(BuildContext context) {
    return showFab
        ? FloatingActionButton(
            child: Icon(Icons.add),
            mini: true,
            backgroundColor: Colors.lightBlue,
            onPressed: () {
              var bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (context) => BottomSheetWidget(
                      new ExpensesBloc(), new CategoryBloc()));
              showFloatingActionButton(false);
              bottomSheetController.closed.then((value) {
                showFloatingActionButton(true);
              });
            },
          )
        : Container();
  }

  void showFloatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}

//widget inside the pop-up
class BottomSheetWidget extends StatefulWidget {
  final ExpensesBloc expensesBloc;
  final CategoryBloc categoryBloc;
  BottomSheetWidget(this.expensesBloc, this.categoryBloc);
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
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
                    DecoratedTextField(widget.expensesBloc, widget.categoryBloc)
                  ]),
                )
              ]),
        ));
  }
}

class DecoratedTextField extends StatefulWidget {
  final ExpensesBloc expensesBloc;
  final CategoryBloc categoryBloc;
  const DecoratedTextField(this.expensesBloc, this.categoryBloc);

  @override
  _DecoratedTextFieldState createState() => _DecoratedTextFieldState();
}

class _DecoratedTextFieldState extends State<DecoratedTextField> {
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final CategoryBloc pickerCategoryBloc = CategoryBloc();
  Categories _currentCategory;
  bool isButtonEnabled = false;
  DateTime pickedDate = DateTime.now();
  String formattedDate;

  @override
  void initState() {
    formattedDate = convertDate(pickedDate);
    super.initState();
  } 

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    descriptionController.dispose();
    pickerCategoryBloc.dispose();
    amountController.dispose();

    super.dispose();
  }

  bool isEmpty() {
    setState(() {
      if ((descriptionController.text.isEmpty) ||
          (amountController.text.isEmpty) ||
          (_currentCategory == null)) {
        isButtonEnabled = false;
      } else {
        isButtonEnabled = true;
      }
    });
    return isButtonEnabled;
  }

  Widget _showCategoryPicker() {
    return StreamBuilder(
        stream: pickerCategoryBloc.categories,
        builder:
            (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
          if (!snapshot.hasData) return Container();
          return DropdownButton<Categories>(
            value: _currentCategory,
            items: snapshot.data
                .map((category) => DropdownMenuItem<Categories>(
                      child: Text(category.name),
                      value: category,
                    ))
                .toList(),
            onChanged: (Categories category) {
              setState(() {
                _currentCategory = category;
                isEmpty();
              });
            },
            isExpanded: false,
            hint: Text("Select Category"),
          );
        });
  }

  static String convertDate(DateTime datetime) {
    String result =
        "${datetime.year.toString()}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
    return result;
  }


  Widget _showDatePicker() {
    return MaterialButton(
      child: Text(
        convertDate(pickedDate),
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.orange,
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext builder) {
              return Container(
                child: CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        onDateTimeChanged: (DateTime newdate) {
          pickedDate = newdate;
          setState(() {
            formattedDate = convertDate(pickedDate);
          });
        },
        use24hFormat: true,
        maximumDate: new DateTime(DateTime.now().year, DateTime.now().month + 3,
            DateTime.now().day + 14),
        minimumYear: DateTime.now().year,
        maximumYear: DateTime.now().year,
        mode: CupertinoDatePickerMode.date),
                height: MediaQuery.of(context).copyWith().size.height / 3,
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
                  onPressed: isButtonEnabled
                      ? () {
                          widget.expensesBloc.newExpense(
                              descriptionController.text,
                              _currentCategory.name,
                              double.parse(amountController.text),
                              formattedDate);
                          widget.categoryBloc.addAmountToCategory(
                              double.parse(amountController.text),
                              _currentCategory.name);

                          Navigator.of(context).pop();
                        }
                      : null,
                  child: Icon(Icons.done, size: 40)),
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
            controller: descriptionController,
            onChanged: (val) {
              isEmpty();
            },
            autocorrect: true,
            showCursor: true,
            maxLengthEnforced: true,
            maxLength: 20,
            textAlign: TextAlign.start,
            decoration: InputDecoration.collapsed(
              hintText: 'Item Description',
            )),
      ),
      Container(
        height: 60,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: TextField(
            controller: amountController,
            onChanged: (val) {
              isEmpty();
            },
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            decoration: InputDecoration.collapsed(
              hintText: '0.00',
            )),
      ),
      SizedBox(height: 50, child: _showCategoryPicker()),
      _showDatePicker()
    ]);
  }
}

