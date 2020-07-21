import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/database/db_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:DaySpend/fonts/header.dart';

class EditExpense extends StatefulWidget {
  final ExpensesBloc expensesBloc;
  final CategoryBloc categoryBloc;
  final String initialDescription;
  final int expenseID;
  final double initialAmount;
  final String category;
  final String date;

  EditExpense(this.expensesBloc, this.categoryBloc, this.initialDescription,
      this.expenseID, this.initialAmount, this.category, this.date);
  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final _renameController = TextEditingController();
  final _amountController = TextEditingController();
  final pickerCategoryBloc = CategoryBloc();
  bool amountChanged = false;
  bool descriptionChanged = false;
  bool categoryChanged = false;
  Categories _currentCategory;
  bool isButtonEnabled = false;
  DateTime pickedDate = DateTime.now();
  String formattedDate;
  bool dateChanged = false;

  @override
  void dispose() {
    _renameController.dispose();
    _amountController.dispose();
    pickerCategoryBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _renameController.text = widget.initialDescription;
    _amountController.text = widget.initialAmount.toString();
    formattedDate = widget.date;
    return super.initState();
  }

  void amountChange() {
    setState(() {
      amountChanged = true;
    });
  }

  void descriptionChange() {
    setState(() {
      descriptionChanged = true;
    });
  }

  void categoryChange() {
    setState(() {
      categoryChanged = true;
    });
  }

  void dateChange() {
    setState(() {
      dateChanged = true;
    });
  }

  void isEmpty() {
    if ((_amountController.text.isEmpty) || (_renameController.text.isEmpty)) {
      isButtonEnabled = false;
    } else {
      isButtonEnabled = true;
    }
  }

  static String convertDate(DateTime datetime) {
    String result =
        "${datetime.year.toString()}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
    return result;
  }

  static DateTime convertStringtoDatetime(String date) {
    String result =
        date.substring(0, 4) + date.substring(5, 7) + date.substring(8);
    return DateTime.parse(result);
  }

  Widget _showDatePicker() {
    return MaterialButton(
      child: Text(
        formattedDate,
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.orange,
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext builder) {
              return Container(
                child: CupertinoDatePicker(
                    initialDateTime: convertStringtoDatetime(widget.date),
                    onDateTimeChanged: (DateTime newDate) {
                      dateChange();
                      formattedDate = convertDate(newDate);
                      isEmpty();
                    },
                    use24hFormat: true,
                    maximumDate: DateTime.now(),
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
    return SingleChildScrollView(
        child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(children: [
                Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Header(
                        text: 'Edit Receipt',
                        italic: false,
                        shadow: Shadow(
                            blurRadius: 2.5,
                            color: Colors.black26,
                            offset: Offset(0, 1)),
                        weight: FontWeight.w600,
                        color: Colors.black54,
                        size: MediaQuery.of(context).copyWith().size.width / 20,
                      ),
                      Spacer(),
                      Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: isButtonEnabled
                                  ? () {
                                      if (dateChanged) {
                                        widget.expensesBloc.changeDate(
                                            formattedDate, widget.expenseID);
                                      }
                                      if (descriptionChanged) {
                                        widget.expensesBloc.changeDescription(
                                          _renameController.text,
                                          widget.expenseID,
                                        );
                                      }
                                      if (amountChanged) {
                                        widget.expensesBloc.changeAmount(
                                            double.parse(
                                                _amountController.text),
                                            widget.expenseID);
                                        if (!categoryChanged) {
                                          widget.categoryBloc
                                              .removeAmountFromCategory(
                                                  widget.initialAmount,
                                                  widget.category);
                                          widget.categoryBloc
                                              .addAmountToCategory(
                                                  double.parse(
                                                      _amountController.text),
                                                  widget.category);
                                        }
                                      }
                                      if (categoryChanged) {
                                        widget.expensesBloc
                                            .changeExpenseCategory(
                                                _currentCategory.name,
                                                widget.expenseID);

                                        widget.categoryBloc
                                            .removeAmountFromCategory(
                                                widget.initialAmount,
                                                widget.category);
                                        widget.categoryBloc.addAmountToCategory(
                                            double.parse(
                                                _amountController.text),
                                            _currentCategory.name);
                                      }
                                      Navigator.of(context).pop();
                                    }
                                  : null,
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
                          descriptionChange();
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
                        controller: _amountController,
                        onChanged: (val) {
                          amountChange();
                          isEmpty();
                        },
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Item Amount',
                        )),
                  ),
                  _showCategoryPicker(),
                  _showDatePicker()
                ]),
              ]),
            )
          ]),
    ));
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
                categoryChange();
                isEmpty();
              });
            },
            isExpanded: false,
            hint: Text("Select Category"),
          );
        });
  }
}
