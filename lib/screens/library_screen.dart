import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_book_lib/model/book.dart';
import 'package:my_book_lib/model/book_provider.dart';
import 'package:my_book_lib/screens/favourite_screen.dart';
import 'package:my_book_lib/screens/pdf_viewer_screen.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late String _filePath = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          bookProvider.loadBooks();
          return ListView.builder(
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Card(
                  elevation: 5.0,
                  shadowColor: Colors.greenAccent,
                  child: ListTile(
                    title: Text(
                      bookProvider.books[index].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(bookProvider.books[index].author),
                    leading: Image.asset('assets/book.png'),
                    trailing: buildPopupMenuButton(
                        bookProvider.books[index], bookProvider),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewerScreen(
                            pdfPath: bookProvider.books[index].path,
                            book: bookProvider.books[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addBooks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addBooks() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(235, 233, 198, 198),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 550,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Book Name'),
                ),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author Name'),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(FontAwesomeIcons.filePdf),
                      onPressed: () {
                        _openFilePicker(context);
                      },
                      label: const Text('Select PDF File'),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {
                        _addBook(context);
                      },
                      child: const Text('Add Book'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPopupMenuButton(Book book, BookProvider bookProvider) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'edit') {
          // _editBook(context, bookProvider, book);
        } else if (value == 'delete') {
          _deleteBook(context, bookProvider, book);
        } else if (value == 'addToFavorites') {
          _addToFavorites(context, bookProvider, book);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        // const PopupMenuItem<String>(
        //   value: 'edit',
        //   child: ListTile(
        //     leading: Icon(Icons.edit),
        //     title: Text('Edit'),
        //   ),
        // ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'addToFavorites',
          child: ListTile(
            leading: book.isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            title: Text(
                book.isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
          ),
        ),
      ],
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
      bookProvider.addBook(Book(
          name: name,
          author: author,
          path: _filePath,
          id: _generateRandomID()));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Make sure to select pdf file, name and auther name!'),
        ),
      );
    }
  }

  static String _generateRandomID() {
    Random random = Random();
    int id = random.nextInt(900000) + 100000;
    debugPrint(
        'ID generated: ------------------Add Book------------------- ${id.toString()}');
    return id.toString();
  }

  void _deleteBook(BuildContext context, BookProvider bookProvider, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              bookProvider.deleteBook(book.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addToFavorites(
      BuildContext context, BookProvider bookProvider, Book book) {
    bookProvider.toggleFavorite(book.id);
  }
}
