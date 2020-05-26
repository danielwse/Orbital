import 'package:DaySpend/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';

class Expenses extends StatefulWidget {
  Expenses({Key key}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
                floatingActionButton: AddExpense(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                body: Column(children: <Widget>[
                  ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        height: 350,
                        width: double.infinity,
                        color: Colors.white,
                        child: Container(
                            child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "DaySpend",
                                style: TextStyle(
                                    fontFamily: 'HelveticaNeue Medium',
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.settings, size: 25),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.notifications, size: 25),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.assessment, size: 25))
                            ],
                          ),
                          Center(
                              heightFactor: 1,
                              child: Text(
                                "THIS WEEK'S BUDGET",
                                style: TextStyle(
                                    fontFamily: 'HelveticaNeue Medium',
                                    color: Colors.black,
                                    fontSize: 25),
                              )),
                          Spacer(),
                          SizedBox(
                              width: 300,
                              child: Row(children: <Widget>[
                                Text(
                                  "Entertainment",
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeue Light',
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text("\$300 left")
                              ])),
                          SizedBox(
                              width: 300,
                              child: RoundedProgressBar(
                                height: 12,
                                theme: RoundedProgressBarTheme.blue,
                                style: RoundedProgressBarStyle(
                                    borderWidth: 0, widthShadow: 0),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                borderRadius: BorderRadius.circular(24),
                              )),
                          SizedBox(
                              width: 300,
                              child: Row(children: <Widget>[
                                Text(
                                  "Eating Out",
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeue Light',
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text("\$20 left")
                              ])),
                          SizedBox(
                              width: 300,
                              child: RoundedProgressBar(
                                height: 12,
                                theme: RoundedProgressBarTheme.red,
                                style: RoundedProgressBarStyle(
                                    borderWidth: 0, widthShadow: 0),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                borderRadius: BorderRadius.circular(24),
                              )),
                          SizedBox(
                              width: 300,
                              child: Row(children: <Widget>[
                                Text(
                                  "Shopping",
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeue Light',
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text("\$90 left")
                              ])),
                          SizedBox(
                              width: 300,
                              child: RoundedProgressBar(
                                milliseconds: 1000,
                                height: 12,
                                theme: RoundedProgressBarTheme.midnight,
                                style: RoundedProgressBarStyle(
                                    borderWidth: 0, widthShadow: 0),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                borderRadius: BorderRadius.circular(24),
                              )),
                          SizedBox(
                              width: 300,
                              child: Row(children: <Widget>[
                                Text(
                                  "Utilities",
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeue Light',
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text("\$100 left")
                              ])),
                          SizedBox(
                              width: 300,
                              child: RoundedProgressBar(
                                height: 12,
                                theme: RoundedProgressBarTheme.green,
                                style: RoundedProgressBarStyle(
                                    borderWidth: 0, widthShadow: 0),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                borderRadius: BorderRadius.circular(24),
                              ))
                        ])),
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      height: 200,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.tealAccent,
                      ),
                      child: Column(children: <Widget>[
                        Text('HAPPENING TODAY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.blueGrey,
                              fontSize: 20,
                              //insert planner widget
                            ))
                      ]))
                ]))));
  }
}

// class ExpensesWidget extends StatefulWidget {
//   @override
//   _ExpensesWidgetState createState() => _ExpensesWidgetState();
// }

// class _ExpensesWidgetState extends State<ExpensesWidget> {
//   @override
//   Widget build(BuildContext context) {
//     var height = SizeConfig.getHeight(context);
//     var width = SizeConfig.getWidth(context);
//     double fontSize(double size) {
//       return size * width / 414;
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           height: height / 14,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Container(
//                   margin: EdgeInsets.only(left: width / 20),
//                   child: Text("Monthly Expenses",
//                       style: GoogleFonts.playfairDisplaySC(
//                         textStyle: TextStyle(fontSize: fontSize(24)),
//                       ))),
//               Container(
//                 width: width / 3.5,
//                 margin: EdgeInsets.only(right: width / 30),
//                 child: Row(
//                   children: <Widget>[
//                     /*ArrowButton(
//                       margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//                       icon: Icon(
//                         Icons.arrow_back_ios,
//                         size: fontSize(17),
//                       ),
//                     ),*/
//                     Padding(padding: EdgeInsets.only(left: width / 50)),
//                     ArrowButton(
//                       icon: Icon(
//                         Icons.add_circle_outline,
//                         size: fontSize(40),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         Expanded(
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 5,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: category.map((data) {
//                       return Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(right: 10),
//                               width: 10,
//                               height: 10,
//                               decoration: BoxDecoration(
//                                   color: AppColors
//                                       .pieColors[category.indexOf(data)],
//                                   shape: BoxShape.circle),
//                             ),
//                             Text(
//                               data['name'],
//                               style: TextStyle(
//                                 fontSize: fontSize(15),
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 6,
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 10),
//                   child: PieChart(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

/*class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    //path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}*/

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 20;
    while (curXPos < size.width) {
      curXPos += increment;
      path.arcToPoint(Offset(curXPos, curYPos), radius: Radius.circular(5));
    }
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
