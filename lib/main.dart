import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/screens/homepage.dart';
import 'package:wrotto/services/theme_changer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        ],
        child: Builder(builder: (context) {
          final theme = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            title: 'Wrotto',
            debugShowCheckedModeBanner: false,
            theme: theme.getTheme(),
            home: MyHomePage(title: 'Wrotto'),
          );
        }));
  }
}
