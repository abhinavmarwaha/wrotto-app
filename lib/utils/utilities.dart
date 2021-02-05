import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

class Utilities {
  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static DateTime minimalDate(DateTime _date) =>
      DateTime(_date.year, _date.month, _date.day);

  static void vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 70, amplitude: 10);
    }
  }
}
