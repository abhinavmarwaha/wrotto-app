import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrotto/services/notifications.dart';

const String REMINDER = "REMINDER";

class ReminderProvider with ChangeNotifier {
  static final ReminderProvider instance = ReminderProvider._internal();
  factory ReminderProvider() {
    return instance;
  }
  ReminderProvider._internal() {
    _init();
  }
  bool initilised = false;
  bool _reminderMode = false;

  String _defRemindingTimeOfDay = "";

  _init() {
    if (!initilised) {
      _reminderMode = false;
      getReminderMode().then((value) {
        _reminderMode = value;
        initilised = true;
        notifyListeners();
      });
    }
  }

  bool reminderMode() => _reminderMode;

  setReminder(bool reminderModeBool, int hour, int min) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(REMINDER, reminderModeBool);
    _reminderMode = reminderModeBool;
    if (reminderModeBool) {
      final _notifs = NotificationsService();
      await _notifs.dailyNotifOnTime(hour, min);
      prefs.setString(
          'defRemindingTimeOfDay', hour.toString() + ":" + min.toString());
    }
    notifyListeners();
  }

  Future<bool> getReminderMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool secmode;
    if (prefs.containsKey(REMINDER))
      secmode = prefs.getBool(REMINDER);
    else {
      await prefs.setBool(REMINDER, false);
      secmode = false;
    }
    return secmode;
  }

  Future<String> getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String defRemindingTimeOfDay;
    if (prefs.containsKey('defRemindingTimeOfDay'))
      defRemindingTimeOfDay = prefs.getString('defRemindingTimeOfDay');
    else {
      await prefs.setString('defRemindingTimeOfDay', "21:00");
    }
    return defRemindingTimeOfDay;
  }
}
