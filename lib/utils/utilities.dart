import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:wrotto/constants/strings.dart';

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

  static showInfoToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
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

  static String beautifulDate(DateTime date) {
    return weekdays[date.weekday - 1] +
        " , " +
        months[date.month-1] +
        " " +
        date.day.toString() +
        " , " +
        date.year.toString() +
        " at " +
        date.hour.toString() +
        ":" +
        date.minute.toString();
  }

  static Future<void> launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
