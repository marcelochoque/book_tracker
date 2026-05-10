import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/book_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Lectura'),
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) {
          if (provider.books.isEmpty) {
            return const Center(
              child: Text('El catálogo está vacío. Añada un nuevo registro.'),
            );
          }

          return ListView.builder(
            itemCount: provider.books.length,
            itemBuilder: (context, index) {
              final book = provider.books[index];
              return ListTile(
                // evalue si existe ruta para renderizar la imagen o un texto por defecto
                leading: book.imagePath != null
                    ? Image.file(File(book.imagePath!), width: 50, height: 50, fit: BoxFit.cover)
                    : const Text('[Sin Foto]'),
                title: Text(book.title),
                subtitle: Text('Autor: ${book.author}'),
                trailing: TextButton(
                  onPressed: () => provider.deleteBook(book.id!),
                  child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
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
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    // declaro la variable para mantener la ruta de la sesion actual
    String? selectedImagePath;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) {
        // utilizo statefulbuilder para gestionar el estado local del dialogo
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Registrar Nuevo Libro'),
              content: SingleChildScrollView(
                child: Column(
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
                    const SizedBox(height: 16),
                    // renderizo la vista previa si ya capture una foto
                    selectedImagePath != null
                        ? Image.file(File(selectedImagePath!), height: 150)
                        : const Text('Sin imagen seleccionada'),
                    TextButton(
                      onPressed: () async {
                        // solicito acceso al hardware fotografico
                        final XFile? image = await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          // actualizo exclusivamente el arbol del dialogo
                          setState(() {
                            selectedImagePath = image.path;
                          });
                        }
                      },
                      child: const Text('Capturar Foto'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty && authorController.text.isNotEmpty) {
                      // envio la ruta obtenida al gestor de estado superior
                      Provider.of<BookProvider>(context, listen: false)
                          .addBook(titleController.text, authorController.text, selectedImagePath);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}