// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class MyOnlineBooks extends StatefulWidget {
  const MyOnlineBooks({Key? key}) : super(key: key);

  @override
  _MyOnlineBooksState createState() => _MyOnlineBooksState();
}

class _MyOnlineBooksState extends State<MyOnlineBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API DATA'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Juz Number: \n${quran.getJuzNumber(67, 1)}"),
              Text("\nJuz URL: \n${quran.getJuzURL(15)}"),
              Text(
                  "\nSurah and Verses in Juz 15: \n${quran.getSurahAndVersesFromJuz(15)}"),
              Text("\nSurah Name: \n${quran.getSurahName(67)}"),
              Text(
                  "\nSurah Name (English): \n${quran.getSurahNameEnglish(18)}"),
              Text("\nSurah URL: \n${quran.getSurahURL(67)}"),
              Text("\nTotal Verses: \n${quran.getVerseCount(67)}"),
              Text(
                  "\nPlace of Revelation: \n${quran.getPlaceOfRevelation(67)}"),
              const Text("\nBasmala: \n ${quran.basmala}"),
              Text("\nVerse 1: \n${quran.getVerse(67, 1)}")
            ],
          ),
        ),
      ),
    );
  }
}
