import 'package:DaySpend/planner/widget_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nice_button/NiceButton.dart';
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
  DateTime limit;

  @override
  void initState() {
    newDateTime = widget.initDateTime;
    tempOldDateTime = widget.initDateTime;
    limit = widget.initDateTime;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).copyWith().size.width;
    return NiceButton(
      text: DateFormat('EEEE').format(tempOldDateTime).toString() + " - " + DateFormat('Hm').format(tempOldDateTime).toString(),
      background: Colors.teal,
      elevation: 6,
      fontSize: width/40,
      textColor: Colors.white,
      width: width/2.7,
      radius: 30.0,
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
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
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
                          minuteInterval: 1,
                          minimumDate: limit,
                          maximumDate: limit.add(Duration(days: 6)),
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
                            Provider.of<PlannerWidgetValues>(context).changeDateTime(newDateTime);
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

