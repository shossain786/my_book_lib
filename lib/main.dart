import 'package:flutter/material.dart';
import 'package:my_book_lib/screens/favourite_screen.dart';
import 'package:my_book_lib/screens/library_screen.dart';
import 'package:my_book_lib/model/book_provider.dart';
import 'package:my_book_lib/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'screens/waqia_screen.dart';

bool nightMode = false;
var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.black);
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: kColorScheme.background,
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            shadowColor: kColorScheme.onPrimaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: kColorScheme.primaryContainer,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/myLibrary': (context) => const LibraryScreen(),
          '/myFavouriteBooks': (context) => const FavoritesScreen(),
          // '/waqias': (context) => const WaqiasScreen(),
          '/waqia_json': (context) => const WaqiasScreen(),
        },
      ),
    ),
  );
}
