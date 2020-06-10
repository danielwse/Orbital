//dart file for categories and budget list portion of the expenses page
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/database/DatabaseBloc.dart';
import 'package:DaySpend/expenses/db_models.dart';

class BudgetList extends StatefulWidget {
  BudgetList({Key key}) : super(key: key);

  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  final DismissDirection _dismissDirection = DismissDirection.endToStart;
  final CategoryBloc categoryBloc = CategoryBloc();
  final categoryController = TextEditingController();

  @override
  dispose() {
    categoryBloc.dispose();
    categoryController.dispose();
    super.dispose();
  }

  //row of add, category text at the top
  Widget header() {
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
                              onDismissed: (direction) {
                                categoryBloc.deleteCategory(item.id);
                              },
                              direction: _dismissDirection,
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(children: [
      Column(
        children: <Widget>[header(), getCategoriesWidget()],
      )
    ]));
  }
}
