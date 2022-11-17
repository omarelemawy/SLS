import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:http/http.dart'as http;

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@drawable/splash');

    IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true);

    const IOSNotificationDetails iosNotificationDetails =
    IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification(
      {required int id,
        required String title,
        required String body,
        required int seconds}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showNotificationWithPayload(
      {required int id,
        required String title,
        required String body,
        required String payload}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onSelectNotification(String? payload) {
    print('payload $payload');
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
  var servertoken='AAAAf2taGu4:APA91bGfmilZZqCHktBHjWtO5R10bKfRuyJQ-ZN8iGbE7mWFCIugH8vZv3CCQF_8ji9PQ518QzDGTxfKxIVtZJpH8Teh0-7ZbKeLwEPqMR5EYcoQ7IwaG55weTRiIXvyQfkGR5ismmUE';
  sendnotifylistener(String title,String body, String id)async
  {
    try{
    String? token = await FirebaseMessaging.instance.getToken();
   await http.post(
     Uri.parse('http://fcm.googleapis.com/fcm/send'),
     headers: <String,String>{
       'Content_Type':'application/json',
       'Authorization':'key=$servertoken',
     },
   body:jsonEncode(
     <String,dynamic>{
       'notification':<String,dynamic>{
         'body':body.toString(),
         'title':title.toString(),
       },
       'priority':'high',
       'data':<String,dynamic>{
         'click_action':'FLUTTER_NOTIFICATION_CLICK',
         'id':id.toString(),
         'body':body.toString(),
         'title':title.toString(),
       },
       'to':token,

     }
   ) ,
   );
  }catch(e){print("${e.toString()}eroorrrrrrrrrrrrrrrrrrrr");}}
  getmessage()
  {
    FirebaseMessaging.onMessage.listen((event) {
      print("boduyyyyyyyyyyyyyyyyy${event.notification?.body}");
      print("boduyyyyyyyyyyyyyyyyy${event.notification?.body}");
      print("boduyyyyyyyyyyyyyyyyy${event.data['name']}");
    });
  }

}
