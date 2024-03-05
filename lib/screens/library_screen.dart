import 'package:flutter/material.dart';
import 'package:my_book_lib/model/book.dart';
import 'package:my_book_lib/widgets/add_books.dart';
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
              return ListTile(
                title: Text(bookProvider.books[index].name),
                subtitle: Text(bookProvider.books[index].author),
                trailing: buildPopupMenuButton(
                    bookProvider.books[index], bookProvider, index),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                          pdfPath: bookProvider.books[index].path),
                    ),
                  );
                },
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
        context: context, builder: (context) => const AddBookScreen());
  }

  Widget buildPopupMenuButton(Book book, BookProvider bookProvider, int index) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'edit') {
          // _editBook(context, bookProvider, book);
        } else if (value == 'delete') {
          _deleteBook(context, bookProvider, book, index);
        } else if (value == 'addToFavorites') {
          _addToFavorites(context, bookProvider, book, index);
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
            leading: bookProvider.books[index].isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            title: Text(bookProvider.books[index].isFavorite
                ? 'Remove from Favorites'
                : 'Add to Favorites'),
          ),
        ),
      ],
    );
  }

  void _deleteBook(
      BuildContext context, BookProvider bookProvider, Book book, int index) {
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
              bookProvider.deleteBook(index);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addToFavorites(
      BuildContext context, BookProvider bookProvider, Book book, int index) {
    bookProvider.toggleFavorite(index);
  }
}
