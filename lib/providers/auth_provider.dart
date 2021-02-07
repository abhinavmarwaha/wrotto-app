import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String SEC = "sec";

class AuthProvider with ChangeNotifier {
  static final AuthProvider instance = AuthProvider._internal();
  factory AuthProvider() {
    return instance;
  }
  AuthProvider._internal() {
    _init();
  }
  bool initilised = false;

  bool _secmode;

  _init() {
    if (!initilised) {
      _secmode = false;
      getSecMode().then((value) {
        _secmode = value;
        initilised = true;
        notifyListeners();
      });
    }
  }

  bool secMode() => _secmode;

  setSecMode(bool secModebool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SEC, secModebool);
    _secmode = secModebool;
    notifyListeners();
  }

  Future<bool> getSecMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool secmode;
    if (prefs.containsKey(SEC))
      secmode = prefs.getBool(SEC);
    else {
      await prefs.setBool(SEC, false);
      secmode = false;
    }
    return secmode;
  }
}
