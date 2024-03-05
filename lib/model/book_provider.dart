import 'package:flutter/material.dart';
import 'package:my_book_lib/model/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  Future<void> addBook(Book book) async {
    _books.add(book);
    await saveBooks();
    notifyListeners();
  }

  Future<void> deleteBook(int index) async {
    _books.removeAt(index);
    await saveBooks();
    notifyListeners();
  }

  void toggleFavorite(int index) {
    _books[index].isFavorite = !_books[index].isFavorite;
    saveBooks();
    notifyListeners();
  }

  Future<void> saveBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'books',
      _books
          .map(
            (book) =>
                "${book.name}|${book.author}|${book.path}|${book.isFavorite ? '1' : '0'}",
          )
          .toList(),
    );
  }

  Future<void> loadBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookStrings = prefs.getStringList('books');
    if (bookStrings != null) {
      _books = bookStrings.map((bookString) {
        List<String> parts = bookString.split('|');
        return Book(
          name: parts[0],
          author: parts[1],
          path: parts[2],
          isFavorite: parts[3] == '1',
        );
      }).toList();
      notifyListeners();
    }
  }
}
