import 'package:flutter/material.dart';
import 'package:my_book_lib/main.dart';
import 'package:my_book_lib/model/book.dart';
import 'package:my_book_lib/model/book_provider.dart';
import 'package:my_book_lib/screens/pdf_viewer_screen.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    List<Book> allBooks = bookProvider.books;
    List<Book> favoriteBooks =
        allBooks.where((book) => book.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Books',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          final Book item = favoriteBooks.removeAt(oldIndex);
          favoriteBooks.insert(
              newIndex < oldIndex ? newIndex : newIndex - 1, item);
          bookProvider.updateFavoriteBookOrder(favoriteBooks);
        },
        children: <Widget>[
          for (final book in favoriteBooks)
            _buildListTile(context, bookProvider, book),
        ],
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, BookProvider bookProvider, Book book) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        bookProvider.toggleFavorite(book.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${book.name} removed from favorites'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              bookProvider.toggleFavorite(book.id);
            },
          ),
        ));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Card(
            elevation: 5.0,
            color: kColorScheme.onPrimaryContainer,
            shadowColor: Colors.yellowAccent,
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
                    book.name.length > 25
                        ? '${book.name.substring(0, 22)}...'
                        : book.name,
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
                    book.author.length > 30
                        ? '${book.author.substring(0, 27)}...'
                        : book.author,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kColorScheme.onPrimary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              leading: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellowAccent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/Fav_book.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_circle_right,
                color: Colors.yellowAccent,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(
                      pdfPath: book.path,
                      book: book,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
