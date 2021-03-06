import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/datePicker.dart';
import 'package:DaySpend/planner/durationPicker.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:DaySpend/planner/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fswitch/fswitch.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  final TasksBloc tasksBloc;
  final Function enableNotification;

  AddTask({this.tasksBloc, this.enableNotification});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.tasksBloc.tasks,
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        return Consumer<PlannerWidgetFunctions>(
          builder: (context, newTask, child) {
            return Container(
              color: Color(0xff757575),
              child: Container(
                padding: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Header(
                            weight: FontWeight.bold,
                            text: "Toggle reminder: ",
                            color: Colors.black,
                            size: MediaQuery.of(context).copyWith().size.width/40,
                          ),
                          FSwitch(
                            open: newTask.storedNotify(),
                            width: 48,
                            height: 28,
                            openColor: Colors.teal,
                            onChanged: (v) {
                              newTask.changeNotify(!newTask.storedNotify());
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
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Header(
                              weight: FontWeight.bold,
                              text: "Set time & duration:",
                              color: Colors.black,
                              size: MediaQuery.of(context).copyWith().size.width/40,
                            ),
                            DatePickerButton(initDateTime: DateTime.now().add(Duration(minutes: 1))),
                            DurationPickerButton(initDuration: Duration()),
                          ],
                        ),
                      ),
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
                          maxLength: 25,
                          cursorColor: Colors.teal,
                          textAlign: TextAlign.start,
                          onChanged: (String newName) {
                            newTask.changeName(newName);
                          },
                          showCursor: true,
                          maxLengthEnforced: true,
                          decoration:
                          InputDecoration.collapsed(
                            hintText: 'Task Name',
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
                          maxLines: null,
                          textAlign: TextAlign.start,
                          cursorColor: Colors.teal,
                          onChanged: (String newDes) {
                            newTask.changeDes(newDes);
                          },
                          showCursor: true,
                          maxLengthEnforced: true,
                          decoration:
                          InputDecoration.collapsed(
                            hintText: 'Task Description',
                          )
                      ),
                    ),
                    NiceButton(
                      width: MediaQuery.of(context).copyWith().size.width/3,
                      elevation: 8.0,
                      radius: 52.0,
                      fontSize: MediaQuery.of(context).copyWith().size.width/30,
                      text: "Add New Task",
                      textColor: Colors.white,
                      background: ((newTask.storedName() != null && newTask.storedName().replaceAll(' ', '').length!=0) ? Colors.teal : Colors.blueGrey[100]),
                      onPressed: () async {
                        String name = newTask.storedName();
                        if (name != null && name.replaceAll(' ', '').length!=0) {
                          DateTime setTime = newTask.storedDateTime();
                          Duration length = newTask.storedDuration();
                          if (length == null ) {
                            length = Duration();
                          }
                          if (setTime == null ) {
                            setTime = DateTime.now().add(Duration(minutes: 1));
                          }
                          if (setTime.isBefore(DateTime.now())){
                            setTime = DateTime.now().add(Duration(minutes: 1));
                          }
                          String index = getIndex(setTime);
                          String time = DateFormat('Hm').format(setTime).toString();
                          String description = newTask.storedDes();
                          bool notify = newTask.storedNotify();
                          Task tempTask = Task(index: index, name: name, time: time, description: (description != null ? description : ""), notify: notify, isComplete: false, isOverdue: false, isArchived: false, isExpired: false, opacity: 1, dt: setTime, length: length);
                          int id = await widget.tasksBloc.addTaskToDatabase(tempTask);
                          if (tempTask.notify) {
                            widget.enableNotification(id, tempTask.name, tempTask.dt);
                          }
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}