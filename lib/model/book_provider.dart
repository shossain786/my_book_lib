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
    List<String> bookStrings = _books.map((book) {
      return "${book.id}|${book.name}|${book.author}|${book.path}|${book.isFavorite ? '1' : '0'}|${book.lastReadPage}|${book.category}|${book.timesOpened}";
    }).toList();
    await prefs.setStringList('books', bookStrings);
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
          lastReadPage: int.parse(parts[5]),
          category: parts[6],
        );
      }).toList();
      notifyListeners();
    }
  }

  Future<void> updateFavoriteBookOrder(List<Book> newOrder) async {
    List<Book> updatedBooks = [];
    for (Book book in _books) {
      if (book.isFavorite) {
        if (newOrder.isNotEmpty) {
          updatedBooks.add(newOrder.removeAt(0));
        }
      } else {
        updatedBooks.add(book);
      }
    }
    _books = updatedBooks;
    await saveBooks();
    notifyListeners();
  }

  Future<void> updateBookOrder(List<Book> newOrder) async {
    _books = newOrder;
    await saveBooks();
    notifyListeners();
  }
}
