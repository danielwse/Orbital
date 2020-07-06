import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  Header({@required this.text, @required this.size, this.italic = false, this.color, this.weight, this.underline = false, this.shadow});
  final double size;
  final String text;
  Shadow shadow;
  bool italic;
  FontWeight weight;
  Color color;
  bool underline;
  @override
  Widget build(BuildContext context) {
    FontStyle key;
    TextDecoration dec;
    if (!italic) {
      key = FontStyle.normal;
    } else {
      key = FontStyle.italic;
    }
    if (color == null) {
      color = Colors.black;
    }
    if (!underline) {
      dec = TextDecoration.none;
    } else {
      dec = TextDecoration.underline;
    }
    if (weight == null) {
      weight = FontWeight.w300;
    }
    return Text(
      text,
      style: TextStyle(
          shadows: [
            shadow,
          ],
          decoration: dec,
          decorationColor: color,
          fontSize: size,
          fontWeight: weight,
          fontStyle: key,
          color: color),
    );
  }
}
