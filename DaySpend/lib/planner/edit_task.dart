import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/picker.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:DaySpend/planner/widget_values.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fswitch/fswitch.dart';
import 'package:intl/intl.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';

import 'day2index.dart';

class EditButton extends StatefulWidget {
  final TextEditingController nameEditor;
  final TextEditingController desEditor;
  final SlidableController slidableController;
  final int taskID;
  final String taskName;
  final String taskIndex;
  final String taskTime;
  final DateTime taskDT;
  final String taskDes;
  final bool taskNotify;
  final bool taskComplete;
  final bool taskOverdue;
  final Task oldTask;
  final GlobalKey<FabCircularMenuState> menu;

  EditButton({this.slidableController, this.taskName, this.taskIndex, this.taskTime, this.taskDT, this.taskDes, this.taskNotify, this.taskComplete, this.taskOverdue, this.nameEditor, this.desEditor, this.oldTask, this.taskID, this.menu});

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  final TasksBloc tasksBloc = TasksBloc();

  @override
  void dispose() {
    tasksBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    widget.nameEditor.text = widget.taskName;
    widget.desEditor.text = widget.taskDes;
    return IconSlideAction(
      caption: 'Edit',
      color: Colors.blueGrey[100],
      icon: Icons.edit,
      onTap: () {
        widget.menu.currentState.close();
        Provider.of<PlannerWidgetValues>(context).resetAddTask();
        Provider.of<PlannerWidgetValues>(context).changeNotify(widget.taskNotify);
        widget.slidableController.activeState?.close();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) =>
              SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: Color(0xff757575),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 12),
                                  width: MediaQuery.of(context).copyWith().size.width/2.5,
                                  child: Row(
                                    children: <Widget>[
                                      Header(
                                        weight: FontWeight.bold,
                                        text: "Notification : ",
                                        color: Colors.black,
                                        size: MediaQuery.of(context).copyWith().size.width/30,
                                      ),
                                      FSwitch(
                                        open: Provider.of<PlannerWidgetValues>(context).storedNotify(),
                                        width: 48,
                                        height: 28,
                                        openColor: Colors.teal,
                                        onChanged: (v) {
                                          Provider.of<PlannerWidgetValues>(context).changeNotify(!Provider.of<PlannerWidgetValues>(context).storedNotify());
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
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).copyWith().size.width/2.5,
                                  margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  child: PickerButton(
                                    initDateTime: (!widget.taskOverdue ? widget.taskDT : DateTime.now().add(Duration(minutes: 1))),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: TextField(
                                  controller: widget.nameEditor,
                                  maxLength: 20,
                                  cursorColor: Colors.teal,
                                  textAlign: TextAlign.start,
                                  onChanged: (String newName) {
                                    Provider.of<PlannerWidgetValues>(context).changeName(newName);
                                  },
                                  showCursor: true,
                                  maxLengthEnforced: true,
                                  decoration:
                                  InputDecoration.collapsed(
                                    hintText: (widget.nameEditor.text == "" ? "A task must have a name" : ''),
                                  )
                              ),
                            ),
                            Container(
                              height: 100,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: TextField(
                                  controller: widget.desEditor,
                                  maxLines: null,
                                  textAlign: TextAlign.start,
                                  cursorColor: Colors.teal,
                                  onChanged: (String newDes) {
                                    Provider.of<PlannerWidgetValues>(context).changeDes(newDes);
                                  },
                                  showCursor: true,
                                  maxLengthEnforced: true,
                                  decoration:
                                  InputDecoration.collapsed(
                                    hintText: '',
                                  )
                              ),
                            ),
                            NiceButton(
                              width: 160,
                              elevation: 8.0,
                              radius: 52.0,
                              fontSize: 14,
                              text: "Save Changes",
                              textColor: Colors.white,
                              background: (widget.nameEditor.text != null && widget.nameEditor.text.replaceAll(' ', '').length!=0 ? Colors.teal : Colors.blueGrey[100]),
                              onPressed: () {
                                String name = Provider.of<PlannerWidgetValues>(context).storedName();
                                if (name == null) {
                                  name = widget.taskName;
                                }
                                DateTime setTime = Provider.of<PlannerWidgetValues>(context).storedDateTime();
                                if (setTime == null ) {
                                  setTime = DateTime.now().add(Duration(minutes: 1));
                                }
                                if (setTime.isBefore(DateTime.now())){
                                  setTime = DateTime.now().add(Duration(minutes: 1));
                                }
                                String index = getIndex(setTime);
                                String time = DateFormat('Hm').format(setTime).toString();
                                String description = Provider.of<PlannerWidgetValues>(context).storedDes();
                                if (description == null) {
                                  description = widget.taskDes;
                                }
                                bool notify = Provider.of<PlannerWidgetValues>(context).storedNotify();
                                if (name != null && name.replaceAll(' ', '').length!=0) {
                                  tasksBloc.removeTaskFromDatabase(widget.oldTask.id);
                                  Task tempTask = Task(index: index, name: name, time: time, description: (description != null ? description : ""), notify: notify, isComplete: false, isOverdue: false, opacity: 1, dt: setTime);
                                  tasksBloc.addTaskToDatabase(tempTask);
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ),
        );
      },
    );
  }
}

