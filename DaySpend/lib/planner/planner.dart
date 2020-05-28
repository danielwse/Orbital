import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:DaySpend/fonts/header.dart';

List _elements = [
  {'name': 'Study', 'group': 'Monday'},
  {'name': 'Run', 'group': 'Monday'},
  {'name': 'Eat', 'group': 'Tuesday'},
  {'name': 'Gym', 'group': 'Tuesday'},
  {'name': 'Eat', 'group': 'Tuesday'},
  {'name': 'Study', 'group': 'Wednesday'},
  {'name': 'Gym', 'group': 'Saturday'},
  {'name': 'Run', 'group': 'Saturday'},
  {'name': 'Run', 'group': 'Sunday'},
  {'name': 'Study', 'group': 'Sunday'},
]; //should import from database

class Planner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffF7F7F7),
        appBar: AppBar(
          title: Header(
            text: 'DaySpend',
            italic: true,
            size: 20,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.today,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete_forever,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: GroupedListView<dynamic, String>(
          order: GroupedListOrder.ASC,
          groupBy: (element) => element['group'],
          elements: _elements,
          useStickyGroupSeparators: false,
          groupSeparatorBuilder: (String value) => Padding(
            // EdgeInsets.fromLTRB(15, 40, 10, 10)
            padding: (value == 'Monday'
                ? EdgeInsets.fromLTRB(15, 10, 10, 10)
                : EdgeInsets.fromLTRB(15, 40, 10, 10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          itemBuilder: (c, element) {
            return Card(
              elevation: 2.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text(
                    element['name'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
