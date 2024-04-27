// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class LocalPdfBooks extends StatefulWidget {
  const LocalPdfBooks({super.key});

  @override
  _LocalPdfBooksState createState() => _LocalPdfBooksState();
}

class _LocalPdfBooksState extends State<LocalPdfBooks> {
  late List<String> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _fetchPdfFiles();
  }

  Future<void> _fetchPdfFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      List<String> filePaths = result.paths.map((path) => path!).toList();
      setState(() {
        _pdfFiles = filePaths;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: _pdfFiles == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PdfViewerPage(pdfPath: _pdfFiles[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: Center(
                      child: Text(_pdfFiles[index]
                          .substring(_pdfFiles[index].lastIndexOf('/') + 1)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfPath;

  const PdfViewerPage({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        pageSnap: false,
        fitPolicy: FitPolicy.WIDTH,
      ),
    );
  }
}
