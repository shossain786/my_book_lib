import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class QuranSurah extends StatelessWidget {
  const QuranSurah({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quran.getSurahName(67)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: quran.getVerseCount(67),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  quran.getVerse(67, index + 1, verseEndSymbol: true),
                  textAlign: TextAlign.right,
                  textScaler: const TextScaler.linear(1.8),
                  selectionColor: Colors.amber,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 114, 100, 57),
                    shadows: [
                      Shadow(color: Colors.yellow),
                      Shadow(color: Colors.red),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
