import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/constants/strings.dart';
import 'package:wrotto/providers/auth_provider.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/providers/reminder_provider.dart';
import 'package:wrotto/services/theme_changer.dart';
import 'package:wrotto/utils/custom_icons.dart';
import 'package:wrotto/utils/exportToJson.dart';
import 'package:wrotto/utils/saveFile.dart';
import 'package:wrotto/utils/utilities.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _reminder = false;
  bool _authBool = false;
  double _opacity = 1.0;

  int hour, min;
  String _selectedTime;

  LocalAuthentication _localAuthentication;

  @override
  void initState() {
    ThemeChanger.getDarkModePlainBool().then((value) {
      setState(() {
        _darkMode = value;
      });
    });
    _localAuthentication = LocalAuthentication();

    Provider.of<AuthProvider>(context, listen: false)
        .getSecMode()
        .then((value) => _authBool = value);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _opacity == 1.0
            ? null
            : () {
                setState(() {
                  _opacity = 1.0;
                });
                Navigator.pop(context);
              },
        child: Opacity(
          opacity: _opacity,
          child: ListView(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(CustomIcons.moon),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Dark Mode"),
                      Spacer(),
                      Switch(
                        onChanged: (val) {
                          setState(() {
                            _darkMode = val;
                            Provider.of<ThemeChanger>(context, listen: false)
                                .setDarkMode(_darkMode);
                          });
                        },
                        value: _darkMode,
                      )
                    ],
                  ),
                ),
              ),
              Consumer<ReminderProvider>(builder: (context, provider, child) {
                _reminder = provider.reminderMode();
                provider.getTime().then((value) {
                  _selectedTime = value;
                  hour = int.parse(_selectedTime.split(":")[0]);
                  min = int.parse(_selectedTime.split(":")[1]);
                });
                return Card(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.timelapse),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Reminder"),
                        Spacer(),
                        Switch(
                          onChanged: (val) {
                            setState(() {
                              if (_reminder) {
                                _reminder = val;
                                provider.setReminder(_reminder, null, null);

                                // showDialog(context: context, builder: (context) => Dialog(shape: ,),)
                              } else {
                                setState(() {
                                  _opacity = 0.5;
                                });
                                showBottomSheet(
                                    context: context,
                                    builder: (context) => SizedBox(
                                          height: 250,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _opacity = 1.0;
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: Text("Cancel")),
                                                  Spacer(),
                                                  GestureDetector(
                                                      onTap: () {
                                                        provider.setReminder(
                                                            true, hour, min);
                                                        setState(() {
                                                          _opacity = 1.0;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Done"))
                                                ]),
                                              ),
                                              CupertinoTimerPicker(
                                                initialTimerDuration: Duration(
                                                    minutes: hour * 60 + min),
                                                onTimerDurationChanged:
                                                    (value) {
                                                  hour = value.inHours;
                                                  min = value.inMinutes % 60;
                                                },
                                                mode:
                                                    CupertinoTimerPickerMode.hm,
                                              )
                                            ],
                                          ),
                                        ));
                              }
                            });
                          },
                          value: _reminder,
                        )
                      ],
                    ),
                  ),
                );
              }),
              Consumer<AuthProvider>(
                builder: (context, provider, child) => Card(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.fingerprint),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Fingerprint Lock"),
                        Spacer(),
                        Switch(
                          onChanged: (val) {
                            fingerprintOn(provider, val);
                          },
                          value: _authBool,
                        )
                      ],
                    ),
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
              Card(
                child: GestureDetector(
                  onTap: () {
                    openBackupDialog();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(Icons.backup),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Backup to Server")
                    ]),
                  ),
                ),
              ),
              Card(
                child: GestureDetector(
                  onTap: () {
                    exportJson();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(Icons.file_copy),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Export to Json")
                    ]),
                  ),
                ),
              ),
              Card(
                child: GestureDetector(
                  onTap: () {
                    openBuyMeCoffee();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(CustomIcons.coffee_cup),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Buy Me a Coffee!")
                    ]),
                  ),
                ),
              ),
              Card(
                child: GestureDetector(
                  onTap: () {
                    openGithubRepo();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(Icons.star),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Star the Github Repo")
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  openBuyMeCoffee() {
    Utilities.launchInWebViewOrVC(BUYMEACOFFEE);
  }

  openGithubRepo() {
    Utilities.launchInWebViewOrVC(GITHUBREPO);
  }

  exportJson() {
    String json = ExportToJson(
            Provider.of<EntriesProvider>(context, listen: false)
                .journalEntriesAll
                .where((element) => !element.synchronised)
                .toList())
        .jsonResult();
    saveJson(json)
        .then((value) => Utilities.showInfoToast("Json exported to " + value));
  }

  openBackupDialog() {
    TextEditingController serverText = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextField(
                          controller: serverText,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'ip:port'),
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        String json = ExportToJson(Provider.of<EntriesProvider>(
                                    context,
                                    listen: false)
                                .journalEntriesAll
                                .where((element) => !element.synchronised)
                                .toList())
                            .jsonResult();

                        backupPosts(json, serverText.text)
                            .then((value) => Navigator.pop(context));
                      },
                      child: Text("Export"),
                    )
                  ],
                ),
              ));
        });
      },
    );
  }

  Future<http.Response> backupPosts(String json, String server) {
    return http.post(
      Uri.http(server, 'api/backupEntries/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
  }

  fingerprintOn(AuthProvider provider, bool _secMode) async {
    bool didAuthenticate = await _localAuthentication
        .authenticateWithBiometrics(localizedReason: "");
    setState(() {
      if (didAuthenticate) {
        _authBool = _secMode;
        provider.setSecMode(_authBool);
      }
    });
  }

  openFeaturesForm() {
    Utilities.launchInWebViewOrVC(FEATUREFORMURL);
  }

  openRateApp() {
    Utilities.launchInWebViewOrVC(RATEAPPURL);
  }
}
