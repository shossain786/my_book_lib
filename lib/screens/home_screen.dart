import 'package:flutter/material.dart';
import 'package:my_book_lib/model/book_provider.dart';
import 'package:my_book_lib/screens/pdf_viewer_screen.dart';
import 'package:my_book_lib/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library App'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Library Books',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: LibraryBooksSection(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Favorite Books',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FavoriteBooksSection(),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(child: MyBottomNavBar()),
    );
  }
}

class LibraryBooksSection extends StatelessWidget {
  const LibraryBooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final libraryBooks = bookProvider.books.take(5).toList();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: libraryBooks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewerScreen(
                    pdfPath: libraryBooks[index].path,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.book),
                ),
                const SizedBox(height: 8),
                Text(
                  libraryBooks[index].name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavoriteBooksSection extends StatelessWidget {
  const FavoriteBooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final favoriteBooks =
        bookProvider.books.where((book) => book.isFavorite).take(5).toList();

    return ListView.builder(
      itemCount: favoriteBooks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(favoriteBooks[index].name),
          subtitle: Text(favoriteBooks[index].author),
          leading: const CircleAvatar(
            child: Icon(Icons.book),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerScreen(
                  pdfPath: favoriteBooks[index].path,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
