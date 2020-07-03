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
  final Function notifyCallback;
  final Function completeCallback;
  final Function overdueCallback;
  final Function removeCallback;
  final SlidableController slidable;

  TaskTile({this.taskIndex,this.taskName,this.taskTime,this.taskDes,this.taskNotify, this.taskComplete, this.taskOverdue, this.notifyCallback, this.completeCallback, this.overdueCallback, this.removeCallback, this.slidable});

  @override
  Widget build(BuildContext context) {
    double heightOfActions = 52;
    return Slidable(
      key: Key(taskName + taskTime),
      controller: slidable,
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10)),
        elevation: 7.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            onTap: () => {
              slidableStateClose(),
              getDetails(context),
            },
            onLongPress: (taskOverdue ? null : completeCallback),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            title: Text(
              taskName,
              style: TextStyle(
                  decoration: taskComplete ? TextDecoration.lineThrough : null,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (taskComplete ? Icon(Icons.check_circle, color: Colors.lightBlueAccent, size: 22) : (taskOverdue ? Icon(Icons.cancel, color: Colors.redAccent, size: 20) : (taskNotify ? Icon(Icons.notifications, color: Colors.orangeAccent, size: 20) : Icon(Icons.notifications, color: Colors.orangeAccent, size: 0)))),
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
      actions: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 12),
            height: heightOfActions,
            child: (taskComplete ?
            IconSlideAction(caption: 'Archive', color: Colors.lightBlueAccent, icon: Icons.archive) :
            (taskOverdue ?
            IconSlideAction(caption: 'Reschedule', color: Colors.redAccent, icon: Icons.replay) :
            IconSlideAction(caption: 'Archive', color: Colors.black26, icon: Icons.archive))),
        ),],
      secondaryActions: <Widget>[
        Container(
          height: heightOfActions,
          margin: EdgeInsets.only(right:12),
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
          margin: EdgeInsets.only(right: 12),
          height: heightOfActions,
          child: IconSlideAction(
            closeOnTap: true,
            caption: 'Delete',
            color: Colors.pinkAccent,
            icon: Icons.delete,
            onTap: removeCallback,
          ),
        ),
      ],
    );
  }

  Future<void> getDetails(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10)),
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
                          taskName.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Visibility(
                          visible: (!taskComplete && !taskOverdue),
                          child: FSwitch(
                            open: (taskNotify),
                            width: 40,
                            height: 24,
                            openColor: Colors.teal,
                            onChanged: notifyCallback,
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
                            taskTime,
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
                  padding: EdgeInsets.fromLTRB(0, 38, 0, 12),
                  child: Text(
                    taskDes,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5),
                  ),
                ),
              ],
            )
        );
      },
    );
  }
  void slidableStateClose() {
    this.slidable.activeState?.close();
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
