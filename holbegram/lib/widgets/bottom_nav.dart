import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import '../screens/pages/feed.dart';
import '../screens/pages/search.dart';
import '../screens/pages/add_image.dart';
import '../screens/pages/favorite.dart';
import '../screens/pages/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemSelected(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [Feed(), Search(), AddImage(), Favorite(), Profile()],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: _onItemSelected,
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: const Color.fromARGB(218, 226, 37, 24),
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.search),
            title: const Text(
              'Search',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: const Color.fromARGB(218, 226, 37, 24),
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.add_box_outlined),
            title: const Text(
              'Add',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: const Color.fromARGB(218, 226, 37, 24),
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text(
              'Favorites',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: const Color.fromARGB(218, 226, 37, 24),
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: const Color.fromARGB(218, 226, 37, 24),
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
