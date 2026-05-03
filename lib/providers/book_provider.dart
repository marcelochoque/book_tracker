import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/book.dart';


class BookProvider with ChangeNotifier {

  // mantenemos una lista local de libros para evitar consultas constantes a la base de datos y mejorar el rendimiento
  List<Book> _books = [];
  // instanciamos el servicio de base de datos para interactuar con la base de datos SQLite
  final DbService _dbService = DbService();

  // Exponemos la lista de libros a través de un getter para que otras partes de la aplicación puedan acceder a ella
  List<Book> get books => _books;

  // Cargamos los libros desde la base de datos al iniciar la aplicación o cuando se necesite actualizar la lista
  Future<void> loadBooks() async {
    _books = await _dbService.getBooks();
    // Notificamos a los listeners que la lista de libros ha cambiado para que puedan actualizar la interfaz de usuario
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    // Insertamos el nuevo libro en la base de datos y luego recargamos la lista de libros para reflejar el cambio
    await _dbService.insertBook(book);
    await loadBooks();
  }

  Future<void> updateBookStatus(int id, int newStatus) async {
    // Actualizamos el estado del libro en la base de datos y luego recargamos la lista de libros para reflejar el cambio
    await _dbService.updateBook(id, newStatus);
    await loadBooks();
  }

  Future<void> deleteBook(int id) async {
    // Eliminamos el libro de la base de datos y luego recargamos la lista de libros para reflejar el cambio
    await _dbService.deleteBook(id);
    await loadBooks();
  }
}