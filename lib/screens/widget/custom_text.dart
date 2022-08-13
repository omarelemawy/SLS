import 'package:flutter/material.dart';


class CustomText extends StatelessWidget {
  final String? text;
  final Color? color;
  final double font;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  CustomText({this.text = "", this.color = Colors.black, this.font = 16,this.textAlign=TextAlign.center,
    this.fontWeight=FontWeight.w400});

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: TextStyle(color: color, fontSize: font,fontWeight: fontWeight),
        textAlign: textAlign
        );
  }
}
