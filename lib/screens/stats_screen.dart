import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/models/mood.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/services/theme_changer.dart';
import 'package:wrotto/utils/utilities.dart';

class StatsScreen extends StatefulWidget {
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int touchedIndex;
  bool darkMode;

  @override
  Widget build(BuildContext context) {
    darkMode = Provider.of<ThemeChanger>(context).getDarkModeVar();
    return Scaffold(
        body: Consumer<EntriesProvider>(
      builder: (context, provider, child) => Padding(
        padding: MediaQuery.of(context).padding,
        child: provider.journalEntriesAll.length == 0
            ? Center(child: Text("No Entries"))
            : Column(children: [
                AspectRatio(
                  aspectRatio: 1.3,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                                pieTouchData: PieTouchData(
                                    touchCallback: (pieTouchResponse) {
                                  setState(() {
                                    if (pieTouchResponse.touchInput
                                            is FlLongPressEnd ||
                                        pieTouchResponse.touchInput
                                            is FlPanEnd) {
                                      touchedIndex = -1;
                                    } else {
                                      touchedIndex =
                                          pieTouchResponse.touchedSectionIndex;
                                    }
                                  });
                                }),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                sections: showingSections(provider)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: Mood.values
                                .map((mood) => Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: [
                                          Text(mood.toEmoji()),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(mood.toShortString())
                                        ],
                                      ),
                                    ))
                                .toList()),
                      ),
                      const SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 45,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Total Entries : " +
                        provider.journalEntriesAll.length.toString()),
                    SizedBox(
                      width: 56,
                    ),
                    Text("Days : " +
                        provider.journalEntriesbyDate.keys.length.toString()),
                  ],
                )

                // AspectRatio(
                //   aspectRatio: 1.66,
                //   child: Card(
                //     elevation: 5,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(6)),
                //     color: Theme.of(context).scaffoldBackgroundColor,
                //     child: Padding(
                //       padding: const EdgeInsets.only(top: 16.0),
                //       child: BarChart(
                //         BarChartData(
                //           alignment: BarChartAlignment.center,
                //           barTouchData: BarTouchData(
                //             enabled: false,
                //           ),
                //           titlesData: FlTitlesData(
                //             show: true,
                //             bottomTitles: SideTitles(
                //               showTitles: true,
                //               getTextStyles: (value) => const TextStyle(
                //                   color: Color(0xff939393), fontSize: 10),
                //               margin: 10,
                //               getTitles: (double value) => value.toInt().toString(),
                //             ),
                //             leftTitles: SideTitles(
                //               showTitles: true,
                //               getTextStyles: (value) => const TextStyle(
                //                   color: Color(
                //                     0xff939393,
                //                   ),
                //                   fontSize: 10),
                //               margin: 0,
                //             ),
                //           ),
                //           gridData: FlGridData(
                //             show: true,
                //             checkToShowHorizontalLine: (value) => value % 10 == 0,
                //             getDrawingHorizontalLine: (value) => FlLine(
                //               color: const Color(0xffe7e8ec),
                //               strokeWidth: 1,
                //             ),
                //           ),
                //           borderData: FlBorderData(
                //             show: false,
                //           ),
                //           groupsSpace: 22,
                //           barGroups: getData(provider),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ]),
      ),
    ));
  }

  List<BarChartGroupData> getData(EntriesProvider provider) {
    DateTime _today = Utilities.minimalDate(DateTime.now());

    return List.generate(
        7,
        (i) => BarChartGroupData(
              x: i++,
              barsSpace: 1,
              barRods: [
                BarChartRodData(
                    y: provider.journalEntriesbyDate[DateTime(
                                _today.year, _today.month - i, _today.day)] !=
                            null
                        ? provider
                            .journalEntriesbyDate[DateTime(
                                _today.year, _today.month - i, _today.day)]
                            .length
                            .toDouble()
                        : 0,
                    rodStackItems: [
                      BarChartRodStackItem(
                          0,
                          provider.journalEntriesbyDate[DateTime(_today.year,
                                      _today.month - i, _today.day)] !=
                                  null
                              ? provider
                                  .journalEntriesbyDate[DateTime(_today.year,
                                      _today.month - i, _today.day)]
                                  .length
                                  .toDouble()
                              : 0,
                          Theme.of(context).accentColor),
                    ],
                    borderRadius: const BorderRadius.all(Radius.zero)),
              ],
            ));
  }

  List<PieChartSectionData> showingSections(EntriesProvider provider) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: provider.moodPercentages[0],
            title: provider.moodPercentages[0].toInt().toString() + '% 😢',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: darkMode ? Colors.white : Colors.black),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: provider.moodPercentages[1],
            title: provider.moodPercentages[1].toInt().toString() + '% 🙁',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: darkMode ? Colors.white : Colors.black),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: provider.moodPercentages[2],
            title: provider.moodPercentages[2].toInt().toString() + '% 😐',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: darkMode ? Colors.white : Colors.black),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.red.withOpacity(0.5),
            value: provider.moodPercentages[3],
            title: provider.moodPercentages[3].toInt().toString() + '% 🙂',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color:darkMode ? Colors.white : Colors.black),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: provider.moodPercentages[4],
            title: provider.moodPercentages[4].toInt().toString() + '% 😁',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: darkMode ? Colors.white : Colors.black),
          );
        default:
          return null;
      }
    });
  }
}
