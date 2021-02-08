import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wrotto/constants/strings.dart';
import 'package:wrotto/models/journal_entry.dart';

class DbHelper {
  static final DbHelper _instance = new DbHelper.internal();

  factory DbHelper() => _instance;

  static Database _db;

  openDB() async {
    var database = openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE journalEntry(id INTEGER PRIMARY KEY, title TEXT, text TEXT, date INTEGER, mood TEXT, latitude REAL, longitude REAL, locationDisplayName TEXT, medias TEXT, tags TEXT, synchronised INTEGER, lastModified INTEGER);");
        db.execute("CREATE TABLE tags(id INTEGER PRIMARY KEY, name TEXT); ");
        db.insert(
          TAGS,
          {'name': "All"},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
      version: 1,
    );
    return database;
  }

  DbHelper.internal();

  Future<Database> get getdb async {
    if (_db != null) {
      return _db;
    }
    _db = await openDB();

    return _db;
  }

  // Journal Entries

  // Create

  Future<int> insertJournalEntry(JournalEntry journalEntry) async {
    final Database db = await getdb;

    int id = await db.insert(
      JOURNALENTRY,
      journalEntry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // Read

  Future<List<JournalEntry>> getJournalEntries() async {
    final Database db = await getdb;
    List<Map<String, dynamic>> maps;
    maps = await db.query(JOURNALENTRY);

    return maps.map((e) => JournalEntry.fromMap(e)).toList();
  }

  // Update

  Future<void> editJournalEntry(JournalEntry journalEntry) async {
    final db = await getdb;

    await db.update(
      JOURNALENTRY,
      journalEntry.toMap(),
      where: "id = ?",
      whereArgs: [journalEntry.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } 

  // Delete

  Future<void> deleteJournalEntry(int id) async {
    final db = await getdb;

    await db.delete(
      JOURNALENTRY,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Tags

  // Create

  Future<void> insertTag(String tag) async {
    final Database db = await getdb;

    await db.insert(
      TAGS,
      {'name': tag},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read

  Future<List<String>> getTags() async {
    final Database db = await getdb;

    final List<Map<String, dynamic>> maps = await db.query(TAGS);
    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }

  // Update

  Future<void> editTag(String prevTag, String newTag) async {
    final db = await getdb;

    await db.update(
      TAGS,
      {'name': newTag},
      where: "name = ?",
      whereArgs: [prevTag],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete

  Future<void> deleteTag(String name) async {
    final db = await getdb;

    Batch batch = db.batch();
    batch.delete(TAGS, where: "name == ?", whereArgs: [name]);
    await batch.commit();
  }

  Future close() async {
    var dbClient = await getdb;
    return dbClient.close();
  }

  Future<void> clearTable(String dbName) async {
    final db = await getdb;
    await db.delete(dbName);
  }
}
