import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/screens/entries_screen/entry_view.dart';
import 'package:wrotto/screens/entries_screen/new_entry_screen.dart';
import 'package:wrotto/screens/settings_screen.dart';
import 'package:wrotto/utils/utilities.dart';
import 'package:wrotto/models/mood.dart';

class EntriesScreen extends StatefulWidget {
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  String selectedTag = "All";
  int selectedTagIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<EntriesProvider>(
      builder: (context, provider, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewEntryScreen()));
            },
            child: Icon(Icons.add),
          ),
          body: !provider.initilised
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: MediaQuery.of(context).padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Entries",
                            style: TextStyle(fontSize: 36),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => SettingsScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.settings),
                          ),
                        )
                      ]),
                      SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                            onLongPressEnd: provider.tags[index]
                                                        .compareTo("All") ==
                                                    0
                                                ? null
                                                : (details) {
                                                    showEditDeleteTagDialog(
                                                        context,
                                                        provider,
                                                        provider.tags[index]);
                                                  },
                                            onTap: () {
                                              setState(() {
                                                Utilities.vibrate();
                                                selectedTag =
                                                    provider.tags[index];
                                                selectedTagIndex = index;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                provider.tags[index],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: selectedTag.compareTo(
                                                                provider.tags[
                                                                    index]) ==
                                                            0
                                                        ? Colors.black
                                                        : Colors.grey),
                                              ),
                                            )),
                                    itemCount: provider.tags.length,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  GestureDetector(
                                      onTap: () {},
                                      child: Center(child: Icon(Icons.add))),
                                ]),
                          )),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => EntryView(
                                          journalEntry:
                                              provider.getjournalEntries(
                                                  selectedTag)[index])));
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (provider
                                          .getjournalEntries(selectedTag)[index]
                                          .medias
                                          .length !=
                                      0)
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                10,
                                        child: Image.file(
                                          File(provider
                                              .getjournalEntries(
                                                  selectedTag)[index]
                                              .medias
                                              .first),
                                          alignment: FractionalOffset.center,
                                          fit: BoxFit.cover,
                                        )),
                                  Row(children: [
                                    Text(
                                      Utilities.beautifulDate(
                                        provider
                                            .getjournalEntries(
                                                selectedTag)[index]
                                            .date,
                                      ),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 20,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: provider
                                            .getjournalEntries(
                                                selectedTag)[index]
                                            .tags
                                            .length,
                                        itemBuilder: (context, _index) => Card(
                                          child: Text(provider
                                              .getjournalEntries(
                                                  selectedTag)[index]
                                              .tags[_index]),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      provider
                                          .getjournalEntries(selectedTag)[index]
                                          .mood
                                          .toEmoji(),
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          4 /
                                          5,
                                      child: Text(
                                        provider
                                            .getjournalEntries(
                                                selectedTag)[index]
                                            .title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount:
                              provider.getjournalEntries(selectedTag).length,
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  showEditDeleteTagDialog(
      BuildContext context, EntriesProvider provider, String tag) {
    TextEditingController _catController = TextEditingController();
    _catController.text = tag;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                    height: 120,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(children: [
                          TextField(
                            controller: _catController,
                          ),
                          Row(children: [
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                color: Colors.blueAccent,
                                onPressed: () {
                                  provider.editTag(tag, _catController.text);
                                },
                                child: Text("Save")),
                            SizedBox(
                              width: 26,
                            ),
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                color: Colors.blueAccent,
                                onPressed: () {
                                  provider
                                      .deleteTag(tag)
                                      .then((value) => Navigator.pop(context));
                                },
                                child: Text("Delete")),
                          ]),
                        ]),
                      ),
                    )));
          });
        });
  }

  showTagAddDialog(
    BuildContext context,
    EntriesProvider provider,
  ) {
    final tagText = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                    height: 120,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: tagText,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: 'tag'),
                            ),
                            SizedBox(
                                width: 320,
                                height: 40,
                                child: RaisedButton(
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  onPressed: () {
                                    if (tagText.text.isNotEmpty) {
                                      provider.insertTag(tagText.text).then(
                                          (value) => Navigator.pop(context));
                                    } else {
                                      Utilities.showToast("Can't be empty");
                                    }
                                  },
                                  child: Text("Save"),
                                ))
                          ],
                        ))));
          });
        });
  }
}
