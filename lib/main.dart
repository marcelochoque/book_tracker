import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/book_provider.dart';

void main() {
  runApp(
    // Usamos ChangeNotifierProvider para proporcionar el BookProvider a toda la aplicación, 
    //permitiendo que cualquier widget pueda acceder a los datos de los libros y actualizarse 
    //cuando estos cambien
    ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: const BookTrackerApp(),
    ),
  );
}

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Book Tracker!'),
        ),
      ),
    );
  }
}
