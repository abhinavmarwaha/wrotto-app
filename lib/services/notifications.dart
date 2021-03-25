import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:wrotto/constants/strings.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  notificationsService() {
    serviceSetup();
  }

  Future<void> serviceSetup() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  // dailyNotif(int _id, int hour, int min) async {
  //   var time = Time(hour, min, 0);
  //   ;
  //   var androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESC);
  //   var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //   );
  //   await _flutterLocalNotificationsPlugin.periodicallyShow(
  //     _id,
  //     REMINDER_TITLE,
  //     REMINDER_BODY,
  //     RepeatInterval.daily,
  //     platformChannelSpecifics,
  //     payload: _id.toString(),
  //     androidAllowWhileIdle: true,
  //   );
  // }

  Future dailyNotifOnTime(int hour, int min) async {
    DateTime _today = DateTime.now();
    var dateTime =
        DateTime(_today.year, _today.month, _today.day, hour, min, 0);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    if (dateTime.isBefore(now)) {
      dateTime = dateTime.add(const Duration(days: 1));
    }
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        REMINDER_TITLE,
        REMINDER_BODY,
        tz.TZDateTime.from(dateTime, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESC)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  deleteNotif(int _id) async {
    await _flutterLocalNotificationsPlugin.cancel(_id);
  }

  deleteAllNotif() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  launchDetails() async {
    return await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
  }

  Future<List<PendingNotificationRequest>> getPendingNotif() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  printPendingNotif() async {
    (await _flutterLocalNotificationsPlugin.pendingNotificationRequests())
        .forEach((element) {
      print(element.id);
    });
  }
}
