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
  late final PageController _pageController;

  static const Color _activeColor = Color.fromARGB(218, 226, 37, 24);

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

  /// Updates the selected index when swiping pages.
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Navigates to the selected page from the bottom bar.
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
          _navItem(icon: Icons.home_outlined, label: 'Home'),
          _navItem(icon: Icons.search, label: 'Search'),
          _navItem(icon: Icons.add_box_outlined, label: 'Add'),
          _navItem(icon: Icons.favorite_border, label: 'Favorites'),
          _navItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }

  /// Builds a BottomNavyBar item with consistent styling.
  static BottomNavyBarItem _navItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavyBarItem(
      icon: Icon(icon),
      title: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25, fontFamily: 'Billabong'),
      ),
      activeColor: _activeColor,
      inactiveColor: Colors.black,
    );
  }
}
