import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wrotto/models/journal_entry.dart';
import 'package:wrotto/models/mood.dart';
import 'package:wrotto/screens/entries_screen/entry_view.dart';
import 'package:wrotto/utils/utilities.dart';

class EntryCard extends StatelessWidget {
  final JournalEntry journalEntry;

  const EntryCard({Key key, this.journalEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => EntryView(
                        journalEntry: journalEntry,
                      )));
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (journalEntry.medias.length != 0 &&
                  journalEntry.medias.first.compareTo("") != 0)
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 10,
                    child: Image.file(
                      File(journalEntry.medias.first),
                      alignment: FractionalOffset.center,
                      fit: BoxFit.cover,
                    )),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Utilities.beautifulDate(
                      journalEntry.date,
                    ),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: journalEntry.tags.length,
                    itemBuilder: (context, _index) => Card(
                      child: Text(journalEntry.tags[_index]),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    journalEntry.mood.toEmoji(),
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: Text(
                    journalEntry.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
