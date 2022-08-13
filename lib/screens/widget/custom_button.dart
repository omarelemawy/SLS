import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color color;
  final double font;
  final double height;
  final double width;
  final double radius;
  final VoidCallback onPressed;
  final double elevation;

  CustomButton(this.onPressed,
      {this.text = "", this.textColor = Colors.black,
        this.color=Colors.white, this.font = 16,this.height=40,this.radius=10,
        this.width=double.infinity,
      this.elevation=10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: MaterialButton(
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius))),
        elevation: elevation,

        height:height,
        color: color,
        child: Text(text,
            style: TextStyle(color: textColor, fontSize: font,fontWeight: FontWeight.bold),
            ),
        onPressed: onPressed,
      ),
    );
  }
}
