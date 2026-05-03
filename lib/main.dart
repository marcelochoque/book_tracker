import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/book_provider.dart';
import 'screens/home_screen.dart';

void main() {
  // garantizo que los enlaces nativos esten preparados
  WidgetsFlutterBinding.ensureInitialized();

  // verifico si el sistema operativo subyacente es de escritorio
  // inicializo ffi y sobreescribo la fabrica de base de datos
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // inicio el ciclo de vida del marco de trabajo
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookProvider()..loadBooks(),
      child: const BookTrackerApp(),
    ),
  );
}

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // configuro el motor de diseño global de la solucion
    return MaterialApp(
      title: 'Book Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}