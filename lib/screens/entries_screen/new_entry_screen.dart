import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/models/journal_entry.dart';
import 'package:wrotto/models/mood.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/screens/entries_screen/entry_view.dart';
import 'package:wrotto/utils/utilities.dart';

class NewEntryScreen extends StatefulWidget {
  _NewEntryScreenState createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  TextEditingController _textController;
  TextEditingController _titleController;
  DateTime _today;
  List<String> selectedTags;
  Mood selectedMood;
  List<String> files;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    selectedTags = [];
    files = [];
    selectedMood = Mood.neutral;
    _today = DateTime.now();
  }

  Map _pickedLocation = {};
  String _displayName = "";

  Future getLocationWithNominatim() async {
    Map result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return NominatimLocationPicker(
            searchHint: 'Location',
            awaitingForLocation: "Awaiting Location",
          );
        });
    if (result != null) {
      LatLng latLng = result["latlng"];

      final reverseSearchResult = await Nominatim.reverseSearch(
        lat: latLng.latitude,
        lon: latLng.longitude,
        addressDetails: true,
        extraTags: true,
        nameDetails: true,
      );
      setState(() {
        _pickedLocation = result;
        _displayName = reverseSearchResult.displayName;
      });
    } else {
      return;
    }
  }

  filePicker() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;
      files.clear();
      setState(() {
        print(file.path);
        files.add(file.path);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EntriesProvider>(
      builder: (context, provider, child) => Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _pickedLocation != null
                  ? Expanded(
                      flex: 1,
                      child: Text(_displayName),
                    )
                  : Container(),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            Utilities.vibrate();
                            if (selectedTags.contains(provider.tags[index]))
                              selectedTags.remove(provider.tags[index]);
                            else
                              selectedTags.add(provider.tags[index]);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: provider.tags[index].compareTo("All") == 0
                              ? null
                              : Text(
                                  provider.tags[index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: selectedTags
                                              .contains(provider.tags[index])
                                          ? Colors.black
                                          : Colors.grey),
                                ),
                        )),
                    itemCount: provider.tags.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 12,
                    ),
                    Text(Utilities.beautifulDate(_today)),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        final journalEntry = JournalEntry(
                            date: _today,
                            text: _textController.text,
                            title: _titleController.text,
                            tags: selectedTags,
                            lastModified: DateTime.now(),
                            latitude: _pickedLocation["latlng"].latitude,
                            longitude: _pickedLocation["latlng"].longitude,
                            locationDisplayName: _displayName,
                            medias: files,
                            mood: selectedMood,
                            synchronised: false);

                        provider.insertJournalEntry(journalEntry).then((value) {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      EntryView(journalEntry: journalEntry)));
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Done"),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: TextField(
                    controller: _titleController,
                    style: TextStyle(
                      fontSize: 32,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Title"),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: TextField(
                  controller: _textController,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  maxLines: 35,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Text"),
                ),
              ),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                              children: Mood.values
                                  .map(
                                    (mood) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedMood = mood;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 40,
                                          height: 34,
                                          decoration: BoxDecoration(
                                              color: mood == selectedMood
                                                  ? Colors.grey
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                            child: Text(
                                              mood.toEmoji(),
                                              style: TextStyle(
                                                fontSize: 26,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getLocationWithNominatim();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.navigation),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          filePicker();
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: files.length != 0
                                ? SizedBox(
                                    width: 24,
                                    child: Image.file(File(files.first)),
                                  )
                                : Icon(
                                    Icons.image,
                                  )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
