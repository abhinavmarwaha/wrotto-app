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
            center: LatLng(provider.journalEntriesAll.first.latitude,
                provider.journalEntriesAll.first.longitude),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(
              markers: provider.journalEntriesAll
                  .map(
                    (entry) => Marker(
                      width: 10.0,
                      height: 10.0,
                      point: LatLng(entry.latitude, entry.longitude),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      EntryView(journalEntry: entry)));
                        },
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
                          width: 10,
                        ),
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
