import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:flutter/material.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:DaySpend/database/db_models.dart';

class EditCategory extends StatefulWidget {
  final ExpensesBloc expensesBloc;
  final CategoryBloc categoryBloc;
  final Categories category;
  EditCategory(this.expensesBloc, this.categoryBloc, this.category);
  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final _renameController = TextEditingController();
  bool isChanged = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final percentageController = TextEditingController();
  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _renameController.text = widget.category.name;
    return super.initState();
  }

  void change() {
    setState(() {
      isChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: VariablesBloc().getMaxSpend(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? FutureBuilder(
                  future: CategoryBloc().getTotalBudgets(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot1) {
                    return snapshot1.hasData
                        ? Container(
                            margin: const EdgeInsets.only(
                                top: 5, left: 15, right: 15),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                color: Colors.grey[300],
                                                spreadRadius: 5)
                                          ]),
                                      child: Column(children: [
                                        Column(children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Icon(Icons.clear,
                                                          size: 40)),
                                                  Text('Cancel')
                                                ],
                                              ),
                                              Spacer(),
                                              Column(
                                                children: <Widget>[
                                                  FlatButton(
                                                      onPressed: isChanged &&
                                                              _formKey
                                                                  .currentState
                                                                  .validate()
                                                          ? () {
                                                              widget.categoryBloc
                                                                  .renameCategory(
                                                                      widget
                                                                          .category
                                                                          .name,
                                                                      _renameController
                                                                          .text);
                                                              widget
                                                                  .expensesBloc
                                                                  .getExpensesByCategory(
                                                                      widget
                                                                          .category
                                                                          .name)
                                                                  .then((list) => list
                                                                          .isNotEmpty
                                                                      ? list.forEach(
                                                                          (expense) =>
                                                                              {
                                                                                widget.expensesBloc.changeExpenseCategory(_renameController.text, expense.id)
                                                                              })
                                                                      : null);
                                                              String newBudget = percentageController
                                                                          .text ==
                                                                      '0'
                                                                  ? "Not Set"
                                                                  : percentageController
                                                                          .text
                                                                          .isEmpty
                                                                      ? widget
                                                                          .category
                                                                          .budgetPercentage
                                                                      : percentageController
                                                                          .text;
                                                              widget
                                                                  .categoryBloc
                                                                  .changeBudget(
                                                                      newBudget,
                                                                      widget
                                                                          .category
                                                                          .id);
                                                              widget
                                                                  .categoryBloc
                                                                  .getCategoryColor(
                                                                      _renameController
                                                                          .text);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }
                                                          : null,
                                                      child: Icon(Icons.done,
                                                          size: 40)),
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
                                                borderRadius:
                                                    BorderRadius.circular(10)),
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
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintText: 'Category Name',
                                                )),
                                          ),
                                          Form(
                                              key: _formKey,
                                              autovalidate: true,
                                              child: MoneyTextFormField(
                                                  percentRemainder: widget
                                                              .category
                                                              .budgetPercentage ==
                                                          "Not Set"
                                                      ? 100 - snapshot1.data
                                                      : 100 -
                                                          snapshot1.data +
                                                          double.parse(widget
                                                              .category
                                                              .budgetPercentage),
                                                  maxSpend:
                                                      snapshot.data != "Not Set"
                                                          ? double.parse(
                                                              snapshot.data)
                                                          : null,
                                                  settings:
                                                      MoneyTextFormFieldSettings(
                                                          onChanged: () =>
                                                              change(),
                                                          enabled:
                                                              snapshot.data ==
                                                                      "Not Set"
                                                                  ? false
                                                                  : true,
                                                          validator:
                                                              Validators.compose([
                                                            Validators.max(
                                                                widget.category
                                                                            .budgetPercentage ==
                                                                        "Not Set"
                                                                    ? 100 -
                                                                        snapshot1
                                                                            .data
                                                                    : 100 -
                                                                        snapshot1
                                                                            .data +
                                                                        double.parse(widget
                                                                            .category
                                                                            .budgetPercentage),
                                                                "% must be less than ${widget.category.budgetPercentage == "Not Set" ? 100 - snapshot1.data : 100 - snapshot1.data + double.parse(widget.category.budgetPercentage)}")
                                                          ]),
                                                          controller:
                                                              percentageController,
                                                          appearanceSettings:
                                                              AppearanceSettings(
                                                            hintText:
                                                                '0% to remove budget',
                                                            formattedStyle: snapshot
                                                                        .data ==
                                                                    "Not Set"
                                                                ? Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .disabledColor,
                                                                    )
                                                                : null,
                                                            inputStyle: snapshot
                                                                        .data ==
                                                                    "Not Set"
                                                                ? Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .disabledColor,
                                                                    )
                                                                : null,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                            labelText:
                                                                "Change Budget %",
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        20),
                                                          ))))
                                        ]),
                                      ]),
                                    )
                                  ]),
                            ))
                        : CircularProgressIndicator();
                  })
              : CircularProgressIndicator();
        });
  }
}
