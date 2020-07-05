import 'package:DaySpend/planner/task_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PickerButton extends StatefulWidget {
  final DateTime initDateTime;
  PickerButton({this.initDateTime});

  @override
  _PickerButtonState createState() => _PickerButtonState();
}

class _PickerButtonState extends State<PickerButton> {
  DateTime newDateTime;
  DateTime tempOldDateTime;

  @override
  void initState() {
    newDateTime = widget.initDateTime;
    tempOldDateTime = widget.initDateTime;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFunction>(
      builder: (context, tempDateTimeData, child) {
        return MaterialButton(
          child: Text(
            DateFormat('EEEE').format(newDateTime).toString() + " - " + DateFormat('Hm').format(newDateTime).toString(),
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.orange,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext builder) {
                  return Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).copyWith().size.height / 3,
                        width: MediaQuery.of(context).copyWith().size.width / 1.2,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.dateAndTime,
                          initialDateTime: newDateTime,
                          onDateTimeChanged: (DateTime dt) {
                            setState(() {
                              newDateTime = dt;
                            });
                          },
                          use24hFormat: true,
                          minuteInterval: 1,
                          minimumDate: tempOldDateTime,
                          maximumDate: tempOldDateTime.add(Duration(days: 7)),
                        ),
                      ),
                      MaterialButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          tempDateTimeData.changeDateTime(newDateTime);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          },
        );
      },
    );
  }
}

