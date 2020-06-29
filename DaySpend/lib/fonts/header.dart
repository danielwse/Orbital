import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header({@required this.text, @required this.size, this.italic, this.color, this.weight});
  final double size;
  final String text;
  final bool italic;
  FontWeight weight;
  Color color;
  @override
  Widget build(BuildContext context) {
    FontStyle key = FontStyle.normal;
    if (italic) {
      key = FontStyle.italic;
    }
    if (color == null) {
      color = Colors.black;
    }
    if (weight == null) {
      weight = FontWeight.w300;
    }
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          fontStyle: key,
          color: color),
    );
  }
}
