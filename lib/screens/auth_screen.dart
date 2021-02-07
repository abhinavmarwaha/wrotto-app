import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/providers/auth_provider.dart';
import 'package:wrotto/screens/homepage.dart';

class AuthScreen extends StatefulWidget {
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _auth = false;
  bool _didAuthenticate = false;

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false)
        .getSecMode()
        .then((value) {
      setState(() {
        _auth = value;
      });
      _auth = value;
      authenticate();
    });
  }

  authenticate() async {
    if (_auth) {
      _didAuthenticate = await LocalAuthentication().authenticateWithBiometrics(
        localizedReason: '',
      );
      if (_didAuthenticate) {
        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => MyHomePage(title: 'Wrotto')));
      }
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => MyHomePage(title: 'Wrotto')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            authenticate();
          },
          child: Text("Retry"),
        ),
      ),
    );
  }
}
