import 'package:flutter/cupertino.dart';
import 'package:wrotto/models/journal_entry.dart';

class EntryView extends StatelessWidget {
  const EntryView({Key key, @required this.journalEntry}) : super(key: key);

  final JournalEntry journalEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [Text(journalEntry.date.toString())],
        )
      ],
    );
  }
}
