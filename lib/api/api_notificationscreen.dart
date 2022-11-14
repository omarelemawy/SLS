// import"package:flutter/material.dart";
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationApi{
//   static final _notifications=FlutterLocalNotificationsPlugin();
// static Future _notifocationdetails()async{
//   return NotificationDetails(
//     android:AndroidNotificationDetails('channel id','channel name',importance:Importance.max ) ,
//    // iOS:IOSNotificationDetails()
//   );
// }
//   static Future showNotification({
//     int id=0,
//     String? title,
//     String?body,
//     String? payload,
// })async=>_notifications.show(id, title, body,await _notifocationdetails(),payload: payload);
// }