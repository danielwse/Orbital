import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/database/db_models.dart';
import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:DaySpend/expenses/edit_category.dart';
import 'package:DaySpend/expenses/edit_expense.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:pdf/pdf.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:random_color/random_color.dart';
import 'package:DaySpend/size_config.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/pdf/report.dart';

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
                                            onPressed: () async {
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        hintText: "Enter This Week's Max Spend",
                                        hintStyle: TextStyle(
                                            fontSize: 12, color: Colors.black),
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
  final GlobalKey<FormState> _categoryFormKey = GlobalKey<FormState>();
  String mode = "recentReceipts";

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
    return Header(
      text: 'Categories',
      italic: false,
      shadow:
          Shadow(blurRadius: 2.5, color: Colors.black26, offset: Offset(0, 1)),
      weight: FontWeight.w600,
      color: Colors.black54,
      size: MediaQuery.of(context).copyWith().size.width / 15,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
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
                      return FutureBuilder(
                          future: categoryBloc.categoryNameList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot2) {
                            return snapshot.hasData
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
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                                child: Column(children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          FlatButton(
                                                              onPressed: () {
                                                                categoryBloc
                                                                    .calculateCategoryAmount(
                                                                        "Others");
                                                                generateReport(
                                                                    PdfPageFormat
                                                                        .a3);

                                                                categoryController
                                                                    .clear();
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
                                                        text: 'Add Category',
                                                        shadow: Shadow(
                                                            blurRadius: 2.5,
                                                            color:
                                                                Colors.black26,
                                                            offset:
                                                                Offset(0, 1)),
                                                        weight: FontWeight.w600,
                                                        color: Colors.black54,
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .width /
                                                            20,
                                                      ),
                                                      Spacer(),
                                                      Column(children: <Widget>[
                                                        FlatButton(
                                                            onPressed: () {
                                                              Categories category = Categories(
                                                                  name:
                                                                      categoryController
                                                                          .text,
                                                                  amount: 0,
                                                                  budgetPercentage: percentageController
                                                                          .text
                                                                          .isEmpty
                                                                      ? "Not Set"
                                                                      : percentageController
                                                                          .text,
                                                                  color: RandomColor()
                                                                      .randomColor(
                                                                          colorBrightness:
                                                                              ColorBrightness.light)
                                                                      .toString());
                                                              if (categoryController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  _formKey
                                                                      .currentState
                                                                      .validate() &&
                                                                  _categoryFormKey
                                                                      .currentState
                                                                      .validate()) {
                                                                categoryBloc
                                                                    .addCategory(
                                                                        category);

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        FocusNode());
                                                                categoryController
                                                                    .clear();
                                                              }
                                                            },
                                                            child: Icon(
                                                                Icons.check,
                                                                size: 40)),
                                                        Text('Add')
                                                      ]),
                                                    ],
                                                  ),
                                                  Container(
                                                      height: SizeConfig
                                                              .blockSizeVertical *
                                                          8.5,
                                                      alignment:
                                                          Alignment.topCenter,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      margin:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10)),
                                                      child: Form(
                                                          key: _categoryFormKey,
                                                          autovalidate: false,
                                                          child: TextFormField(
                                                              validator: (value) =>
                                                                  snapshot2.data.contains(categoryController.text.toLowerCase())
                                                                      ? "Category Already Exists"
                                                                      : null,
                                                              controller:
                                                                  categoryController,
                                                              autocorrect: true,
                                                              showCursor: true,
                                                              maxLengthEnforced:
                                                                  true,
                                                              maxLength: 13,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              decoration:
                                                                  InputDecoration.collapsed(
                                                                hintText:
                                                                    'Category Name',
                                                              )))),
                                                  Form(
                                                      key: _formKey,
                                                      autovalidate: true,
                                                      child: MoneyTextFormField(
                                                          percentRemainder:
                                                              100 -
                                                                  snapshot1
                                                                      .data,
                                                          maxSpend: snapshot
                                                                      .data !=
                                                                  "Not Set"
                                                              ? double.parse(
                                                                  snapshot.data)
                                                              : null,
                                                          settings:
                                                              MoneyTextFormFieldSettings(
                                                                  enabled: snapshot
                                                                              .data ==
                                                                          "Not Set"
                                                                      ? false
                                                                      : true,
                                                                  validator:
                                                                      Validators
                                                                          .compose([
                                                                    Validators.max(
                                                                        100 -
                                                                            snapshot1.data,
                                                                        "% must be less than ${100 - snapshot1.data}")
                                                                  ]),
                                                                  controller:
                                                                      percentageController,
                                                                  appearanceSettings:
                                                                      AppearanceSettings(
                                                                    hintText: snapshot.data ==
                                                                            "Not Set"
                                                                        ? "Set A Max Spend"
                                                                        : 'Not Set',
                                                                    formattedStyle: snapshot.data ==
                                                                            "Not Set"
                                                                        ? Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1
                                                                            .copyWith(
                                                                              color: Theme.of(context).disabledColor,
                                                                            )
                                                                        : null,
                                                                    inputStyle: snapshot.data ==
                                                                            "Not Set"
                                                                        ? Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1
                                                                            .copyWith(
                                                                              color: Theme.of(context).disabledColor,
                                                                            )
                                                                        : null,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20),
                                                                    labelText:
                                                                        "Budget: % of Max Spend",
                                                                    labelStyle: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ))))
                                                ]),
                                              )
                                            ])))
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
                    });
              });
        });
  }

  Widget getCategoriesWidget() {
    SizeConfig().init(context);
    double cellWidth = ((MediaQuery.of(context).size.width -
            (SizeConfig.blockSizeHorizontal * 20))) -
        60;
    double cellHeight = ((SizeConfig.blockSizeVertical * 30) - 4);
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
                              left: SizeConfig.blockSizeHorizontal * 10,
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
                              childAspectRatio: cellHeight / cellWidth,
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
                                                  color: Colors.black,
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
                                                  color: Colors.black,
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
                                          Text(
                                            '${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" || amountLeft == null ? "Not Set" : double.parse(amountLeft) > 0 ? '\$' + amountLeft + ' left' : '\$' + double.parse(amountLeft).abs().toStringAsFixed(2) + ' over'}',
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
                                    back: Neumorphic(
                                        style: NeumorphicStyle(
                                            lightSource: LightSource.topRight,
                                            color: Colors.white,
                                            intensity: 5,
                                            depth: 2,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(25))),
                                        child: Container(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                              new IconButton(
                                                  color: Colors.blue[200],
                                                  icon: Icon(Icons.edit,
                                                      size: 30),
                                                  onPressed: () {
                                                    cardKey.currentState
                                                        .toggleCard();
                                                    showModalBottomSheet(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                        ),
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder: (context) =>
                                                            EditCategory(
                                                                expensesBloc,
                                                                categoryBloc,
                                                                item));
                                                    slidableController
                                                        .activeState
                                                        ?.close();
                                                  }),
                                            ]))));
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
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                item.name,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
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
                                              color: Colors.black,
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
                                      Text(
                                        '${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" || amountLeft == null ? "Not Set" : double.parse(amountLeft) > 0 ? '\$' + amountLeft + ' left' : '\$' + double.parse(amountLeft).abs().toStringAsFixed(2) + ' over'}',
                                        maxLines: 1,
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
                                  back: Neumorphic(
                                      style: NeumorphicStyle(
                                          lightSource: LightSource.topRight,
                                          color: Colors.white,
                                          intensity: 5,
                                          depth: 2,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(25))),
                                      child: Center(
                                          child: ButtonBar(
                                              layoutBehavior:
                                                  ButtonBarLayoutBehavior
                                                      .constrained,
                                              alignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                            IconButton(
                                                color: Colors.blue[200],
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  cardKey.currentState
                                                      .toggleCard();
                                                  showModalBottomSheet(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                      ),
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) =>
                                                          EditCategory(
                                                              expensesBloc,
                                                              categoryBloc,
                                                              item));
                                                  slidableController.activeState
                                                      ?.close();
                                                }),
                                            IconButton(
                                                color: Colors.redAccent,
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                ),
                                                onPressed: () {
                                                  categoryBloc
                                                      .deleteCategory(item.id);
                                                  expensesBloc
                                                      .getExpensesByCategory(
                                                          item.name)
                                                      .then((list) =>
                                                          list.isNotEmpty
                                                              ? list.forEach(
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
                                          ]))));
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
    return Header(
      text: 'Receipts',
      italic: false,
      shadow:
          Shadow(blurRadius: 2.5, color: Colors.black26, offset: Offset(0, 1)),
      weight: FontWeight.w600,
      color: Colors.black54,
      size: MediaQuery.of(context).copyWith().size.width / 15,
    );
  }

  static DateTime convertStringtoDatetime(String date) {
    String result =
        date.substring(0, 4) + date.substring(5, 7) + date.substring(8);
    return DateTime.parse(result);
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
                          itemCount: mode == 'recentReceipts'
                              ? snapshot.data
                                  .where((element) =>
                                      convertStringtoDatetime(element.date)
                                          .isAfter(DateTime.now()
                                              .subtract(Duration(days: 7))))
                                  .length
                              : mode == 'month'
                                  ? snapshot.data
                                      .where((element) =>
                                          convertStringtoDatetime(element.date)
                                              .isAfter(DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  1)))
                                      .length
                                  : snapshot.data.length,
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
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18)),
                                                              Text(
                                                                "\$" +
                                                                    "${item.amount.toStringAsFixed(2)}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )
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
                                                              Text(item.date,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black))
                                                            ])),
                                                  ],
                                                )),
                                            secondaryActions: <Widget>[
                                              new IconButton(
                                                  color: Colors.blue[200],
                                                  icon: Icon(Icons.edit,
                                                      size: 30),
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                        ),
                                                        isScrollControlled:
                                                            true,
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
                                                    if (convertStringtoDatetime(
                                                            item.date)
                                                        .isAfter(DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            1))) {
                                                      categoryBloc
                                                          .removeAmountFromCategory(
                                                              item.amount,
                                                              item.category);
                                                    }
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
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                )),
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            floatingActionButton: SpeedDial(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: Icon(
                  Icons.menu,
                ),
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                children: [
                  mode == "recentReceipts"
                      ? SpeedDialChild(
                          child: Icon(
                            Icons.reply_all,
                            size: 25,
                          ),
                          backgroundColor: NeumorphicTheme.baseColor(context),
                          label: 'This Month\'s Receipts',
                          labelStyle: TextStyle(fontSize: 15),
                          onTap: () {
                            setState(() {
                              mode = 'month';
                            });
                          })
                      : SpeedDialChild(
                          child: Icon(
                            Icons.receipt,
                            size: 25,
                          ),
                          backgroundColor: NeumorphicTheme.baseColor(context),
                          label: 'Past 7 Day\'s Receipts',
                          labelStyle: TextStyle(fontSize: 15),
                          onTap: () {
                            setState(() {
                              mode = 'recentReceipts';
                            });
                          }),
                  SpeedDialChild(
                      child: Icon(
                        Icons.archive,
                        size: 25,
                      ),
                      backgroundColor: NeumorphicTheme.baseColor(context),
                      label: 'All Archived Receipts',
                      labelStyle: TextStyle(fontSize: 15),
                      onTap: () {
                        setState(() {
                          mode = 'archives';
                        });
                      }),
                  SpeedDialChild(
                      child: Icon(
                        Icons.receipt,
                        size: 25,
                      ),
                      backgroundColor: NeumorphicTheme.baseColor(context),
                      label: 'Add Expense',
                      labelStyle: TextStyle(fontSize: 15),
                      onTap: () => showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
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
