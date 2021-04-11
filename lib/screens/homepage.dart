import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/screens/medias_screen.dart';
import 'package:wrotto/screens/calendar_screen.dart';
import 'package:wrotto/screens/entries_screen/entries_screen.dart';
import 'package:wrotto/screens/map_screens/map_screen.dart';
import 'package:wrotto/screens/stats_screen.dart';
import 'package:wrotto/services/db_helper.dart';
import 'package:wrotto/services/theme_changer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    DbHelper().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = Provider.of<ThemeChanger>(context).getDarkModeVar();
    return WillPopScope(
      onWillPop: () {
        return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: Scaffold(
        body: SizedBox.expand(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    children: <Widget>[
                      EntriesScreen(),
                      CalendarScreen(),
                      MapScreen(),
                      MediasScreen(),
                      StatsScreen(),
                    ]))),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: darkMode ? Colors.white : Colors.black,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 100), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.edit,
                color: darkMode ? Colors.white : Colors.black,
              ),
              label: "Entries",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                color: darkMode ? Colors.white : Colors.black,
              ),
              label: "Calendar",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                  color: darkMode ? Colors.white : Colors.black,
                ),
                label: "Map"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.perm_media,
                  color: darkMode ? Colors.white : Colors.black,
                ),
                label: "Media"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.graphic_eq,
                color: darkMode ? Colors.white : Colors.black,
              ),
              label: "Stats",
            ),
          ],
        ),
      ),
    );
  }
}
