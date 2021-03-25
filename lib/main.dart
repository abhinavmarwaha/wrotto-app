import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/providers/auth_provider.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/providers/reminder_provider.dart';
import 'package:wrotto/screens/auth_screen.dart';
import 'package:wrotto/services/theme_changer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => EntriesProvider.instance,
          ),
          ChangeNotifierProvider(
            create: (_) => ThemeChanger(),
          ),
          ChangeNotifierProvider(
            create: (_) => AuthProvider.instance,
          ),
          ChangeNotifierProvider(
            create: (_) => ReminderProvider.instance,
          ),
        ],
        child: Builder(builder: (context) {
          final theme = Provider.of<ThemeChanger>(context);

          return MaterialApp(
            title: 'Wrotto',
            debugShowCheckedModeBanner: false,
            theme: theme.getTheme(),
            home: AuthScreen(),
          );
        }));
  }
}
