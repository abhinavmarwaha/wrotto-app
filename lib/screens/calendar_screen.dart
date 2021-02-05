import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wrotto/models/journal_entry.dart';
import 'package:wrotto/providers/entries_provider.dart';

class CalendarScreen extends StatefulWidget {
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<JournalEntry> _selectedEvents = [];
  CalendarController _calendarController;

  final greyColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = List<JournalEntry>.from(events);
    });
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EntriesProvider>(
        builder: (context, provider, child) => Padding(
          padding: MediaQuery.of(context).padding,
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: TableCalendar(
              calendarController: _calendarController,
              events: provider.journalEntriesbyDate,
              initialSelectedDay: DateTime.now(),
              dayHitTestBehavior: HitTestBehavior.opaque,
              initialCalendarFormat: CalendarFormat.month,
              formatAnimation: FormatAnimation.slide,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              availableGestures: AvailableGestures.all,
              availableCalendarFormats: const {
                CalendarFormat.month: '',
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
              ),
              onDaySelected: _onDaySelected,
              onCalendarCreated: _onCalendarCreated,
              builders: CalendarBuilders(
                  dowWeekendBuilder: (context, weekend) => Text(
                        weekend,
                        style: TextStyle(color: greyColor),
                        textAlign: TextAlign.center,
                      ),
                  dowWeekdayBuilder: (context, weekday) => Text(
                        weekday,
                        style: TextStyle(color: greyColor),
                        textAlign: TextAlign.center,
                      ),
                  selectedDayBuilder: (context, date, events) =>
                      _dayBuilder(date, events, false, true),
                  todayDayBuilder: (context, date, events) =>
                      _dayBuilder(date, events, true, false),
                  markersBuilder: (context, date, events, holidays) =>
                      <Widget>[],
                  dayBuilder: (context, date, events) =>
                      _dayBuilder(date, events, false, false)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dayBuilder(
      DateTime date, List<dynamic> events, bool today, bool selected) {
    final Color _color = Color(0xFF0984FD).withOpacity(0.25);
    return Center(
      child: Container(
        width: 45,
        height: 45,
        child: Stack(overflow: Overflow.visible, children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 29,
                height: 35,
                decoration: BoxDecoration(
                    color: selected ? Colors.grey : null,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 3)),
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: today ? Colors.black : null,
                        ),
                      ),
                    )),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: events == null
                  ? Container()
                  : Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: Text(
                        events.length.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyText2
                            .copyWith(fontSize: 12),
                      ),
                    ),
            ),
          )
        ]),
      ),
    );
  }
}
