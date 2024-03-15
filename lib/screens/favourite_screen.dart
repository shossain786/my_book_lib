import 'package:flutter/material.dart';
import 'package:my_book_lib/main.dart';
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
                color: kColorScheme.onPrimaryContainer,
                child: ListTile(
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
                        favoriteBooks[index].name,
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
                        favoriteBooks[index].author,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kColorScheme.onPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  leading: Image.asset('assets/Fav_book.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(
                          pdfPath: favoriteBooks[index].path,
                          book: favoriteBooks[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
