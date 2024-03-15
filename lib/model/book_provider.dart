import 'package:flutter/material.dart';
import 'package:my_book_lib/model/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  List<Book> get books => _books;

  BookProvider() {
    loadBooks();
  }

  Future<void> addBook(Book book) async {
    _books.add(book);
    await saveBooks();
    notifyListeners();
  }

  Future<void> deleteBook(String id) async {
    _books.removeWhere((book) => book.id == id);
    await saveBooks();
    notifyListeners();
  }

  void toggleFavorite(String id) {
    int index = _books.indexWhere((book) => book.id == id);
    if (index != -1) {
      _books[index].isFavorite = !_books[index].isFavorite;
      saveBooks();
      notifyListeners();
    }
  }

  Future<void> saveBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'books',
      _books
          .map(
            (book) =>
                "${book.id}|${book.name}|${book.author}|${book.path}|${book.isFavorite ? '1' : '0'}",
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
          id: parts[0],
          name: parts[1],
          author: parts[2],
          path: parts[3],
          isFavorite: parts[4] == '1',
        );
      }).toList();
      notifyListeners();
    }
  }
}
