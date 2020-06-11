//entitre page when swipe right on homepage

import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'package:DaySpend/expenses/database/variables_db.dart';
import 'package:DaySpend/expenses/db_models.dart';

class Expenses extends StatelessWidget {
  const Expenses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
                child: Flex(direction: Axis.vertical, children: [
          Expanded(
              child: Column(
            children: <Widget>[MaxSpend(), SizedBox(height: 10), BudgetList()],
          ))
        ]))));
  }
}

//max spend part at top of page
class MaxSpend extends StatefulWidget {
  MaxSpend({Key key}) : super(key: key);

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
        builder: (context, snapshot) {
          return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                              padding:
                                  EdgeInsets.only(left: 100, right: 80, top: 5),
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _maxSpendController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText:
                                        'Max Spend: ${VariablesDao.maxSpend}',
                                    labelStyle: TextStyle(fontSize: 18),
                                    hintText: "Enter This Week's Max Spend",
                                    hintMaxLines: 1),
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  variableBloc
                                      .updateMaxSpend(_maxSpendController.text);

                                  setState(() {});
                                },
                              )))),
                ],
              ));
        });
  }
}

class BudgetList extends StatefulWidget {
  BudgetList({Key key}) : super(key: key);

  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  final DismissDirection _dismissDirectionCategory =
      DismissDirection.endToStart;
  final CategoryBloc categoryBloc = CategoryBloc();
  final categoryController = TextEditingController();
  final DismissDirection _dismissDirectionReceipt = DismissDirection.endToStart;
  final ExpensesBloc expensesBloc = ExpensesBloc();

  @override
  dispose() {
    categoryBloc.dispose();
    categoryController.dispose();
    expensesBloc.dispose();
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey[300],
                                    spreadRadius: 5)
                              ]),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Spacer(),
                                Column(children: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Categories category = Categories(
                                            name: categoryController.text,
                                            amount: 0,
                                            budget: 0);
                                        if (categoryController
                                            .text.isNotEmpty) {
                                          categoryBloc.addCategory(category);
                                        }
                                        Navigator.of(context).pop();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        categoryController.clear();
                                      },
                                      child: Icon(Icons.check, size: 40)),
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                    controller: categoryController,
                                    autocorrect: true,
                                    showCursor: true,
                                    maxLengthEnforced: true,
                                    maxLength: 20,
                                    textAlign: TextAlign.start,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Category Name',
                                    )))
                          ]),
                        )
                      ])));
        });
  }

  Widget getCategoriesWidget() {
    return StreamBuilder(
      stream: categoryBloc.categories,
      builder:
          (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
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
                          if (item.name == "Others") {
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 45, vertical: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)),
                              child: ListTile(
                                  title: Text(item.name),
                                  subtitle: Text(
                                    'Spent: ${item.amount}',
                                  ),
                                  trailing: Text('Budgeted: ${item.budget}')),
                            );
                          }
                          return Dismissible(
                              background: Container(
                                  height: 80,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 1),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: Colors.redAccent),
                                  child: Container(
                                      child: Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ))),
                              key: new ObjectKey(item),
                              onDismissed: (direction) async {
                                categoryBloc.deleteCategory(item.id);
                                expensesBloc
                                    .getExpensesByCategory(item.name)
                                    .then((list) => !list.isEmpty
                                        ? list.forEach((expense) =>
                                            { expensesBloc.changeExpenseCategory(
                                                'Others', expense.id),
                                               categoryBloc.addAmountToCategory(expense.amount, 1 )})
                                        : null);
                              },
                              direction: _dismissDirectionCategory,
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)),
                                child: ListTile(
                                    title: Text(item.name),
                                    subtitle: Text(
                                      'Spent: ${item.amount}',
                                    ),
                                    trailing: Text('Budgeted: ${item.budget}')),
                              ));
                        },
                      ))
                ]))
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget receiptHeader() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 30,
        ),
        // IconButton(
        //     icon: Icon(Icons.add),
        //     iconSize: 32.0,
        //     onPressed: () {
        //       _showAddCategory(context);
        //     }),
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

                          return Dismissible(
                              background: Container(
                                  height: 80,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 1),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: Colors.redAccent),
                                  child: Container(
                                      child: Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ))),
                              key: new ObjectKey(item),
                              onDismissed: (direction) {
                                expensesBloc.deleteExpense(
                                    item.id, item.amount, item.category);
                                categoryBloc.removeAmountFromCategory(
                                    item.amount, item.category);
                              },
                              direction: _dismissDirectionReceipt,
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)),
                                child: ListTile(
                                    title: Text(item.description),
                                    subtitle: Text(
                                      'Spent: ${item.amount}',
                                    ),
                                    trailing:
                                        Text('Category: ${item.category}')),
                              ));
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
