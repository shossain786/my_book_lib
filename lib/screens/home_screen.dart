import 'package:flutter/material.dart';
import 'package:my_book_lib/widgets/bottom_nav_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library App'),
      ),
      body: const SingleChildScrollView(
        child: Center(),
      ),
      bottomNavigationBar: const SafeArea(child: MyBottomNavBar()),
    );
  }
}
