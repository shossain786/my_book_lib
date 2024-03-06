import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;

  const PdfViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PDFViewController pdfController;
  int pageNumber = 1;
  bool nightMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: () {
              setState(() {
                nightMode = !nightMode;
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
      body: Stack(
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
              color: nightMode ? Colors.black54 : Colors.white54,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
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
                    onPressed: () {
                      pdfController.getPageCount().then((count) {
                        if (pageNumber < count!) {
                          pdfController.setPage(++pageNumber - 1);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
