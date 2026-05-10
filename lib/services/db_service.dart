import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DbService {
  static Database? _db;
  // Mantenemos una unica instancia de la base de datos para toda la aplicación
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    // Determinamos la ruta de la base de datos y la abrimos (o la creamos si no existe)
    String path = join(await getDatabasesPath(), 'books_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Creamos la tabla de libros con los campos necesarios
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL, 
        author TEXT NOT NULL, 
        status INTEGER NOT NULL,
        imagePath TEXT
        )
      ''',
    );
  }

  // Insertamos un nuevo libro en la base de datos
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert(
      'books', 
      book.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // Obtenemos todos los libros almacenados en la base de datos
  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  //Actualizamos el estado de un libro (To Read, Reading, Read)
  Future<int> updateBook(int id, int newStatus) async {
    final db = await database;
    return await db.update(
      'books', 
      {'status': newStatus}, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  // Eliminamos un libro de la base de datos por su ID
  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books', 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

}