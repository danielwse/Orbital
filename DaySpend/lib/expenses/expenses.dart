import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/database/db_models.dart';
import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:DaySpend/expenses/edit_category.dart';
import 'package:DaySpend/expenses/edit_expense.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:random_color/random_color.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:DaySpend/size_config.dart';

//max spend part at top of page
class MaxSpend extends StatefulWidget {
  final CategoryBloc categoryBloc;
  final VariablesBloc variablesBloc;
  MaxSpend(this.categoryBloc, this.variablesBloc);

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: variableBloc.getMaxSpend(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 10, vertical: height / 110),
                          child: Neumorphic(
                              style: NeumorphicStyle(
                                  color: Colors.white,
                                  intensity: 5,
                                  depth: -2,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(28))),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width / 4.5, right: width / 15),
                                  child: TextField(
                                    maxLength: 6,
                                    textAlign: TextAlign.center,
                                    controller: _maxSpendController,
                                    decoration: InputDecoration(
                                        counter: Offstage(),
                                        suffixIcon: IconButton(
                                            icon: Icon(Icons.check),
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              if (_maxSpendController
                                                  .text.isEmpty) {
                                                variableBloc
                                                    .updateMaxSpend("Not Set");
                                              } else {
                                                variableBloc.updateMaxSpend(
                                                    _maxSpendController.text ==
                                                            '0'
                                                        ? "Not Set"
                                                        : _maxSpendController
                                                            .text);
                                              }
                                              widget.categoryBloc
                                                  .addCategory(null);
                                              widget.variablesBloc
                                                  .updateMaxSpend(null);
                                              _maxSpendController.clear();
                                              setState(() {});
                                            }),
                                        border: InputBorder.none,
                                        labelText:
                                            'Max Spend: ${snapshot.data == '0' ? "Not Set" : snapshot.data}',
                                        labelStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        hintText: "Enter This Week's Max Spend",
                                        hintStyle: TextStyle(fontSize: 10),
                                        hintMaxLines: 2),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (_maxSpendController.text.isEmpty) {
                                        variableBloc.updateMaxSpend("Not Set");
                                      } else {
                                        variableBloc.updateMaxSpend(
                                            _maxSpendController.text == '0'
                                                ? "Not Set"
                                                : _maxSpendController.text);
                                      }
                                      widget.categoryBloc.addCategory(null);
                                      widget.variablesBloc.updateMaxSpend(null);
                                      _maxSpendController.clear();
                                      setState(() {});
                                    },
                                  )))),
                    ],
                  ))
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}

class Expenses extends StatefulWidget {
  Expenses({Key key}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final CategoryBloc categoryBloc = CategoryBloc();
  final categoryController = TextEditingController();
  final ExpensesBloc expensesBloc = ExpensesBloc();
  final SlidableController slidableController = SlidableController();
  final percentageController = TextEditingController();
  final VariablesBloc variablesBloc = VariablesBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Random random = new Random();

  @override
  dispose() {
    categoryBloc.dispose();
    categoryController.dispose();
    expensesBloc.dispose();
    percentageController.dispose();
    variablesBloc.dispose();
    super.dispose();
  }

  //row of add, category text at the top
  Widget categoryHeader() {
    return NeumorphicText(
      "Categories",
      textStyle: NeumorphicTextStyle(fontSize: 28, fontWeight: FontWeight.w300),
      style: NeumorphicStyle(
          lightSource: LightSource.top,
          intensity: 0.8,
          depth: 9,
          color: Colors.black,
          shape: NeumorphicShape.flat),
      textAlign: TextAlign.center,
    );
  }

  Color stringToColor(String stringColor) {
    String valueString = stringColor.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return new Color(value);
  }

//add category pop-up on clicking add icon in header
  void _showAddCategory(BuildContext context) {
    SizeConfig().init(context);

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return FutureBuilder(
              future: categoryBloc.getTotalBudgets(),
              builder:
                  (BuildContext context, AsyncSnapshot<dynamic> snapshot1) {
                return FutureBuilder(
                    future: variablesBloc.getMaxSpend(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return snapshot.hasData
                          ? SingleChildScrollView(
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  Container(
                                    height: SizeConfig.blockSizeVertical * 40,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    categoryController.clear();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Icon(Icons.clear,
                                                      size: 40)),
                                              Text('Cancel')
                                            ],
                                          ),
                                          Spacer(),
                                          Column(children: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Categories category = Categories(
                                                      name: categoryController
                                                          .text,
                                                      amount: 0,
                                                      budgetPercentage:
                                                          percentageController
                                                                  .text.isEmpty
                                                              ? "Not Set"
                                                              : percentageController
                                                                  .text,
                                                      color: RandomColor()
                                                          .randomColor(
                                                              colorBrightness:
                                                                  ColorBrightness
                                                                      .light)
                                                          .toString());
                                                  if (categoryController
                                                          .text.isNotEmpty &&
                                                      _formKey.currentState
                                                          .validate()) {
                                                    categoryBloc
                                                        .addCategory(category);

                                                    Navigator.of(context).pop();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    categoryController.clear();
                                                  }
                                                },
                                                child: Icon(Icons.check,
                                                    size: 40)),
                                            Text('Add')
                                          ]),
                                        ],
                                      ),
                                      Container(
                                          height:
                                              SizeConfig.blockSizeVertical * 7,
                                          alignment: Alignment.topCenter,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: TextFormField(
                                              controller: categoryController,
                                              autocorrect: true,
                                              showCursor: true,
                                              maxLengthEnforced: true,
                                              maxLength: 13,
                                              textAlign: TextAlign.start,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                hintText: 'Category Name',
                                              ))),
                                      Form(
                                          key: _formKey,
                                          autovalidate: true,
                                          child: MoneyTextFormField(
                                              percentRemainder:
                                                  100 - snapshot1.data,
                                              maxSpend: snapshot.data !=
                                                      "Not Set"
                                                  ? double.parse(snapshot.data)
                                                  : null,
                                              settings:
                                                  MoneyTextFormFieldSettings(
                                                      enabled: snapshot.data ==
                                                              "Not Set"
                                                          ? false
                                                          : true,
                                                      validator:
                                                          Validators.compose([
                                                        Validators.max(
                                                            100 -
                                                                snapshot1.data,
                                                            "% must be less than ${100 - snapshot1.data}")
                                                      ]),
                                                      controller:
                                                          percentageController,
                                                      appearanceSettings:
                                                          AppearanceSettings(
                                                        hintText: snapshot
                                                                    .data ==
                                                                "Not Set"
                                                            ? "Set A Max Spend"
                                                            : 'Not Set',
                                                        formattedStyle: snapshot
                                                                    .data ==
                                                                "Not Set"
                                                            ? Theme.of(context)
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
                                                            ? Theme.of(context)
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
                                                                horizontal: 20),
                                                        labelText:
                                                            "Budget: % of Max Spend",
                                                        labelStyle: TextStyle(
                                                            fontSize: 20),
                                                      ))))
                                    ]),
                                  )
                                ]))
                          : Container();
                    });
              });
        });
  }

  Widget getCategoriesWidget() {
    SizeConfig().init(context);
    return StreamBuilder(
        stream: categoryBloc.categories,
        builder:
            (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
          return StreamBuilder(
            stream: variablesBloc.variables,
            builder: (BuildContext context,
                AsyncSnapshot<List<Variable>> snapshot1) {
              return snapshot.hasData && snapshot1.hasData
                  ? SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Container(
                          margin: EdgeInsets.only(
                              top: 10,
                              bottom: 20,
                              left: SizeConfig.blockSizeHorizontal * 16,
                              right: SizeConfig.blockSizeHorizontal * 10),
                          height: SizeConfig.blockSizeVertical * 30,
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 2),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.8),
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int position) {
                              final item = snapshot.data[position];
                              final item1 = snapshot1.data[0];
                              final GlobalKey<FlipCardState> cardKey =
                                  GlobalKey<FlipCardState>();
                              final String budgetedAmount =
                                  item.budgetPercentage == "Set A Max Spend" ||
                                          item.budgetPercentage == "Not Set" ||
                                          item1.value == "Not Set"
                                      ? "Not Set"
                                      : (double.parse(item.budgetPercentage) *
                                              0.01 *
                                              double.parse(item1.value))
                                          .toStringAsFixed(2);
                              final String amountLeft = budgetedAmount !=
                                      'Not Set'
                                  ? (double.parse(budgetedAmount) - item.amount)
                                      .toStringAsFixed(2)
                                  : null;
                              if (item.name == "Others") {
                                return FlipCard(
                                    key: cardKey,
                                    direction: FlipDirection.HORIZONTAL,
                                    front: Neumorphic(
                                        style: NeumorphicStyle(
                                            lightSource: LightSource.topRight,
                                            color: Colors.white,
                                            intensity: 5,
                                            depth: 2,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(25))),
                                        child: Column(children: [
                                          Text(item.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400)),
                                          Spacer(),
                                          CircularPercentIndicator(
                                            radius:
                                                SizeConfig.blockSizeVertical *
                                                    8,
                                            lineWidth:
                                                SizeConfig.blockSizeHorizontal *
                                                    2,
                                            animation: true,
                                            percent: item.budgetPercentage ==
                                                    "Not Set"
                                                ? 0
                                                : double.parse(
                                                        item.budgetPercentage) *
                                                    0.01,
                                            center: new Text(
                                              item.budgetPercentage ==
                                                          "Set A Max Spend" ||
                                                      item.budgetPercentage ==
                                                          "Not Set"
                                                  ? "0%"
                                                  : item.budgetPercentage +
                                                      '\%',
                                              style: new TextStyle(
                                                  fontSize: SizeConfig
                                                          .blockSizeVertical *
                                                      2.5),
                                            ),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            progressColor:
                                                stringToColor(item.color),
                                          ),
                                          Spacer(),
                                          AutoSizeText(
                                            '${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" || amountLeft == null ? "Not Set" : double.parse(amountLeft) > 0 ? '\$' + amountLeft + ' left' : '\$' + double.parse(amountLeft).abs().toStringAsFixed(2) + ' exceeded'}',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: amountLeft == null
                                                    ? Colors.green
                                                    : double.parse(amountLeft) >
                                                            0
                                                        ? Colors.green
                                                        : Colors.red[800]),
                                          ),
                                        ])),
                                    back: Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                          new IconButton(
                                              color: Colors.blue[200],
                                              icon: Icon(Icons.edit, size: 30),
                                              onPressed: () {
                                                cardKey.currentState
                                                    .toggleCard();
                                                showBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        EditCategory(
                                                            expensesBloc,
                                                            categoryBloc,
                                                            item));
                                                slidableController.activeState
                                                    ?.close();
                                              }),
                                        ])));
                              }
                              return FlipCard(
                                  key: cardKey,
                                  direction: FlipDirection.HORIZONTAL,
                                  front: Neumorphic(
                                    style: NeumorphicStyle(
                                        lightSource: LightSource.topRight,
                                        color: Colors.white,
                                        intensity: 5,
                                        depth: 2,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(25))),
                                    child: Column(children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Spacer(),
                                      CircularPercentIndicator(
                                        radius:
                                            SizeConfig.blockSizeVertical * 8,
                                        lineWidth:
                                            SizeConfig.blockSizeHorizontal * 2,
                                        animation: true,
                                        percent:
                                            item.budgetPercentage == "Not Set"
                                                ? 0
                                                : double.parse(
                                                        item.budgetPercentage) *
                                                    0.01,
                                        center: new Text(
                                          item.budgetPercentage ==
                                                      "Set A Max Spend" ||
                                                  item.budgetPercentage ==
                                                      "Not Set"
                                              ? "0%"
                                              : item.budgetPercentage + '\%',
                                          style: new TextStyle(
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      2.5),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor:
                                            stringToColor(item.color),
                                      ),
                                      Spacer(),
                                      AutoSizeText(
                                        '${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" || amountLeft == null ? "Not Set" : double.parse(amountLeft) > 0 ? '\$' + amountLeft + ' left' : '\$' + double.parse(amountLeft).abs().toStringAsFixed(2) + ' exceeded'}',
                                        maxLines: 1,
                                        minFontSize: 10,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: amountLeft == null
                                                ? Colors.green
                                                : double.parse(amountLeft) > 0
                                                    ? Colors.green
                                                    : Colors.red[800]),
                                      ),
                                    ]),
                                  ),
                                  back: Container(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                        new IconButton(
                                            color: Colors.blue[200],
                                            icon: Icon(Icons.edit, size: 30),
                                            onPressed: () {
                                              cardKey.currentState.toggleCard();
                                              showBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      EditCategory(expensesBloc,
                                                          categoryBloc, item));
                                              slidableController.activeState
                                                  ?.close();
                                            }),
                                        new IconButton(
                                            color: Colors.redAccent,
                                            icon: Icon(Icons.delete_outline,
                                                size: 30),
                                            onPressed: () {
                                              categoryBloc
                                                  .deleteCategory(item.id);
                                              expensesBloc
                                                  .getExpensesByCategory(
                                                      item.name)
                                                  .then(
                                                      (list) => list.isNotEmpty
                                                          ? list
                                                              .forEach(
                                                                  (expense) => {
                                                                        expensesBloc.changeExpenseCategory(
                                                                            'Others',
                                                                            expense.id),
                                                                        categoryBloc.addAmountToCategory(
                                                                            expense.amount,
                                                                            'Others')
                                                                      })
                                                          : null);
                                            }),
                                      ])));
                            },
                          )))
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          );
        });
  }

  Widget receiptHeader() {
    return NeumorphicText(
      "Receipts",
      textStyle: NeumorphicTextStyle(fontSize: 28, fontWeight: FontWeight.w300),
      style: NeumorphicStyle(
          lightSource: LightSource.bottomRight,
          intensity: 0.3,
          depth: 10,
          color: Colors.black,
          shape: NeumorphicShape.concave),
      textAlign: TextAlign.center,
    );
  }

  Widget allReceipts() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: expensesBloc.expenses,
      builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
        return snapshot.hasData
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(children: [
                  SizedBox(
                      height: height / 3.2,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int position) {
                            final item = snapshot.data[position];

                            return FutureBuilder(
                              future:
                                  categoryBloc.getCategoryColor(item.category),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot1) {
                                return snapshot1.hasData
                                    ? Container(
                                        height: height / 14,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: width / 8,
                                            vertical: height / 180),
                                        child: Slidable(
                                            controller: slidableController,
                                            actionPane:
                                                SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.20,
                                            child: Neumorphic(
                                                style: NeumorphicStyle(
                                                    lightSource:
                                                        LightSource.topRight,
                                                    color: Colors.white,
                                                    intensity: 5,
                                                    depth: 4,
                                                    boxShape: NeumorphicBoxShape
                                                        .roundRect(BorderRadius
                                                            .circular(15))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4,
                                                                left: 18,
                                                                bottom: 10),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              Text(
                                                                  item
                                                                      .description,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                              Text("\$" +
                                                                  "${item.amount.toStringAsFixed(2)}")
                                                            ])),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 4,
                                                          right: 18,
                                                        ),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              Text(
                                                                "${item.category}",
                                                                style: TextStyle(
                                                                    color: stringToColor(
                                                                        snapshot1
                                                                            .data)),
                                                              ),
                                                              Text(item.date)
                                                            ])),
                                                  ],
                                                )),
                                            secondaryActions: <Widget>[
                                              new IconButton(
                                                  color: Colors.blue[200],
                                                  icon: Icon(Icons.edit,
                                                      size: 30),
                                                  onPressed: () {
                                                    showBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            EditExpense(
                                                                expensesBloc,
                                                                categoryBloc,
                                                                item.description,
                                                                item.id,
                                                                item.amount,
                                                                item.category,
                                                                item.date));
                                                    slidableController
                                                        .activeState
                                                        .close();
                                                  }),
                                              new IconButton(
                                                  color: Colors.redAccent,
                                                  icon: Icon(
                                                      Icons.delete_outline,
                                                      size: 30),
                                                  onPressed: () {
                                                    expensesBloc.deleteExpense(
                                                        item.id,
                                                        item.amount,
                                                        item.category);
                                                    categoryBloc
                                                        .removeAmountFromCategory(
                                                            item.amount,
                                                            item.category);
                                                  }),
                                            ]))
                                    : Container();
                              },
                            );
                          }))
                ]))
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: NeumorphicTheme.baseColor(context),
            resizeToAvoidBottomInset: false,
            floatingActionButton: SpeedDial(
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
                child: NeumorphicIcon(
                  Icons.add,
                  size: 45,
                  style: NeumorphicStyle(depth: 40, intensity: 0.9),
                ),
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                children: [
                  SpeedDialChild(
                      child: Icon(
                        Icons.receipt,
                        size: 25,
                      ),
                      backgroundColor: NeumorphicTheme.baseColor(context),
                      label: 'Add Expense',
                      labelStyle: TextStyle(fontSize: 15),
                      onTap: () => showBottomSheet(
                          context: context,
                          builder: (context) =>
                              BottomSheetWidget(expensesBloc, categoryBloc))),
                  SpeedDialChild(
                      child: Icon(
                        Icons.category,
                        size: 25,
                      ),
                      backgroundColor: NeumorphicTheme.baseColor(context),
                      label: "Add Category",
                      labelStyle: TextStyle(fontSize: 15),
                      onTap: () => _showAddCategory(context))
                ]),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SafeArea(
                    child: Flex(direction: Axis.vertical, children: [
                  Expanded(
                      child: ListView(children: [
                    Column(
                      children: <Widget>[
                        MaxSpend(categoryBloc, variablesBloc),
                        categoryHeader(),
                        getCategoriesWidget(),
                        receiptHeader(),
                        allReceipts()
                      ],
                    )
                  ]))
                ])))));
  }
}
