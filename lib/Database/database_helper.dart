import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'manga_collection.db');
    // print('Database path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<String> getDatabasePath() async {
    return join(await getDatabasesPath(), 'manga_collection.db');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE manga(
        id INTEGER PRIMARY KEY,
        title TEXT,
        type TEXT,
        publisher TEXT,
        imageUrl TEXT,
        startVolume INT,
        endVolume INT,
        not_have TEXT
      )
    ''');
  }

  Future<int> insertManga(Map<String, dynamic> manga) async {
    Database db = await database;
    return await db.insert('manga', manga);
  }

  Future<List<Map<String, dynamic>>> getMangaList() async {
    Database db = await database;
    return await db.query('manga');
  }

  Future<int> updateManga(int id, Map<String, dynamic> manga) async {
    Database db = await database;
    return await db.update(
      'manga',
      manga,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteManga(int id) async {
    Database db = await database;
    return await db.delete(
      'manga',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
