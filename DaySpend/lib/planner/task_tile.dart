import 'package:DaySpend/fonts/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fswitch/fswitch.dart';

class TaskTile extends StatelessWidget {
  final String taskName;
  final String taskIndex;
  final String taskTime;
  final String taskDes;
  final bool taskNotify;
  final bool taskComplete;
  final bool taskOverdue;

  TaskTile({this.taskIndex,this.taskName,this.taskTime,this.taskDes,this.taskNotify, this.taskComplete, this.taskOverdue});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: GestureDetector(
        onTap: () => {
          getDetails(context,taskName, taskTime, taskDes, taskNotify, taskComplete, taskOverdue),
        },
        onLongPress: () => {
          getDescriptionOnly(context, taskDes),
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
                taskName,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  (taskNotify ? Icon(Icons.notifications, color: Colors.orangeAccent, size: 22) : (taskOverdue ? Icon(Icons.check_circle, color: Colors.lightBlueAccent, size: 20) : (taskComplete ? Icon(Icons.cancel, color: Colors.redAccent, size: 20) : Icon(Icons.cancel, color: Colors.redAccent, size: 0)))),
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 0, 6, 0),
                    child: Text(
                      taskTime,
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
        Container(height: 55, child:
        (taskComplete ? IconSlideAction(
            caption: 'Remove', color: Colors.greenAccent, icon: Icons.archive) : (taskOverdue ? IconSlideAction(
            caption: 'Reschedule', color: Colors.redAccent, icon: Icons.refresh) : IconSlideAction(
            caption: 'Complete', color: Colors.tealAccent, icon: Icons.check)))),
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

Future<void> getDescriptionOnly(BuildContext context, des) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10)),
        content: Text(
          des,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5),
        ),
      );
    },
  );
}

Future<void> getDetails(BuildContext context, name, time, des, notify, complete, overdue) {
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
                        name,
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
                        visible: (complete && overdue),
                        child: FSwitch(
                          open: (notify),
                          width: 40,
                          height: 24,
                          openColor: Colors.teal,
                          onChanged: (v) {
                            notify = !notify;
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
                          time,
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
                  des,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5),
                ),
              ),
              (complete ? RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10)),
                child: Header(text:'Remove', size: 14, italic: false, weight: FontWeight.w500),
                color: Colors.greenAccent,
                onPressed: () => {},
              ) : (overdue ? RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10)),
                child: Header(text:'Reschedule', size: 14, italic: false, color: Colors.white, weight: FontWeight.w500),
                color: Colors.redAccent,
                onPressed: () => {},
              ) : RaisedButton(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10)),
                child: Header(text:'Complete', size: 14, italic: false, weight: FontWeight.w500),
                color: Colors.tealAccent,
                onPressed: () => {},
              ))),
            ],
          )
      );
    },
  );
}
