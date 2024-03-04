// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_book_lib/model/book.dart';
import 'package:my_book_lib/model/book_provider.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: const AddBookForm(),
    );
  }
}

class AddBookForm extends StatefulWidget {
  const AddBookForm({super.key});

  @override
  _AddBookFormState createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  String _filePath = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              _openFilePicker(context);
            },
            child: const Text('Select PDF File'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Book Name'),
          ),
          TextField(
            controller: _authorController,
            decoration: const InputDecoration(labelText: 'Author Name'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _addBook(context);
            },
            child: const Text('Add Book'),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilePicker(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
  }

  void _addBook(BuildContext context) {
    String name = _nameController.text;
    String author = _authorController.text;
    if (name.isNotEmpty && author.isNotEmpty && _filePath.isNotEmpty) {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.addBook(Book(name: name, author: author, path: _filePath));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Make sure to select pdf file, name and auther name!'),
        ),
      );
    }
  }
}
