import 'package:DaySpend/planner/widget_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';

class DurationPickerButton extends StatefulWidget {
  final Duration initDuration;
  DurationPickerButton({this.initDuration});

  @override
  _DurationPickerButtonState createState() => _DurationPickerButtonState();
}

class _DurationPickerButtonState extends State<DurationPickerButton> {
  Duration newDuration;
  Duration tempDuration;

  @override
  void initState() {
    newDuration = widget.initDuration;
    tempDuration = widget.initDuration;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String textInput = tempDuration.toString().split(":")[0] + "h " + tempDuration.toString().split(":")[1] + "m";
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
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: MediaQuery.of(context).copyWith().size.height / 4,
                        width: MediaQuery.of(context).copyWith().size.width / 1.5,
                        child: CupertinoTimerPicker(
                          initialTimerDuration: tempDuration,
                          mode: CupertinoTimerPickerMode.hm,
                          onTimerDurationChanged: (Duration dur) {
                            setState(() {
                              newDuration = dur;
                            });
                          },
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
                            Provider.of<PlannerWidgetFunctions>(context).changeDuration(newDuration);
                            tempDuration = newDuration;
                            print(tempDuration);
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
