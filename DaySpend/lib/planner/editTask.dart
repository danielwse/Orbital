import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/picker.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:DaySpend/planner/task_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fswitch/fswitch.dart';
import 'package:intl/intl.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';

import 'day2index.dart';

class EditButton extends StatelessWidget {
  final TextEditingController nameEditor;
  final TextEditingController desEditor;
  final SlidableController slidableController;
  final String taskName;
  final String taskIndex;
  final String taskTime;
  final DateTime taskDT;
  final String taskDes;
  final bool taskNotify;
  final bool taskComplete;
  final bool taskOverdue;
  final Task oldTask;

  EditButton({this.slidableController, this.taskName, this.taskIndex, this.taskTime, this.taskDT, this.taskDes, this.taskNotify, this.taskComplete, this.taskOverdue, this.nameEditor, this.desEditor, this.oldTask});

  @override
  Widget build(BuildContext context) {
    nameEditor.text = taskName;
    desEditor.text = taskDes;
    return IconSlideAction(
      caption: 'Edit',
      color: Colors.blueGrey[100],
      icon: Icons.edit,
      onTap: () {
        Provider.of<TaskFunction>(context).resetAddTask();
        Provider.of<TaskFunction>(context).changeNotify(taskNotify);
        slidableController.activeState?.close();
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
                                        open: Provider.of<TaskFunction>(context).storedNotify(),
                                        width: 48,
                                        height: 28,
                                        openColor: Colors.teal,
                                        onChanged: (v) {
                                          Provider.of<TaskFunction>(context).changeNotify(!Provider.of<TaskFunction>(context).storedNotify());
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
                                    initDateTime: (!taskOverdue ? taskDT : DateTime.now().add(Duration(minutes: 1))),
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
                                  controller: nameEditor,
                                  maxLength: 20,
                                  cursorColor: Colors.teal,
                                  textAlign: TextAlign.start,
                                  onChanged: (String newName) {
                                    Provider.of<TaskFunction>(context).changeName(newName);
                                  },
                                  showCursor: true,
                                  maxLengthEnforced: true,
                                  decoration:
                                  InputDecoration.collapsed(
                                    hintText: (nameEditor.text == "" ? "A task must have a name" : ''),
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
                                  controller: desEditor,
                                  maxLines: null,
                                  textAlign: TextAlign.start,
                                  cursorColor: Colors.teal,
                                  onChanged: (String newDes) {
                                    Provider.of<TaskFunction>(context).changeDes(newDes);
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
                              background: (nameEditor.text != null && nameEditor.text.replaceAll(' ', '').length!=0 ? Colors.teal : Colors.blueGrey[100]),
                              onPressed: () {
                                String name = Provider.of<TaskFunction>(context).storedName();
                                if (name == null) {
                                  name = taskName;
                                }
                                DateTime setTime = Provider.of<TaskFunction>(context).storedDateTime();
                                print("from edit task " + setTime.toString());
                                if (setTime == null ) {
                                  setTime = DateTime.now().add(Duration(minutes: 1));
                                }
                                if (setTime.isBefore(DateTime.now())){
                                  setTime = DateTime.now().add(Duration(minutes: 1));
                                }
                                String index = getIndex(setTime);
                                String time = DateFormat('Hm').format(setTime).toString();
                                String description = Provider.of<TaskFunction>(context).storedDes();
                                if (description == null) {
                                  description = taskDes;
                                }
                                bool notify = Provider.of<TaskFunction>(context).storedNotify();
                                if (name != null && name.replaceAll(' ', '').length!=0) {
                                  Provider.of<TaskFunction>(context).addTask(index,name,time,(description != null ? description : ""), notify, setTime);
                                  Provider.of<TaskFunction>(context).deleteTask(oldTask);
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

