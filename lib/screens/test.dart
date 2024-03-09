// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: BookListScreen(),
  ));
}

class BookListScreen extends StatefulWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<dynamic>> _fetchBooks;

  @override
  void initState() {
    super.initState();
    _fetchBooks = fetchBooks();
  }

  Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse(
        'https://mohammad-hossain-saddy.github.io/api_host/flutter.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['books'];
      return data;
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<dynamic> books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    child: Text(
                      book['title'][0],
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  onTap: () {},
                  selectedTileColor: Colors.orange,
                  title: Text(
                    book['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${book['author']}'),
                      Text('Genre: ${book['genre']}'),
                      Text('Year: ${book['year']}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
