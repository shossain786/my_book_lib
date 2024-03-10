// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_book_lib/model/book.dart';

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
  int pageNumber = 1;
  bool nightMode = false;
  late TextEditingController pageController;
  late Color hintColor;
  late Color inputColor;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    pageController = TextEditingController();
    hintColor = Colors.black54;
    inputColor = Colors.black;
    _startTime = DateTime.now();
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.lightbulb,
              color: nightMode
                  ? const Color.fromARGB(255, 64, 244, 70)
                  : Colors.black,
            ),
            onPressed: () {
              setState(() {
                nightMode = !nightMode;
                _updateTextFieldColors();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: () {
              pdfController.setPage(0);
              setState(() {
                pageNumber = 1;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: () {
              pdfController.getPageCount().then((count) {
                pdfController.setPage(count! - 1);
                setState(() {
                  pageNumber = count;
                });
              });
            },
          ),
        ],
      ),
      body: Container(
        color: nightMode ? Colors.black : Colors.white,
        child: Stack(
          children: [
            PDFView(
              filePath: widget.pdfPath,
              autoSpacing: true,
              enableSwipe: true,
              fitEachPage: true,
              fitPolicy: FitPolicy.WIDTH,
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
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: pageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Page',
                          hintStyle: TextStyle(color: hintColor),
                        ),
                        style: TextStyle(color: inputColor),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        iconColor: MaterialStateColor.resolveWith((states) =>
                            nightMode ? Colors.white : Colors.black),
                      ),
                      onPressed: () {
                        int? page = int.tryParse(pageController.text);
                        if (page != null && page > 0) {
                          pdfController.setPage(page - 1);
                          setState(() {
                            pageNumber = page;
                          });
                        } else {
                          // Handle invalid input
                        }
                      },
                      child: const FaIcon(FontAwesomeIcons.anglesRight),
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

  void _updateTextFieldColors() {
    setState(() {
      hintColor = nightMode ? Colors.white70 : Colors.black54;
      inputColor = nightMode ? Colors.white : Colors.black;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void recordReadingTime() {
    DateTime endTime = DateTime.now();
    int durationInSeconds = endTime.difference(_startTime).inSeconds;
    widget.book.totalReadingTime += durationInSeconds;
    widget.book.timesOpened++;
  }
}
