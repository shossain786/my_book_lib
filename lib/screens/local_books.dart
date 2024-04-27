// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_book_lib/screens/local_pdf_view.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
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

  Future<void> _savePdfFilesOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pdf_files', _pdfFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: _pdfFiles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ReorderableGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              children: _pdfFiles
                  .map(
                    (pdfPath) => GestureDetector(
                      key: ValueKey(pdfPath),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PdfViewerPage(pdfPath: pdfPath),
                          ),
                        );
                      },
                      child: Card(
                        key: ValueKey(pdfPath),
                        child: Center(
                          child: Text(
                            pdfPath.substring(pdfPath.lastIndexOf('/') + 1),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onReorder: (int oldIndex, int newIndex) {
                setState(
                  () {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final String item = _pdfFiles.removeAt(oldIndex);
                    _pdfFiles.insert(newIndex, item);
                    _savePdfFilesOrder();
                  },
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
