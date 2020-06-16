//entitre page when swipe right on homepage

// import 'package:DaySpend/expenses/database/ExpensesBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'package:DaySpend/expenses/database/variables_db.dart';
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
  final CategoryBloc categoryBloc = CategoryBloc();
  final categoryController = TextEditingController();
  final ExpensesBloc expensesBloc = ExpensesBloc();
  final SlidableController slidableController = SlidableController();
  final percentageController = TextEditingController();
  final VariablesBloc variablesBloc = VariablesBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate;

  @override
  void initState() {
    _autoValidate = false;
    super.initState();
  }

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
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Container(
                  height: 300,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  categoryController.clear();
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.clear, size: 40)),
                            Text('Cancel')
                          ],
                        ),
                        Spacer(),
                        Column(children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Categories category = Categories(
                                    name: categoryController.text,
                                    amount: 0,
                                    budget: 0);
                                if (percentageController.text == 'Not Set' ||
                                    percentageController.text.isEmpty &&
                                        categoryController.text.isNotEmpty) {
                                  categoryBloc.addCategory(category);

                                  Navigator.of(context).pop();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  categoryController.clear();
                                } else if (categoryController.text.isNotEmpty &&
                                    _formKey.currentState.validate()) {
                                  categoryBloc.addCategory(category);

                                  Navigator.of(context).pop();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  categoryController.clear();
                                } else if (!_formKey.currentState.validate()) {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
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
                            ))),
                   
                    Form(
                        key: _formKey,
                        autovalidate: true,
                        child: MoneyTextFormField(
                            maxSpend: double.parse(VariablesDao.maxSpend),
                            settings: MoneyTextFormFieldSettings(
                              
                                validator: Validators.compose([
                                  Validators.required(
                                      "Indicate % or reset to default"),
                                  Validators.max(100, "% must be less than 100")
                                ]),
                                controller: percentageController,
                                appearanceSettings: AppearanceSettings(
                                   
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    labelText: "Budget: % of Max Spend",
                                    labelStyle: TextStyle(fontSize: 25),
                                    formattedStyle: TextStyle(fontSize: 20)))))
                  ]),
                )
              ]));
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
                                    'Spent: ${item.amount.toStringAsFixed(2)}',
                                  ),
                                  trailing: Text('Budgeted: ${item.budget}')),
                            );
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
                                    // margin: EdgeInsets.symmetric(
                                    //     horizontal: 45, vertical: 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.white)),
                                    child: ListTile(
                                        title: Text(item.name),
                                        subtitle: Text(
                                          'Spent: ${item.amount.toStringAsFixed(2)}',
                                        ),
                                        trailing:
                                            Text('Budgeted: ${item.budget}')),
                                  ),
                                  secondaryActions: <Widget>[
                                    new IconButton(
                                        color: Colors.blue[200],
                                        icon: Icon(Icons.edit, size: 30),
                                        onPressed: () {
                                          showBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  EditCategory(expensesBloc,
                                                      categoryBloc, item.name));
                                          slidableController.activeState
                                              ?.close();
                                        }),
                                    new IconButton(
                                        color: Colors.redAccent,
                                        icon: Icon(Icons.delete_outline,
                                            size: 30),
                                        onPressed: () {
                                          categoryBloc.deleteCategory(item.id);
                                          expensesBloc
                                              .getExpensesByCategory(item.name)
                                              .then((list) => list.isNotEmpty
                                                  ? list.forEach((expense) => {
                                                        expensesBloc
                                                            .changeExpenseCategory(
                                                                'Others',
                                                                expense.id),
                                                        categoryBloc
                                                            .addAmountToCategory(
                                                                expense.amount,
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
  }

  // void _showAddExpense(BuildContext context) {
  //   showBottomSheet(
  //       context: context,
  //       builder: (builder) {
  //         return Container(
  //             margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
  //             height: 350,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                   mainAxisSize: MainAxisSize.max,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       height: 450,
  //                       decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.all(Radius.circular(15)),
  //                           boxShadow: [
  //                             BoxShadow(
  //                                 blurRadius: 10,
  //                                 color: Colors.grey[300],
  //                                 spreadRadius: 5)
  //                           ]),
  //                       child: Column(children: [DecoratedTextField(expensesBloc, categoryBloc)]),
  //                     )
  //                   ]),
  //             ));
  //       });
  // }

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
                                        side: BorderSide(color: Colors.white)),
                                    child: ListTile(
                                        title: Text(item.description),
                                        subtitle: Text(
                                          'Spent: ${item.amount.toStringAsFixed(2)}',
                                        ),
                                        trailing:
                                            Text('Category: ${item.category}')),
                                  ),
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
                                                  item.category));
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
