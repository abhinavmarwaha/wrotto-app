import 'package:wrotto/models/journal_entry.dart';

class ExportToJson {
  final List<JournalEntry> journalEntriesAll;

  ExportToJson(this.journalEntriesAll);

  String jsonResult() {
    String json = journalEntriesAll.map((e) => e.toJson()).join(",");
    json = "[" + json + "]";
    return json;
  }
}
