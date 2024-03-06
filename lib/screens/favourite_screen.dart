import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_book_lib/model/book_provider.dart';
import 'package:my_book_lib/screens/pdf_viewer_screen.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final favoriteBooks =
        bookProvider.books.where((book) => book.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Books'),
      ),
      body: ListView.builder(
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
            child: Card(
              elevation: 5.0,
              shadowColor: Colors.greenAccent,
              child: ListTile(
                title: Text(favoriteBooks[index].name),
                subtitle: Text(favoriteBooks[index].author),
                leading: const CircleAvatar(
                  child: FaIcon(FontAwesomeIcons.bookQuran),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
