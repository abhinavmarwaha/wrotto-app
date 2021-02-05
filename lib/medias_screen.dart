import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/providers/entries_provider.dart';

class MediasScreen extends StatefulWidget {
  _MediasScreeenState createState() => _MediasScreeenState();
}

class _MediasScreeenState extends State<MediasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<EntriesProvider>(
      builder: (context, proveider, child) => GridView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.1)),
          itemBuilder: (context, index) => GestureDetector(
                  child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Container(),
              ))),
    ));
  }
}
