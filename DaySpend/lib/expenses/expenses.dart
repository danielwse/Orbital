import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'package:DaySpend/expenses/database/db_models.dart';
import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:DaySpend/expenses/edit_category.dart';
import 'package:DaySpend/expenses/edit_expense.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Expenses extends StatelessWidget {
  const Expenses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SafeArea(
                    child: Flex(direction: Axis.vertical, children: [
                  Expanded(
                      child: Column(
                    children: <Widget>[BudgetList()],
                  ))
                ])))));
  }
}

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
    return FutureBuilder(
        future: variableBloc.getMaxSpend(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
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
                                        suffixIcon: IconButton(
                                            icon: Icon(Icons.undo),
                                            onPressed: () {
                                              _maxSpendController.text =
                                                  "Not Set";
                                            }),
                                        border: InputBorder.none,
                                        labelText:
                                            'Max Spend: ${snapshot.data}',
                                        labelStyle: TextStyle(fontSize: 16),
                                        hintText: "Enter This Week's Max Spend",
                                        hintMaxLines: 2),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (_maxSpendController.text.isEmpty) {
                                        variableBloc.updateMaxSpend("Not Set");
                                      } else {
                                        variableBloc.updateMaxSpend(
                                            _maxSpendController.text);
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

class BudgetList extends StatefulWidget {
  BudgetList({Key key}) : super(key: key);

  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  final CategoryBloc categoryBloc = CategoryBloc();
  final categoryController = TextEditingController();
  final ExpensesBloc expensesBloc = ExpensesBloc();
  final SlidableController slidableController = SlidableController();
  final percentageController = TextEditingController();
  final VariablesBloc variablesBloc = VariablesBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    return Row(
      children: <Widget>[
        SizedBox(
          width: 30,
        ),
        IconButton(
            icon: Icon(Icons.add),
            iconSize: 32.0,
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _showAddCategory(context);
            }),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 28.0),
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 2),
      ],
    );
  }

//add category pop-up on clicking add icon in header
  void _showAddCategory(BuildContext context) {
    showBottomSheet(
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
                                    height: 300,
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
                                                                  .text);
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
                                              controller: categoryController,
                                              autocorrect: true,
                                              showCursor: true,
                                              maxLengthEnforced: true,
                                              maxLength: 20,
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
                      child: Column(children: [
                        SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, int position) {
                                final item = snapshot.data[position];
                                final item1 = snapshot1.data[0];
                                final String budgetedAmount = item
                                                .budgetPercentage ==
                                            "Set A Max Spend" ||
                                        item.budgetPercentage == "Not Set" ||
                                        item1.value == "Not Set"
                                    ? "Not Set"
                                    : (double.parse(item.budgetPercentage) *
                                            0.01 *
                                            double.parse(item1.value))
                                        .toStringAsFixed(2);
                                final String amountLeft =
                                    budgetedAmount != 'Not Set'
                                        ?  
                                            (double.parse(budgetedAmount) -
                                                    item.amount)
                                                .toStringAsFixed(2) 
                                          
                                        : null;
                                if (item.name == "Others") {
                                                                  return Container(
                                    height: 80,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 1),
                                    child: Slidable(
                                        controller: slidableController,
                                        actionPane: SlidableDrawerActionPane(),
                                        actionExtentRatio: 0.20,
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.white)),
                                            child: ListTile(
                                                title: Text(item.name),
                                                subtitle: Text(
                                                  'Spent: ${item.amount.toStringAsFixed(2)}',
                                                ),
                                                trailing: Column(children: [
                                                  Text(
                                                    'Budget: ${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" ? "Not Set" : item.budgetPercentage + '\%'}',
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" || amountLeft == null ? "Not Set" : double.parse(amountLeft) > 0 ? '\$' + amountLeft + ' left' : '\$' + double.parse(amountLeft).abs().toStringAsFixed(2) + ' exceeded'}',
                                                    style: TextStyle(
                                                        color: amountLeft == null ? Colors.green : double.parse(
                                                                    amountLeft) >
                                                                0
                                                            ? Colors.green
                                                            : Colors.red[800]),
                                                  )
                                                ]))),
                                        secondaryActions: <Widget>[
                                          new IconButton(
                                              color: Colors.blue[200],
                                              icon: Icon(Icons.edit, size: 30),
                                              onPressed: () {
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
                                          ]));
 
                                  // return Card(
                                  //     margin: EdgeInsets.symmetric(
                                  //         horizontal: 45, vertical: 1),
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(18.0),
                                  //         side:
                                  //             BorderSide(color: Colors.white)),
                                  //     child: SizedBox(
                                  //         height: 70,
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceBetween,
                                  //           children: <Widget>[
                                  //             Padding(
                                  //                 padding: EdgeInsets.only(
                                  //                     top: 4,
                                  //                     left: 18,
                                  //                     bottom: 10),
                                  //                 child: Column(
                                  //                     crossAxisAlignment:
                                  //                         CrossAxisAlignment
                                  //                             .start,
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .spaceEvenly,
                                  //                     children: <Widget>[
                                  //                       Text(item.name,
                                  //                           style: TextStyle(
                                  //                               fontSize: 18)),
                                  //                       Text(
                                  //                           "Spent: ${item.amount.toStringAsFixed(2)}")
                                  //                     ])),
                                  //             Padding(
                                  //                 padding: EdgeInsets.only(
                                  //                   top: 4,
                                  //                   right: 18,
                                  //                 ),
                                  //                 child: Column(
                                  //                     crossAxisAlignment:
                                  //                         CrossAxisAlignment
                                  //                             .start,
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .spaceEvenly,
                                  //                     children: <Widget>[
                                  //                       Text(
                                  //                           'Budget: ${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" ? "Not Set" : item.budgetPercentage + '\%'}'),
                                  //                       Padding(
                                  //                         padding:
                                  //                             EdgeInsets.only(
                                  //                                 right: 10.0),
                                  //                         child: Container(
                                  //                           height: 0.9,
                                  //                           width: 90.0,
                                  //                           color: Colors.black,
                                  //                         ),
                                  //                       ),
                                  //                       Padding(
                                  //                           padding: EdgeInsets
                                  //                               .symmetric(
                                  //                                   horizontal:
                                  //                                       35),
                                  //                           child: Icon(
                                  //                               Icons.mood_bad,
                                  //                               color: Colors
                                  //                                   .green))
                                  //                     ])),
                                  //           ],
                                  //         )));
                                }
                                return Container(
                                    height: 80,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 1),
                                    child: Slidable(
                                        controller: slidableController,
                                        actionPane: SlidableDrawerActionPane(),
                                        actionExtentRatio: 0.20,
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.white)),
                                            child: ListTile(
                                                title: Text(item.name),
                                                subtitle: Text(
                                                  'Spent: ${item.amount.toStringAsFixed(2)}',
                                                ),
                                                trailing: Column(children: [
                                                  Text(
                                                    'Budget: ${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" ? "Not Set" : item.budgetPercentage + '\%'}',
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '${item.budgetPercentage == "Set A Max Spend" || item.budgetPercentage == "Not Set" || amountLeft == null ? "Not Set" : double.parse(amountLeft) > 0 ? '\$' + amountLeft + ' left' : '\$' + double.parse(amountLeft).abs().toStringAsFixed(2) + ' exceeded'}',
                                                    style: TextStyle(
                                                        color: amountLeft == null ? Colors.green : double.parse(
                                                                    amountLeft) >
                                                                0
                                                            ? Colors.green
                                                            : Colors.red[800]),
                                                  )
                                                ]))),
                                        secondaryActions: <Widget>[
                                          new IconButton(
                                              color: Colors.blue[200],
                                              icon: Icon(Icons.edit, size: 30),
                                              onPressed: () {
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
                                                    .then((list) =>
                                                        list.isNotEmpty
                                                            ? list.forEach(
                                                                (expense) => {
                                                                      expensesBloc.changeExpenseCategory(
                                                                          'Others',
                                                                          expense
                                                                              .id),
                                                                      categoryBloc.addAmountToCategory(
                                                                          expense
                                                                              .amount,
                                                                          'Others')
                                                                    })
                                                            : null);
                                              }),
                                        ]));
                              },
                            ))
                      ]))
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          );
        });
  }

  Widget receiptHeader() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 30,
        ),
        IconButton(
            icon: Icon(Icons.add),
            iconSize: 32.0,
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              showBottomSheet(
                  context: context,
                  builder: (context) =>
                      BottomSheetWidget(expensesBloc, categoryBloc));
            }),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 28.0),
          child: Text(
            "Receipts",
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 2),
      ],
    );
  }

  Widget allReceipts() {
    return StreamBuilder(
      stream: expensesBloc.expenses,
      builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
        return snapshot.hasData
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(children: [
                  SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int position) {
                          final item = snapshot.data[position];

                          return Container(
                              height: 80,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 1),
                              child: Slidable(
                                  controller: slidableController,
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.20,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                      child: SizedBox(
                                          height: 70,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
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
                                                        Text(item.description,
                                                            style: TextStyle(
                                                                fontSize: 18)),
                                                        Text(
                                                            "Spent: ${item.amount.toStringAsFixed(2)}")
                                                      ])),
                                              Padding(
                                                  padding: EdgeInsets.only(
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
                                                        ),
                                                        Text(item.date)
                                                      ])),
                                            ],
                                          ))),
                                  secondaryActions: <Widget>[
                                    new IconButton(
                                        color: Colors.blue[200],
                                        icon: Icon(Icons.edit, size: 30),
                                        onPressed: () {
                                          showBottomSheet(
                                              context: context,
                                              builder: (context) => EditExpense(
                                                  expensesBloc,
                                                  categoryBloc,
                                                  item.description,
                                                  item.id,
                                                  item.amount,
                                                  item.category,
                                                  item.date));
                                          slidableController.activeState
                                              .close();
                                        }),
                                    new IconButton(
                                        color: Colors.redAccent,
                                        icon: Icon(Icons.delete_outline,
                                            size: 30),
                                        onPressed: () {
                                          expensesBloc.deleteExpense(item.id,
                                              item.amount, item.category);
                                          categoryBloc.removeAmountFromCategory(
                                              item.amount, item.category);
                                        }),
                                  ]));
                        },
                      ))
                ]))
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(children: [
      Column(
        children: <Widget>[
          MaxSpend(categoryBloc, variablesBloc),
          categoryHeader(),
          getCategoriesWidget(),
          SizedBox(height: 20),
          receiptHeader(),
          allReceipts()
        ],
      )
    ]));
  }
}
