import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../main.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfPath;

  const PdfViewerPage({Key? key, required this.pdfPath}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.pdfPath,
            nightMode: nightMode,
            enableSwipe: false,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: false,
            // fitPolicy: FitPolicy.WIDTH,
          ),
        ],
      ),
    );
  }
}
