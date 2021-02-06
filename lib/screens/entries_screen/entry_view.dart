import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrotto/models/journal_entry.dart';
import 'package:wrotto/models/mood.dart';
import 'package:wrotto/utils/utilities.dart';

class EntryView extends StatelessWidget {
  const EntryView({Key key, @required this.journalEntry}) : super(key: key);

  final JournalEntry journalEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: Image.file(
                            File(journalEntry.medias.first),
                          ),
                        ));
              },
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 6,
                  child: Image.file(
                    File(journalEntry.medias.first),
                    alignment: FractionalOffset.center,
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Utilities.beautifulDate(journalEntry.date),
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                journalEntry.locationDisplayName ?? "",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  journalEntry.title,
                  style: TextStyle(fontSize: 36),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  journalEntry.mood.toEmoji(),
                  style: TextStyle(fontSize: 26),
                ),
              )
            ]),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(journalEntry.text))
          ],
        ),
      ),
    );
  }
}
