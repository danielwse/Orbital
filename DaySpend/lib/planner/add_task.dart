import 'package:DaySpend/database/DatabaseBloc.dart';
import 'package:DaySpend/fonts/header.dart';
import 'package:DaySpend/planner/picker.dart';
import 'package:DaySpend/planner/task.dart';
import 'package:DaySpend/planner/widget_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fswitch/fswitch.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'day2index.dart';

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
    DateTime datetime = DateTime.now();

    return StreamBuilder(
      stream: widget.tasksBloc.tasks,
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        return Consumer<PlannerWidgetValues>(
          builder: (context, newTask, child) {
            return Container(
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
                        Container(
                          width: MediaQuery.of(context).copyWith().size.width/2.5,
                          margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: PickerButton(
                            initDateTime: datetime.add(Duration(minutes: 1)),
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
                          maxLength: 20,
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
                      width: 160,
                      elevation: 8.0,
                      radius: 52.0,
                      fontSize: 14,
                      text: "Add New Task",
                      textColor: Colors.white,
                      background: ((newTask.storedName() != null && newTask.storedName().replaceAll(' ', '').length!=0) ? Colors.teal : Colors.blueGrey[100]),
                      onPressed: () async {
                        String name = newTask.storedName();
                        if (name != null && name.replaceAll(' ', '').length!=0) {
                          DateTime setTime = newTask.storedDateTime();
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
                          Task tempTask = Task(index: index, name: name, time: time, description: (description != null ? description : ""), notify: notify, isComplete: false, isOverdue: false, isArchived: false, isExpired: false, opacity: 1, dt: setTime);
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
