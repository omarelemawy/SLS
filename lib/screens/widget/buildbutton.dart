import 'package:flutter/material.dart';

class  Followbutton extends StatefulWidget{
  Function func;
  String text;
  Followbutton({required this.text,required this.func});

  @override
  State<StatefulWidget> createState() => _FollowbuttonState();
}

class _FollowbuttonState extends State<Followbutton> {
  @override
  Widget build(BuildContext context) {
     return InkWell(
      onTap: widget.func(),
      child: Text(
        widget.text,
        style: TextStyle(
            color: Colors.blue[900],
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
  }


}
