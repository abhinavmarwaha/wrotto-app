import 'package:flutter/widgets.dart';
import 'package:wrotto/constants/strings.dart';
import 'package:wrotto/models/journal_entry.dart';
import 'package:wrotto/models/mood.dart';
import 'package:wrotto/services/db_helper.dart';
import 'package:wrotto/utils/utilities.dart';

class EntriesProvider with ChangeNotifier {
  static final EntriesProvider instance = EntriesProvider._internal();
  factory EntriesProvider() {
    return instance;
  }
  EntriesProvider._internal() {
    _init();
  }
  bool initilised = false;

  DbHelper _dbHelper;
  Map<String, List<JournalEntry>> _journalEntriesbyTag = {};
  Map<Mood, List<JournalEntry>> _journalEntriesbyByMood = {};
  List<JournalEntry> _journalEntriesAll = [];
  Map<DateTime, List<JournalEntry>> _journalEntriesbyDate = {};
  List<String> _tags;

  List<String> get tags => _tags;
  Map<DateTime, List<JournalEntry>> get journalEntriesbyDate =>
      _journalEntriesbyDate;
  Map<Mood, List<JournalEntry>> get journalEntriesbyByMood =>
      _journalEntriesbyByMood;
  List<JournalEntry> get journalEntriesAll => _journalEntriesAll;

  List<double> _moodPercentages = [];

  List<double> get moodPercentages => _moodPercentages;

  Future _init() async {
    if (!initilised) {
      _dbHelper = DbHelper();
      _journalEntriesbyTag = {};
      _tags = await _dbHelper.getTags();
      List<JournalEntry> journalEntries = await _dbHelper.getJournalEntries();
      _journalEntriesAll = [];
      _journalEntriesAll.addAll(journalEntries);

      Mood.values.forEach((mood) {
        _journalEntriesbyByMood[mood] = [];
      });

      _journalEntriesAll.forEach((entry) {
        final minimilesedDate = Utilities.minimalDate(entry.date);
        if (_journalEntriesbyDate[minimilesedDate] == null)
          _journalEntriesbyDate[minimilesedDate] = [];
        _journalEntriesbyDate[minimilesedDate].add(entry);

        _journalEntriesbyByMood[entry.mood].add(entry);
      });

      final totalMood = _journalEntriesAll.length;
      journalEntriesbyByMood.forEach((key, value) {
        _moodPercentages.add(value.length / totalMood * 100);
      });

      _tags.forEach((tag) {
        if (_journalEntriesbyTag[tag] == null) _journalEntriesbyTag[tag] = [];
        _journalEntriesbyTag[tag].addAll(journalEntries.where((entry) {
          entry.tags.forEach((_tag) {
            if (_tag.compareTo(tag) == 0) return true;
          });
          return false;
        }));
      });
      initilised = true;
      notifyListeners();
    }
  }

  List<JournalEntry> getjournalEntries(String tag) => tag.compareTo("All") == 0
      ? _journalEntriesAll
      : _journalEntriesbyTag[tag];

  // Journal Entries

  Future<void> insertJournalEntry(JournalEntry journalEntry) async {
    await _dbHelper.insertJournalEntry(journalEntry);
    _journalEntriesAll.add(journalEntry);
    for (int i = 0; i < journalEntry.tags.length; i++) {
      // if (_journalEntriesbyTag[journalEntry.tags[i]] == null)
      //   _journalEntriesbyTag[journalEntry.tags[i]] = [];
      _journalEntriesbyTag[journalEntry.tags[i]].add(journalEntry);
    }
    notifyListeners();
  }

  Future deleteJournalEntry(JournalEntry journalEntry) async {
    await _dbHelper.deleteJournalEntry(journalEntry.id);
    for (int i = 0; i < journalEntry.tags.length; i++) {
      _journalEntriesbyTag[journalEntry.tags[i]].remove(journalEntry);
      _journalEntriesAll.remove(journalEntry);
    }

    notifyListeners();
  }

  Future insertTag(String tag) async {
    await _dbHelper.insertTag(tag);
    _journalEntriesbyTag[tag] = [];
    _tags.add(tag);
    notifyListeners();
  }

  Future deleteTag(String tag) async {
    await _dbHelper.deleteTag(tag);
    _tags.remove(tag);
    // _savedLaterItems[cat].clear();
    // _savedLaterItemsAll
    //     .removeWhere((element) => element.cat.compareTo(cat) == 0);
    notifyListeners();
  }

  Future editTag(String tagPrev, String tagNew) async {
    await _dbHelper.editTag(tagPrev, tagNew);
    int index = _tags.indexOf(tagPrev);
    _tags[index] = tagNew;
    _journalEntriesbyTag[tagNew] = [];
    for (int i = 0; i < _journalEntriesbyTag[tagPrev].length; i++) {
      final journalEntry = _journalEntriesbyTag[tagPrev][i];
      journalEntry.tags.remove(tagPrev);
      journalEntry.tags.add(tagNew);
      _dbHelper.editJournalEntry(journalEntry);
      _journalEntriesbyTag[tagNew].add(journalEntry);
    }
    _journalEntriesbyTag[tagPrev].clear();
    notifyListeners();
  }
}
