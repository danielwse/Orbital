import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

IconSlideAction switchStatus(status) {
  switch (status) {
    case 'completed':
      return IconSlideAction(
          caption: 'Remove', color: Colors.greenAccent, icon: Icons.archive);
      break;
    case 'overdue':
      return IconSlideAction(
          caption: 'Reschedule', color: Colors.redAccent, icon: Icons.refresh);
      break;
    default:
      return IconSlideAction(
          caption: 'Complete', color: Colors.tealAccent, icon: Icons.check);
  }
}

String switchDays(i) {
  switch (i) {
    case '1':
      return 'Monday';
      break;
    case '2':
      return 'Tuesday';
      break;
    case '3':
      return 'Wednesday';
      break;
    case '4':
      return 'Thursday';
      break;
    case '5':
      return 'Friday';
      break;
    case '6':
      return 'Saturday';
      break;
    case '7':
      return 'Sunday';
      break;
    default:
      return '';
  }
}

Icon statusInput(input) {
  switch (input) {
    case 'notify':
      return Icon(Icons.notifications, color: Colors.orangeAccent, size: 22);
      break;
    case 'completed':
      return Icon(Icons.check_circle, color: Colors.lightBlueAccent, size: 20);
      break;
    case 'overdue':
      return Icon(Icons.cancel, color: Colors.redAccent, size: 20);
      break;
    default:
      return Icon(Icons.cancel, size: 0);
  }
}

class Task implements Comparable {
  final String name;
  final String index;
  final String time;
  final String status;

  Task(this.index, this.name, this.time, this.status);

  @override
  int compareTo(other) {
    return time.compareTo(other.time);
  }
}

List<Task> _tasks = [
  Task('1', 'Run', '17:30', 'overdue'),
  Task('1', 'Eat', '20:00', 'overdue'),
  Task('1', 'Study', '16:00', 'completed'),
  Task('2', 'Study', '16:00', ''),
  Task('2', 'Eat', '17:00', 'notify'),
  Task('3', 'Study', '16:00', ''),
  Task('4', 'Study', '16:00', 'completed'),
  Task('4', 'Run', '20:00', ''),
  Task('5', 'Study', '16:00', ''),
  Task('5', 'Study', '20:00', 'notify'),
  Task('5', 'Play', '22:00', ''),
  Task('6', 'Study', '16:00', 'notify'),
  Task('7', 'Study', '16:00', ''),
  Task('2', 'Study', '11:00', '')
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
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Padding(
                padding: const EdgeInsets.only(right: 100),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Padding(
                padding: const EdgeInsets.only(right: 100),
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: GroupedListView<dynamic, String>(
          order: GroupedListOrder.ASC,
          groupBy: (task) => task.index,
          elements: _tasks,
          groupSeparatorBuilder: (index) => Padding(
            padding: (index == '1'
                ? EdgeInsets.fromLTRB(15, 10, 10, 10)
                : EdgeInsets.fromLTRB(15, 40, 10, 10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(
                  text: switchDays(index),
                  size: 20,
                  italic: false,
                ),
              ],
            ),
          ),
          itemBuilder: (c, task) {
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    title: Text(
                      task.name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        statusInput(task.status),
                        Container(
                          margin: EdgeInsets.fromLTRB(12, 0, 6, 0),
                          child: Text(
                            task.time,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2),
                          ),
                        ),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Container(height: 55, child: switchStatus(task.status)),
              ],
              secondaryActions: <Widget>[
                Container(
                  height: 55,
                  child: IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blueGrey,
                    icon: Icons.edit,
                    onTap: () => Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Edit'),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  child: IconSlideAction(
                    closeOnTap: true,
                    caption: 'Delete',
                    color: Colors.pinkAccent,
                    icon: Icons.delete,
                    onTap: () => Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Delete'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
