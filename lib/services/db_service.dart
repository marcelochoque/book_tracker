import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DbService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'books_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL, 
        author TEXT NOT NULL, 
        status INTEGER NOT NULL
        )
      ''',
    );
  }

  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert(
      'books', 
      book.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<int> updateBook(int id, int newStatus) async {
    final db = await database;
    return await db.update(
      'books', 
      {'status': newStatus}, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books', 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

}