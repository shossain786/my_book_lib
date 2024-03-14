import 'package:flutter/material.dart';
import 'package:my_book_lib/main.dart';
import 'package:my_book_lib/model/book_provider.dart';
import 'package:my_book_lib/screens/library_screen.dart';
import 'package:my_book_lib/screens/pdf_viewer_screen.dart';
import 'package:my_book_lib/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Library App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Library Books',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                        ),
                        color: kColorScheme.onPrimaryContainer,
                        iconSize: 40,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LibraryScreen(),
                            ),
                          );
                        },
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          color: kColorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const LibraryBooksSection(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Favorite Books',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 400,
              child: FavoriteBooksSection(),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
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
    final libraryBooks = bookProvider.books.take(15).toList();

    return Container(
      // color: kColorScheme.secondary,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          // color: kColorScheme.primaryContainer,
          color: kColorScheme.onPrimaryContainer,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: libraryBooks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        pdfPath: libraryBooks[index].path,
                        book: libraryBooks[index],
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Card(
                      // color: Colors.white,
                      color: kColorScheme.onPrimaryContainer,
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Image.asset(
                              // 'assets/${libraryBooks[index].imagePath}',
                              'assets/book.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                    Text(
                      libraryBooks[index].name.length > 10
                          ? '${libraryBooks[index].name.substring(0, 10)}...'
                          : libraryBooks[index].name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      libraryBooks[index].author,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavoriteBooksSection extends StatelessWidget {
  const FavoriteBooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final favoriteBooks =
        bookProvider.books.where((book) => book.isFavorite).take(15).toList();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              favoriteBooks[index].name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(favoriteBooks[index].author),
            leading: Column(
              children: [
                Image.asset(
                  'assets/Fav_book.png',
                  width: 60,
                  height: 50,
                ),
              ],
            ),
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
          );
        },
      ),
    );
  }
}
