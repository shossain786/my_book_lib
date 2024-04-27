// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadPdfFiles();
  }

  Future<void> _loadPdfFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFiles = prefs.getStringList('pdf_files');
    if (savedFiles != null) {
      setState(() {
        _pdfFiles = savedFiles;
      });
    }
  }

  Future<void> _fetchAndAddNewPdfFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      List<String> newFiles = result.paths.map((path) => path!).toList();
      for (var newFile in newFiles) {
        if (!_pdfFiles.contains(newFile)) {
          _pdfFiles.add(newFile);
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('pdf_files', _pdfFiles);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: _pdfFiles == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
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
                      child: Text(
                        _pdfFiles[index]
                            .substring(_pdfFiles[index].lastIndexOf('/') + 1),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _fetchAndAddNewPdfFiles,
        label: const Text('Load All PDF Files'),
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
