import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddExpense extends StatefulWidget {
  AddExpense({Key key}) : super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  bool showFab = true;
  PersistentBottomSheetController bottomSheetController;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        mini: true,
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          bottomSheetController = showBottomSheet(
              context: context, builder: (context) => BottomSheetWidget());
          // bottomSheetController.closed.then((value) {
          // showFloatingActionButton(false);
          // });

          //bottomSheetController.close();
          // showFloatingActionButton(true);
        });
  }

  void showFloatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}

//widget inside the pop-up
class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      height: 300,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey[300],
                        spreadRadius: 5)
                  ]),
              child: Column(children: [DecoratedTextField(), DatePicker()]),
            )
          ]),
    ));
  }
}

class DecoratedTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 60,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: TextField(
            autocorrect: true,
            showCursor: true,
            maxLengthEnforced: true,
            maxLength: 20,
            textAlign: TextAlign.start,
            decoration: InputDecoration.collapsed(
              hintText: 'Item Description',
            )),
      ),
      Container(
        height: 60,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: TextField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            decoration: InputDecoration.collapsed(
              hintText: '0.00',
            )),
      ),
      CategorySelector()
    ]);
  }
}

class CategorySelector extends StatefulWidget {
  CategorySelector({Key key}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String newValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: newValue,
      items: [
        DropdownMenuItem<String>(
          value: "1",
          child: Text(
            "Entertainment",
          ),
        ),
        DropdownMenuItem<String>(
          value: "2",
          child: Text(
            "Food",
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          newValue = value;
        });
      },
      hint: Text(
        "Category",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  DatePicker({Key key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime pickedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  String convertDate(DateTime datetime) {
    String result =
        "${datetime.year.toString()}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
    return result;
  }

  Widget datetime() {
    return CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        onDateTimeChanged: (DateTime newdate) {
          pickedDate = newdate;
          setState(() {});
        },
        use24hFormat: true,
        maximumDate: new DateTime(DateTime.now().year, DateTime.now().month + 3,
            DateTime.now().day + 14),
        minimumYear: DateTime.now().year,
        maximumYear: DateTime.now().year,
        mode: CupertinoDatePickerMode.date);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        convertDate(pickedDate),
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.orange,
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext builder) {
              return Container(
                child: datetime(),
                height: MediaQuery.of(context).copyWith().size.height / 3,
              );
            });
      },
    );
  }
}
