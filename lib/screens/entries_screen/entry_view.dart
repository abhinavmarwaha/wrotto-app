import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrotto/models/journal_entry.dart';
import 'package:wrotto/models/mood.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/screens/entries_screen/new_entry_screen.dart';
import 'package:wrotto/utils/utilities.dart';
import 'package:provider/provider.dart';

class EntryView extends StatelessWidget {
  const EntryView({Key key, @required this.journalEntry}) : super(key: key);

  final JournalEntry journalEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => NewEntryScreen(
                    journalEntry: journalEntry,
                  )));
        },
        child: Icon(Icons.edit),
      ),
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Provider.of<EntriesProvider>(context, listen: false)
                      .deleteJournalEntry(journalEntry)
                      .then((value) => Navigator.of(context).pop());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete),
                )),
            if (journalEntry.medias.length != 0 &&
                journalEntry.medias.first.compareTo("") != 0)
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
            if (journalEntry.tags != null &&
                journalEntry.tags.length != 0 &&
                journalEntry.tags.first.compareTo("") != 0)
              SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      index = index;
                      print(index);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          journalEntry.tags[index],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                    itemCount: journalEntry.tags.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Utilities.beautifulDate(journalEntry.date),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                journalEntry.locationDisplayName ?? "",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 12,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    journalEntry.tags[index],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                itemCount: journalEntry.tags.length,
                scrollDirection: Axis.horizontal,
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
