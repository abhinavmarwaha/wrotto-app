import 'package:flutter/material.dart';
import 'package:wrotto/screens/medias_screen.dart';
import 'package:wrotto/screens/calendar_screen.dart';
import 'package:wrotto/screens/entries_screen/entries_screen.dart';
import 'package:wrotto/screens/map_screens/map_screen.dart';
import 'package:wrotto/screens/stats_screen.dart';
import 'package:wrotto/services/db_helper.dart';

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
    return Scaffold(
      body: SizedBox.expand(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: PageView(
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
              color: Colors.black,
            ),
            label: "Entries",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: Colors.black,
              ),
              label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.perm_media,
                color: Colors.black,
              ),
              label: "Media"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.graphic_eq,
                color: Colors.black,
              ),
              label: "Stats"),
        ],
      ),
    );
  }
}
