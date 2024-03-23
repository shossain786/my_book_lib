// ignore_for_file: library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:my_book_lib/main.dart';
import 'package:my_book_lib/model/book.dart';
import 'package:my_book_lib/model/book_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final Book book;

  const PdfViewerScreen({Key? key, required this.pdfPath, required this.book})
      : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PDFViewController pdfController;
  late int pageNumber;
  late TextEditingController pageController;
  late Color hintColor;
  late Color inputColor;

  @override
  void initState() {
    super.initState();
    pageController = TextEditingController();
    hintColor = Colors.black54;
    inputColor = Colors.black;
    pageNumber = widget.book.lastReadPage;
    widget.book.timesOpened++;
    BookProvider().saveBooks();
    debugPrint(widget.book.timesOpened.toString());
  }

  void _updateLastReadPage(int page) async {
    widget.book.lastReadPage = page;
    widget.book.timesOpened++;
    await BookProvider().saveBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nightMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          widget.book.name,
        ),
        foregroundColor: nightMode ? Colors.white : Colors.black,
        backgroundColor: nightMode ? Colors.black : Colors.white,
      ),
      body: Container(
        color: nightMode ? Colors.black : Colors.white,
        child: Stack(
          children: [
            PDFView(
              filePath: widget.pdfPath,
              // autoSpacing: true,
              enableSwipe: true,
              // fitEachPage: true,
              // fitPolicy: FitPolicy.WIDTH,
              nightMode: nightMode,
              onRender: (pages) {
                setState(() {
                  pageNumber = pages!;
                });
              },
              onViewCreated: (PDFViewController controller) {
                setState(() {
                  pdfController = controller;
                });
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  pageNumber = page! + 1;
                });
                _updateLastReadPage(pageNumber);
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: nightMode ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: nightMode ? Colors.white : Colors.black,
                      onPressed: () {
                        if (pageNumber > 1) {
                          pdfController.setPage(--pageNumber - 1);
                        }
                      },
                    ),
                    Text(
                      'Page $pageNumber',
                      style: TextStyle(
                        color: nightMode ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      color: nightMode ? Colors.white : Colors.black,
                      onPressed: () {
                        pdfController.getPageCount().then((count) {
                          if (pageNumber < count!) {
                            pdfController.setPage(++pageNumber - 1);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.first_page),
                      color: MaterialStateColor.resolveWith(
                          (states) => nightMode ? Colors.white : Colors.black),
                      onPressed: () {
                        pdfController.setPage(0);
                        setState(() {
                          pageNumber = 1;
                        });
                      },
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: pageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Page',
                          hintStyle: TextStyle(
                              color: nightMode ? Colors.white : Colors.black),
                        ),
                        onSubmitted: (value) {
                          int? page = int.tryParse(value);
                          if (page != null && page > 0) {
                            pdfController.setPage(page - 1);
                            setState(() {
                              pageNumber = page;
                            });
                          }
                        },
                        style: TextStyle(
                            color: nightMode ? Colors.white : Colors.black),
                      ),
                    ),
                    IconButton(
                      color: MaterialStateColor.resolveWith(
                          (states) => nightMode ? Colors.white : Colors.black),
                      icon: const Icon(Icons.last_page),
                      onPressed: () {
                        pdfController.getPageCount().then(
                          (count) {
                            pdfController.setPage(count! - 1);
                            setState(
                              () {
                                pageNumber = count;
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
