import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/database/db_models.dart';

class EditExpense extends StatefulWidget {
  final ExpensesBloc expensesBloc;
  final CategoryBloc categoryBloc;
  final String initialDescription;
  final int expenseID;
  final double initialAmount;
  final String category;

  EditExpense(this.expensesBloc, this.categoryBloc, this.initialDescription,
      this.expenseID, this.initialAmount, this.category);
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

  void isEmpty() {
    if ((_amountController.text.isEmpty) || (_renameController.text.isEmpty)) {
      isButtonEnabled = false;
    }
    else {
      isButtonEnabled = true;
    }
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
                                  onPressed: isButtonEnabled ? () {
                                    if (descriptionChanged) {
                                      widget.expensesBloc.changeDescription(
                                        _renameController.text,
                                        widget.expenseID,
                                      );
                                    }
                                    if (amountChanged) {
                                      widget.expensesBloc.changeAmount(
                                          double.parse(_amountController.text),
                                          widget.expenseID);
                                          if (!categoryChanged) {
                                      widget.categoryBloc
                                          .removeAmountFromCategory(
                                              widget.initialAmount,
                                              widget.category);
                                      widget.categoryBloc.addAmountToCategory(
                                          double.parse(_amountController.text),
                                          widget.category);
                                          }
                                    }
                                    if (categoryChanged) {
                                      widget.expensesBloc.changeExpenseCategory(_currentCategory.name, widget.expenseID);
                                      
                                      widget.categoryBloc.removeAmountFromCategory(widget.initialAmount, widget.category);
                                      widget.categoryBloc.addAmountToCategory(double.parse(_amountController.text), _currentCategory.name); 
                                      
                                    }

                                    // widget.expensesBloc
                                    //     .getExpensesByCategory(
                                    //         widget.initialName)
                                    //     .then((list) => list.isNotEmpty
                                    //         ? list.forEach((expense) => {
                                    //               widget.expensesBloc
                                    //                   .changeExpenseCategory(
                                    //                       _renameController
                                    //                           .text,
                                    //                       expense.id)
                                    //             })
                                    //         : null);
                                    Navigator.of(context).pop();
                                  } : null,
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
                      _showCategoryPicker()
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
