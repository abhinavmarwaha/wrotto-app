import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/constants/strings.dart';
import 'package:wrotto/providers/auth_provider.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/services/theme_changer.dart';
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
  bool _authBool = false;

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
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // Card(
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Icon(Icons.mood),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text("Dark Mode"),
          //         Spacer(),
          //         Switch(
          //           onChanged: (val) {
          //             setState(() {
          //               _darkMode = val;
          //               _themeChanger.setDarkMode(_darkMode);
          //             });
          //           },
          //           value: _darkMode,
          //         )
          //       ],
          //     ),
          //   ),
          // ),
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
          // Card(
          //   child: GestureDetector(
          //     onTap: () {
          //       openBackupDialog();
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(children: [
          //         Icon(Icons.backup),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text("Backup to Server")
          //       ]),
          //     ),
          //   ),
          // ),
          // Card(
          //   child: GestureDetector(
          //     onTap: () {
          //       exportJson();
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(children: [
          //         Icon(Icons.file_copy),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text("Export to Json")
          //       ]),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
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
        return Dialog(child: StatefulBuilder(builder: (context, setState) {
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
        }));
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
