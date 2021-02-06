import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/constants/strings.dart';
import 'package:wrotto/services/theme_changer.dart';
import 'package:wrotto/utils/utilities.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _zenReader = false;

  @override
  void initState() {
    ThemeChanger.getDarkModePlainBool().then((value) {
      setState(() {
        _darkMode = value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.mood),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Dark Mode"),
                  Spacer(),
                  Switch(
                    onChanged: (val) {
                      setState(() {
                        _darkMode = val;
                        _themeChanger.setDarkMode(_darkMode);
                      });
                    },
                    value: _darkMode,
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.horizontal_split),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Fingerprint Lock"),
                  Spacer(),
                  Switch(
                    onChanged: (val) {
                      setState(() {
                        _zenReader = val;
                      });
                    },
                    value: _zenReader,
                  )
                ],
              ),
            ),
          ),
          Card(
            child: GestureDetector(
              onTap: () {
                openFeaturesForm();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.app_registration),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Request Features")
                ]),
              ),
            ),
          ),
          Card(
            child: GestureDetector(
              onTap: () {
                openRateApp();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.rate_review),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Rate App")
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  openFeaturesForm() {
    Utilities.launchInWebViewOrVC(FEATUREFORMURL);
  }

  openRateApp() {
    Utilities.launchInWebViewOrVC(RATEAPPURL);
  }
}
