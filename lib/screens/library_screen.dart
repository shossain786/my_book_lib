import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_book_lib/main.dart';
import 'package:my_book_lib/model/book.dart';
import 'package:my_book_lib/model/book_provider.dart';
import 'package:my_book_lib/screens/pdf_viewer_screen.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

final List<String> categories = [
  'Dars',
  'Sirat',
  'Hadis',
  'Fiqh',
  'Quran',
  'Others'
];

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late String _filePath = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  String _selectedCategory = 'Dars';
  late TabController _tabController;
  late BookProvider _bookProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _bookProvider = Provider.of<BookProvider>(context, listen: false);
    _bookProvider.loadBooks();
  }

  Widget _buildCategoryListView(String category) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        bookProvider.loadBooks();
        final categoryBooks = bookProvider.books
            .where((book) => book.category == category)
            .toList();
        return ListView.builder(
          itemCount: categoryBooks.length,
          itemBuilder: (context, index) {
            final book = categoryBooks[index];
            return Card(
              shadowColor: Colors.yellowAccent,
              color: kColorScheme.onPrimaryContainer,
              elevation: 10,
              child: InkWell(
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
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.yellowAccent),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/book.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      const Text(
                        'Name: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        book.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      const Text(
                        'Author: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        book.author,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  trailing: buildPopupMenuButton(book, bookProvider),
                  textColor: kColorScheme.onSecondary,
                  iconColor: kColorScheme.onSecondary,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Library',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: categories.map((category) => Tab(text: category)).toList(),
          labelColor: kColorScheme.onSecondary,
          unselectedLabelColor: Colors.white54,
          automaticIndicatorColorAdjustment: true,
          dividerColor: Colors.yellowAccent,
          dividerHeight: 3.0,
          isScrollable: true,
          indicatorWeight: 5,
          indicatorColor: Colors.amber,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories
            .map((category) => _buildCategoryListView(category))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _addBooks();
        },
        elevation: 5,
        backgroundColor: kColorScheme.secondaryContainer,
        foregroundColor: kColorScheme.onPrimaryContainer,
        label: const Text(
          'Add Book',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _addBooks() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(235, 233, 198, 198),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 550,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  maxLength: 40,
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Book Name'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _authorController,
                        decoration:
                            const InputDecoration(labelText: 'Author Name'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color.fromARGB(235, 233, 198, 198),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        value: _selectedCategory,
                        items: [
                          'Dars',
                          'Sirat',
                          'Hadis',
                          'Fiqh',
                          'Quran',
                          'Others',
                        ].map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(FontAwesomeIcons.filePdf),
                      onPressed: () {
                        _openFilePicker(context);
                      },
                      label: const Text('Select PDF File'),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {
                        _addBook(context);
                      },
                      child: const Text('Add Book'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPopupMenuButton(Book book, BookProvider bookProvider) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'edit') {
          // _editBook(context, bookProvider, book);
        } else if (value == 'delete') {
          _deleteBook(context, bookProvider, book);
        } else if (value == 'addToFavorites') {
          bookProvider.toggleFavorite(book.id);
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
            leading: book.isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            title: Text(
                book.isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
          ),
        ),
      ],
    );
  }

  Future<void> _openFilePicker(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
  }

  void _addBook(BuildContext context) {
    String name = _nameController.text;
    String author = _authorController.text;
    if (name.isNotEmpty && author.isNotEmpty && _filePath.isNotEmpty) {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.addBook(Book(
          name: name,
          author: author,
          path: _filePath,
          category: _selectedCategory,
          id: _generateRandomID()));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Make sure to select pdf file, name and auther name!'),
        ),
      );
    }
  }

  static String _generateRandomID() {
    Random random = Random();
    int id = random.nextInt(900000) + 100000;
    return id.toString();
  }

  void _deleteBook(BuildContext context, BookProvider bookProvider, Book book) {
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
              bookProvider.deleteBook(book.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
