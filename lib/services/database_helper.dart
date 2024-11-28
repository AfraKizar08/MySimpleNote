import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/notes_model.dart';

class DatabaseHelper {
  static const _databaseName = "notes.db";
  static const _databaseVersion = 1;

  static const table = "notes";

  static const columnId = "id";
  static const columnTitle = "title";
  static const columnContent = "content";
  static const columnColor = "color";
  static const columnDateTime = "dateTime";

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnContent TEXT NOT NULL,
        $columnColor INTEGER NOT NULL,
        $columnDateTime TEXT NOT NULL
      )
    ''');
  }

  Future<void> deleteNoteById(int id) async {
    final db = await database;
    await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final maps = await db.query(table, orderBy: '$columnDateTime DESC');

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i][columnId] as int?,
        title: maps[i][columnTitle] as String,
        content: maps[i][columnContent] as String,
        color: maps[i][columnColor] as int,
        dateTime: maps[i][columnDateTime] as String,
      );
    });
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(table, note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      table,
      note.toMap(),
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
  }
}
