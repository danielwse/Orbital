import 'package:DaySpend/planner/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';

class DatePickerButton extends StatefulWidget {
  final DateTime initDateTime;
  DatePickerButton({this.initDateTime});

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  DateTime newDateTime;
  DateTime tempOldDateTime;
  DateTime base;
  DateTime ref;

  @override
  void initState() {
    ref = widget.initDateTime;
    newDateTime = widget.initDateTime;
    tempOldDateTime = !widget.initDateTime.isBefore(DateTime.now())? widget.initDateTime : DateTime.now();
    base = DateTime.now();
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String textInput = DateFormat('E').format(tempOldDateTime).toString() + " - " + DateFormat('Hm').format(tempOldDateTime).toString();
    double width = MediaQuery.of(context).copyWith().size.width;
    return NiceButton(
      text: textInput,
      padding: const EdgeInsets.all(12.0),
      background: Colors.teal,
      elevation: 6,
      fontSize: width/40,
      textColor: Colors.white,
      width: width/4.5,
      radius: 10.0,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Color(0xff757575),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: MediaQuery.of(context).copyWith().size.height / 4,
                        width: MediaQuery.of(context).copyWith().size.width / 1.5,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.dateAndTime,
                          initialDateTime: tempOldDateTime,
                          onDateTimeChanged: (DateTime dt) {
                            setState(() {
                              newDateTime = dt;
                            });
                          },
                          use24hFormat: true,
                          minimumDate: base,
                          maximumDate: base.add(Duration(days: 6)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: NiceButton(
                          width: 100,
                          text: "Confirm",
                          elevation: 8.0,
                          radius: 52.0,
                          fontSize: 16,
                          textColor: Colors.white,
                          background: Colors.teal,
                          onPressed: () {
                            newDateTime = !newDateTime.isBefore(DateTime.now()) ? newDateTime : DateTime.now();
                            DateTime catchBug = DateTime(base.year,base.month,base.day,ref.hour,ref.minute).add(Duration(days: 1));
                            if (catchBug == newDateTime) {
                              newDateTime = DateTime.now().add(Duration(minutes: 1));
                            }
                            print("(Edit) Set time is: " + newDateTime.toString());
                            Provider.of<PlannerWidgetFunctions>(context).changeDateTime(newDateTime);
                            tempOldDateTime = newDateTime;
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

