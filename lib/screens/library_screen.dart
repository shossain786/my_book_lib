import 'package:flutter/material.dart';
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
                trailing: IconButton(
                  icon: bookProvider.books[index].isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  onPressed: () {
                    bookProvider.toggleFavorite(index);
                  },
                ),
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
}
