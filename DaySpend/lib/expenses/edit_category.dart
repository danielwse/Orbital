import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:flutter/material.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:DaySpend/database/db_models.dart';
import 'package:DaySpend/fonts/header.dart';

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
  bool categoryChanged = false;
  bool isChanged = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _categoryFormKey = GlobalKey<FormState>();
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

  void categoryChange() {
    setState(() {
      categoryChanged = true;
    });
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
                  future: CategoryBloc().categoryNameList(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
                    return FutureBuilder(
                        future: CategoryBloc().getTotalBudgets(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot1) {
                          return snapshot1.hasData
                              ? SingleChildScrollView(
                                  child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 300,
                                          child: Column(children: [
                                            Column(children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Icon(
                                                              Icons.clear,
                                                              size: 40)),
                                                      Text('Cancel')
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Header(
                                                    text: 'Edit Category',
                                                    italic: false,
                                                    shadow: Shadow(
                                                        blurRadius: 2.5,
                                                        color: Colors.black26,
                                                        offset: Offset(0, 1)),
                                                    weight: FontWeight.w600,
                                                    color: Colors.black54,
                                                    size: MediaQuery.of(context)
                                                            .copyWith()
                                                            .size
                                                            .width /
                                                        20,
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    children: <Widget>[
                                                      FlatButton(
                                                          onPressed: isChanged &&
                                                                      _formKey
                                                                          .currentState
                                                                          .validate() &&
                                                                      _renameController
                                                                          .text
                                                                          .isNotEmpty ||
                                                                  categoryChanged &&
                                                                      _renameController
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      _categoryFormKey
                                                                          .currentState
                                                                          .validate()
                                                              ? () {
                                                                  if (_categoryFormKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    widget.categoryBloc.renameCategory(
                                                                        widget
                                                                            .category
                                                                            .name,
                                                                        _renameController
                                                                            .text);
                                                                  }
                                                                  widget
                                                                      .expensesBloc
                                                                      .getExpensesByCategory(widget
                                                                          .category
                                                                          .name)
                                                                      .then((list) => list
                                                                              .isNotEmpty
                                                                          ? list.forEach((expense) =>
                                                                              {
                                                                                widget.expensesBloc.changeExpenseCategory(_renameController.text, expense.id)
                                                                              })
                                                                          : null);
                                                                  String newBudget = percentageController.text ==
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
                                                          child: Icon(
                                                              Icons.done,
                                                              size: 40)),
                                                      Text('Done')
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                  height: 70,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Form(
                                                    key: _categoryFormKey,
                                                    autovalidate: false,
                                                    child: TextFormField(
                                                        validator: (value) => snapshot2
                                                                .data
                                                                .contains(
                                                                    _renameController
                                                                        .text
                                                                        .toLowerCase())
                                                            ? "Category Already Exists"
                                                            : null,
                                                        controller:
                                                            _renameController,
                                                        onChanged: (value) {
                                                          categoryChange();
                                                        },
                                                        autocorrect: true,
                                                        showCursor: true,
                                                        maxLengthEnforced: true,
                                                        maxLength: 20,
                                                        textAlign:
                                                            TextAlign.start,
                                                        decoration:
                                                            InputDecoration
                                                                .collapsed(
                                                          hintText:
                                                              'Category Name',
                                                        )),
                                                  )),
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
                                                      maxSpend: snapshot.data != "Not Set"
                                                          ? double.parse(
                                                              snapshot.data)
                                                          : null,
                                                      settings:
                                                          MoneyTextFormFieldSettings(
                                                              onChanged: () =>
                                                                  change(),
                                                              enabled: snapshot
                                                                          .data ==
                                                                      "Not Set"
                                                                  ? false
                                                                  : true,
                                                              validator:
                                                                  Validators.compose([
                                                                Validators.max(
                                                                    widget.category.budgetPercentage ==
                                                                            "Not Set"
                                                                        ? 100 -
                                                                            snapshot1
                                                                                .data
                                                                        : 100 -
                                                                            snapshot1.data +
                                                                            double.parse(widget.category.budgetPercentage),
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
                                                                          color:
                                                                              Theme.of(context).disabledColor,
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
                                                                          color:
                                                                              Theme.of(context).disabledColor,
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
                              : Container(
                                  height: 300,
                                  color: Colors.transparent,
                                  child: Center(
                                      child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  )));
                        });
                  })
              : Container(
                  height: 300,
                  color: Colors.transparent,
                  child: Center(
                      child: SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  )));
        });
  }
}
