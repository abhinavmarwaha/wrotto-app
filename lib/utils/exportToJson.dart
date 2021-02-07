import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wrotto/providers/entries_provider.dart';

class ExportToJson {
  final BuildContext context;

  ExportToJson(this.context);

  String jsonResult() {
    String json = Provider.of<EntriesProvider>(context)
        .journalEntriesAll
        .map((e) => e.toJson())
        .join(",");
    json = "[" + json + "]";
    return json;
  }
}
