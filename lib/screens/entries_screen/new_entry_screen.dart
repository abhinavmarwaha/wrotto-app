import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:gps/gps.dart';
import 'package:latlong/latlong.dart';
// import 'package:location/location.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/location/picker.dart';
import 'package:wrotto/models/journal_entry.dart';
import 'package:wrotto/models/mood.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/screens/entries_screen/entry_view.dart';
import 'package:wrotto/utils/utilities.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({Key key, this.journalEntry}) : super(key: key);

  final JournalEntry journalEntry;
  _NewEntryScreenState createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  TextEditingController _textController;
  TextEditingController _titleController;
  DateTime _dateTime;
  List<String> selectedTags;
  Mood selectedMood;
  List<String> files;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2111));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateTime = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, _dateTime.hour, _dateTime.minute);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
            selectedTime.hour, selectedTime.minute);
      });
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    if (widget.journalEntry == null) {
      selectedTags = [];
      files = [];
      selectedMood = Mood.neutral;
      _dateTime = DateTime.now();
    } else {
      _textController.text = widget.journalEntry.text;
      _titleController.text = widget.journalEntry.title;

      selectedTags = [];
      files = [];
      selectedTags.addAll(widget.journalEntry.tags);
      files.addAll(widget.journalEntry.medias);
      _dateTime = widget.journalEntry.date;
      selectedMood = widget.journalEntry.mood;
      if (widget.journalEntry.longitude != null) {
        _pickedLocation = {};
        _pickedLocation["latlng"] =
            LatLng(widget.journalEntry.latitude, widget.journalEntry.longitude);
        _displayLocationName = widget.journalEntry.locationDisplayName;
      }
    }
  }

  Map _pickedLocation = {};
  String _displayLocationName = "";

  Future getLocationWithNominatim() async {
    // print('location');
    // try {
    //   var latlng = await Gps.currentGps();
    // } catch (e) {
    //   print(e);
    // }
    // print('location2');
    // var location = Location();
    // bool enabled = await location.serviceEnabled();
    // if (!enabled) {
    //   bool gotEnabled = await location.requestService();
    //   if (!gotEnabled) {
    //     Utilities.showToast("You have to enable GPS");
    //     return;
    //   }
    // }

    Utilities.showInfoToast("Don't forget to on the GPS!");

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
        _displayLocationName = reverseSearchResult.displayName;
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
    return Consumer<EntriesProvider>(builder: (context, provider, child) {
      print(provider.tags.join(","));
      return Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _pickedLocation != null
                  ? SizedBox(
                      height: 20,
                      child: Text(
                        _displayLocationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Container(),
              if (provider.tags.length != 0)
                SizedBox(
                  height: 64,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        index = index + 1;
                        print(index);
                        return GestureDetector(
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
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: selectedTags
                                                .contains(provider.tags[index])
                                            ? Colors.black
                                            : Colors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    provider.tags[index],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: selectedTags
                                                .contains(provider.tags[index])
                                            ? Colors.black
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            ));
                      },
                      itemCount: provider.tags.length - 1,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              SizedBox(
                height: 32,
                child: Row(
                  children: [
                    Row(children: [
                      GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Text(Utilities.beautifulDate(_dateTime)
                              .split("at")[0])),
                      Text(" at "),
                      GestureDetector(
                          onTap: () => _selectTime(context),
                          child: Text(Utilities.beautifulDate(_dateTime)
                              .split("at")[1]))
                    ]),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        final journalEntry = JournalEntry(
                            id: widget.journalEntry?.id,
                            date: _dateTime,
                            text: _textController.text,
                            title: _titleController.text,
                            tags: selectedTags,
                            lastModified: DateTime.now(),
                            latitude: _pickedLocation["latlng"]?.latitude,
                            longitude: _pickedLocation["latlng"]?.longitude,
                            locationDisplayName: _displayLocationName,
                            medias: files,
                            mood: selectedMood,
                            synchronised: false);

                        if (widget.journalEntry != null) {
                          provider.editJournalEntry(journalEntry).then((value) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        EntryView(journalEntry: journalEntry)));
                          });
                        } else {
                          provider
                              .insertJournalEntry(journalEntry)
                              .then((value) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        EntryView(journalEntry: journalEntry)));
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Done"),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 78,
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
              SizedBox(
                height: 74,
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
                            child: files != null &&
                                    files.length != 0 &&
                                    files.first.compareTo("") != 0
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
      ));
    });
  }
}
