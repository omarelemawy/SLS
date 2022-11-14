import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final Timestamp chattime;
  SingleMessage({
    required this.message,
    required this.isMe,
    required this.chattime
    //3935501
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              constraints: BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                color: isMe ? Colors.pink[200] : Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              child: Column(
                children: [
                  Text(message,style: TextStyle(color: Colors.black,),),
                ],
              )
            ),
            Text(  timeago.format(chattime.toDate()),style: TextStyle(color: Colors.pink[200],),),
          ],
        ),

      ],
      
    );
  }
}