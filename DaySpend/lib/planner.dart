import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'DaySpend',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Colors.black),
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
          groupBy: (element) => element['group'],
          elements: _elements,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  title: Text(element['name']),
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
