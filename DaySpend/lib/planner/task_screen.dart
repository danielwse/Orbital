import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/widget_values.dart';
import 'package:DaySpend/planner/task_list.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/planner/add_task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  final SlidableController slidable;
  final TextEditingController nameTextControl;
  final TextEditingController desTextControl;
  final GlobalKey<FabCircularMenuState> fabKey;
  final Function notificationCallback;
  final Function disableNotificationCallback;

  TaskScreen({this.slidable, this.desTextControl, this.nameTextControl, this.fabKey, this.notificationCallback, this.disableNotificationCallback});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  void toggleMenu({bool forceClose}) {
    if (widget.fabKey.currentState.isOpen) {
      widget.fabKey.currentState.close();
    } else {
      if (forceClose) {
        widget.fabKey.currentState.close();
      } else {
        widget.fabKey.currentState.open();
      }
    }
  }

  final TasksBloc tasksBloc = TasksBloc();

  @override
  void dispose() {
    tasksBloc.dispose();
    super.dispose();
  }

  int mode = 1;

  @override
  Widget build(BuildContext context) {
    tasksBloc.removeExpiredOnMondays();
    String headerText = DateFormat('MEd').format(DateTime.now()).toString() + " - " + DateFormat('MEd').format(DateTime.now().add(Duration(days: 6))).toString();
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: AppBar(
        brightness: Brightness.light,
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: (mode == 1 ? EdgeInsets.only(left: 0) : EdgeInsets.only(left: 8)),
              child: (mode == 1 ? Header(
                text: headerText, shadow: Shadow(blurRadius: 2.5, color: Colors.black26, offset: Offset(0,1)),
                weight: FontWeight.w600, color: Colors.black54, size: 20,
              ) :
              (mode == 2 ? Header(
                text: headerText,
                shadow: Shadow(blurRadius: 2.5, color: Colors.greenAccent, offset: Offset(0,1)),
                weight: FontWeight.w600, color: Colors.green, size: 20,
              ) :
              Header(
                text: headerText,
                shadow: Shadow(blurRadius: 2.5, color: Colors.redAccent, offset: Offset(0,1)),
                weight: FontWeight.w600, color: Colors.red, size: 20,
              ))
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          mode == 1 ? Container(
            margin: EdgeInsets.only(right: 25),
            child: RawMaterialButton(
              constraints: BoxConstraints.tight(Size(40, 40)),
              fillColor: Colors.white,
              shape: CircleBorder(),
              elevation: 7,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                Provider.of<PlannerWidgetValues>(context).resetAddTask();
                toggleMenu(forceClose: true);
                widget.slidable.activeState?.close();
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                        child:Container(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: AddTask(tasksBloc: tasksBloc, enableNotification: widget.notificationCallback),
                        )
                    )
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 20,
              ),
            ),
          ) : Container(),
        ],
      ),
      body: GestureDetector(
        onPanDown: (v) {
          widget.slidable.activeState?.close();
          toggleMenu(forceClose: true);
        },
        child: TaskList(
          mode: mode, // 1 = activeTasks, 2 = getArchived, 3 = getExpired
          notificationFn: widget.notificationCallback,
          disableNotificationFn: widget.disableNotificationCallback,
          tasksBloc: tasksBloc,
          slidable: widget.slidable,
          nameEdit: widget.nameTextControl,
          descriptionEdit: widget.desTextControl,
          fabKey: widget.fabKey,
        ),
      ),
      floatingActionButton: FabCircularMenu(
        key: widget.fabKey,
        animationDuration: const Duration(milliseconds: 400),
        fabOpenIcon: ( mode == 1 ? Icon(Icons.home) : ( mode == 2 ? Icon(Icons.archive) : Icon(Icons.reply_all))),
        fabColor: Colors.white,
        ringColor: Colors.lightBlue[100],
        ringDiameter: MediaQuery.of(context).copyWith().size.width * 0.8,
        ringWidth: MediaQuery.of(context).copyWith().size.width * 1.25 * 0.1,
          children: <Widget>[
            IconButton(icon:
                Stack(
                    children: <Widget>[
                      Icon(Icons.home),
                      Visibility(
                        visible: mode == 1,
                        child: Positioned(  // draw a red marble
                          top: 0.0,
                          right: 0.0,
                          child: Icon(Icons.brightness_1, size: 8.0,
                            color: Colors.redAccent),
                        ),
                      )
                    ]
                ),
                onPressed: () {
                  toggleMenu();
                  setState(() {
                    mode = 1;
                  });
                }),
            IconButton(icon: Stack(
                children: <Widget>[
                  Icon(Icons.archive),
                  Visibility(
                    visible: mode == 2,
                    child: Positioned(  // draw a red marble
                      top: 0.0,
                      right: 0.0,
                      child: Icon(Icons.brightness_1, size: 8.0,
                          color: Colors.redAccent),
                    ),
                  )
                ]
            ), onPressed: () {
              toggleMenu();
              setState(() {
                mode = 2;
              });
            }),
            IconButton(icon: Stack(
                children: <Widget>[
                  Icon(Icons.reply_all),
                  Visibility(
                    visible: mode == 3,
                    child: Positioned(  // draw a red marble
                      top: 0.0,
                      right: 0.0,
                      child: Icon(Icons.brightness_1, size: 8.0,
                          color: Colors.redAccent),
                    ),
                  )
                ]
            ), onPressed: () {
              toggleMenu();
              setState(() {
                mode = 3;
              });
            })
          ]
      ),
    );
  }
}