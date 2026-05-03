import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // defino el andamiaje principal de la pantalla
    // estructuro la barra superior y el cuerpo de la aplicacion
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Lectura'),
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) {
          // evaluo si la matriz de datos esta vacia
          if (provider.books.isEmpty) {
            return const Center(
              child: Text('El catálogo está vacío. Añada un nuevo registro.'),
            );
          }

          // renderizo una lista estructurada y reactiva
          return ListView.builder(
            itemCount: provider.books.length,
            itemBuilder: (context, index) {
              final book = provider.books[index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text('Autor: ${book.author}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // implemento logica de eliminacion directa
                    TextButton(
                      onPressed: () => provider.deleteBook(book.id!),
                      child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNuevoLibro(context),
        child: const Text('+', style: TextStyle(fontSize: 24)),
      ),
    );
  }

  void _mostrarDialogoNuevoLibro(BuildContext context) {
    // instancio los controladores para capturar la entrada del usuario
    final titleController = TextEditingController();
    final authorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Nuevo Libro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título de la obra'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Autor'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // valido entradas y ejecuto el metodo asincrono del proveedor
                // retiro el cuadro de dialogo de la pila de navegacion
                if (titleController.text.isNotEmpty && authorController.text.isNotEmpty) {
                  Provider.of<BookProvider>(context, listen: false)
                      .addBook(titleController.text, authorController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}