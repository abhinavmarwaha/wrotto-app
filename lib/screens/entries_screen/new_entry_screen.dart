import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/constants/strings.dart';
import 'package:wrotto/models/journal_entry.dart';
import 'package:wrotto/providers/entries_provider.dart';
import 'package:wrotto/utils/utilities.dart';

class NewEntryScreen extends StatefulWidget {
  _NewEntryScreenState createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  TextEditingController _textController;
  TextEditingController _titleController;
  DateTime _today;
  List<String> selectedTags;

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];


  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    selectedTags = [];
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
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
    }
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
              Expanded(
                flex: 2,
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
                          child: Text(
                            provider.tags[index],
                            style: TextStyle(
                                fontSize: 18,
                                color:
                                    selectedTags.contains(provider.tags[index])
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
                    Text(weekdays[_today.weekday] +
                        " , " +
                        months[_today.month] +
                        " " +
                        _today.day.toString() +
                        " , " +
                        _today.year.toString() +
                        " at " +
                        _today.hour.toString() +
                        ":" +
                        _today.minute.toString()),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        provider.insertJournalEntry(JournalEntry(
                            date: _today,
                            text: _textController.text,
                            title: _titleController.text,
                            tags: selectedTags));
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
                child: TextField(
                  controller: _titleController,
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
              Expanded(
                flex: 10,
                child: TextField(
                  controller: _textController,
                  maxLines: 35,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '🙂',
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getLocationWithNominatim();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Icon(Icons.map),
                              Text(_displayName)
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            filePicker();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.file_copy),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.perm_media),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
