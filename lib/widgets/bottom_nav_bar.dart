import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_book_lib/main.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,
      unselectedFontSize: 15,
      selectedFontSize: 16,
      unselectedItemColor: kColorScheme.primaryContainer,
      selectedItemColor: kColorScheme.onPrimary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(FontAwesomeIcons.book),
          label: 'My Library',
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: 'Favorite Books',
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.star),
          label: 'Dilchasp Waqiat',
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/myLibrary');
        break;
      case 1:
        Navigator.pushNamed(context, '/myFavouriteBooks');
        break;
      case 2:
        Navigator.pushNamed(context, '/waqia_json');
        break;
    }
  }
}
