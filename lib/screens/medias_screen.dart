import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/screens/entries_screen/entry_view.dart';

class MediasScreen extends StatefulWidget {
  _MediasScreeenState createState() => _MediasScreeenState();
}

class _MediasScreeenState extends State<MediasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: MediaQuery.of(context).padding,
      child: Consumer<EntriesProvider>(
        builder: (context, provider, child) => GridView.builder(
            itemCount: provider.journalEntriesAll.length,
            scrollDirection: Axis.horizontal,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 4)),
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => EntryView(
                                journalEntry:
                                    provider.journalEntriesAll[index])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                        File(provider.journalEntriesAll[index].medias.first)),
                  ),
                )),
      ),
    ));
  }
}
