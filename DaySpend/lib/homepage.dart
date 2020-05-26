import 'package:DaySpend/expenses/add_expense_popup.dart';
import 'package:flutter/material.dart';
import 'package:DaySpend/expenses/homepage_expenses.dart';
class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
                  HomePageExpenses(),
                  //replace with planner homepage widget
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
