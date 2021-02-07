import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/screens/entries_screen/entry_view.dart';

class MapScreen extends StatefulWidget {
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EntriesProvider>(
        builder: (context, provider, child) => FlutterMap(
          options: MapOptions(
            center: LatLng(
                provider.journalEntriesHaveLocation.length != 0
                    ? provider.journalEntriesHaveLocation.first.latitude
                    : 51.5,
                provider.journalEntriesHaveLocation.length != 0
                    ? provider.journalEntriesHaveLocation.first.longitude
                    : -1.5),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(
              markers: provider.journalEntriesHaveLocation.length == 0
                  ? []
                  : provider.journalEntriesHaveLocation
                      .map(
                        (entry) => Marker(
                          width: 106,
                          height: 106,
                          point: LatLng(entry.latitude, entry.longitude),
                          builder: (ctx) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            EntryView(journalEntry: entry)));
                              },
                              child: entry.medias.length != 0 &&
                                      entry.medias.first.compareTo("") != 0
                                  ? Image.file(
                                      File(entry.medias.first),
                                    )
                                  : Image.asset(
                                      'assets/text.png',
                                    )

                              // Container(
                              //   height: 10,
                              //   decoration: BoxDecoration(
                              //       shape: BoxShape.circle, color: Colors.black),
                              //   width: 10,
                              // ),
                              ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
