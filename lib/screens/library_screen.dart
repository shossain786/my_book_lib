import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_book_lib/main.dart';
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
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: Icon(
              _isGridView ? Icons.list_rounded : Icons.grid_view_rounded,
            ),
          ),
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
      body: _isGridView ? _buildGridView() : _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addBooks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGridView() {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        bookProvider.loadBooks();
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
          ),
          itemCount: bookProvider.books.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: kColorScheme.onPrimaryContainer,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  elevation: 5.0,
                  color: kColorScheme.onPrimaryContainer,
                  child: InkWell(
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: kColorScheme.onPrimary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4, left: 4, right: 4),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.asset(
                                'assets/book.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Column(
                              children: [
                                Text(
                                  bookProvider.books[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: kColorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  bookProvider.books[index].author,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: kColorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListView() {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        bookProvider.loadBooks();
        return ListView.builder(
          itemCount: bookProvider.books.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(left: 4, right: 4, top: 4),
              width: 3,
              decoration: BoxDecoration(
                color: kColorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(10),
                border: const Border(
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Card(
                  elevation: 5.0,
                  child: ListTile(
                    tileColor: kColorScheme.onPrimaryContainer,
                    title: Row(
                      children: [
                        Text(
                          "Book: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kColorScheme.onPrimary,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          bookProvider.books[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kColorScheme.onPrimary,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          'Author: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kColorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          bookProvider.books[index].author,
                          style: TextStyle(
                            fontSize: 14,
                            color: kColorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    leading: Image.asset(
                      'assets/book.png',
                    ),
                    trailing: buildPopupMenuButton(
                      bookProvider.books[index],
                      bookProvider,
                    ),
                    iconColor: kColorScheme.onPrimary,
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
              ),
            );
          },
        );
      },
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
