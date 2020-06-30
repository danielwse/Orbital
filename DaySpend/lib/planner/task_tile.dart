import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fswitch/fswitch.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: GestureDetector(
        onTap: () => {
          getDetails(context,task),
        },
        onLongPress: () => {
          getDescriptionOnly(context, task),
          print("peek"),
        },
        onLongPressUp: () => {
          Navigator.pop(context),
          print("press up"),
        },
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
    );;
  }
}


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

Future<void> getDescriptionOnly(BuildContext context, task) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10)),
        content: Text(
          task.description,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5),
        ),
      );
    },
  );
}

Future<void> getDetails(BuildContext context, task) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          elevation: 10,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        task.name,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: ((task.status != 'overdue' && task.status != 'completed') ? true : false),
                        child: FSwitch(
                          open: (task.status == 'notify' ? true : false),
                          width: 40,
                          height: 24,
                          openColor: Colors.teal,
                          onChanged: (v) {
                            //change status from notify to ''
                          },
                          closeChild: Icon(
                            Icons.notifications_off,
                            size: 12,
                            color: Colors.brown,
                          ),
                          openChild: Icon(
                            Icons.notifications,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          task.time,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 0),
                child: Text(
                  task.description,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5),
                ),
              ),
              typeOfButton(task.status),
            ],
          )
      );
    },
  );
}

RaisedButton typeOfButton(String status) {
  switch (status) {
    case 'completed':
      return RaisedButton(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10)),
        child: Header(text:'Remove', size: 14, italic: false, weight: FontWeight.w500),
        color: Colors.greenAccent,
        onPressed: () => {},
      );
      break;
    case 'overdue':
      return RaisedButton(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10)),
        child: Header(text:'Reschedule', size: 14, italic: false, color: Colors.white, weight: FontWeight.w500),
        color: Colors.redAccent,
        onPressed: () => {},
      );
      break;
    default:
      return RaisedButton(
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10)),
        child: Header(text:'Complete', size: 14, italic: false, weight: FontWeight.w500),
        color: Colors.tealAccent,
        onPressed: () => {},
      );
  }
}
