import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      selectedFontSize: 20,
      unselectedItemColor: Colors.orange,
      selectedItemColor: Colors.blue,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.book),
          label: 'My Library',
          backgroundColor: Color.fromRGBO(53, 0, 0, 0.974),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favourite Books',
          backgroundColor: Color.fromRGBO(53, 0, 0, 0.974),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_online),
          label: 'Dilchasp Waqiat',
          backgroundColor: Color.fromRGBO(53, 0, 0, 0.974),
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
