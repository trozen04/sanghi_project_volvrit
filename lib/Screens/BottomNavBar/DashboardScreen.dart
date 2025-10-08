import 'package:flutter/material.dart';
import 'package:gold_project/Screens/BottomNavBar/CustomNavbar.dart';
import 'package:gold_project/Screens/HomeScreens/CartPage/CartPage.dart';
import 'package:gold_project/Screens/HomeScreens/Catalog/CategoryScreen.dart';
import 'package:gold_project/Screens/HomeScreens/Home/HomeScreen.dart';
import 'package:gold_project/Screens/Profile/ProfilePage.dart';
import 'package:gold_project/Widgets/AppBar/custom_appbar_home.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  String searchQuery = '';

  void _onNavItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(searchQuery: searchQuery),
      CategoryScreen(searchQuery: searchQuery),
      CartPage(onBackToHome: () => setState(() => selectedIndex = 0)),
      ProfilePage(),
    ];

    // Only show app bar for first 2 screens
    PreferredSizeWidget? appBar;
    if (selectedIndex == 0 || selectedIndex == 1) {
      appBar = CustomAppBarHome(
        onSearchSubmitted: onSearch,
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar,
        body: screens[selectedIndex],
        bottomNavigationBar: CustomNavBar(
          height: 90,
          imageSize: 24,
          fontSize: 12,
          selectedIndex: selectedIndex,
          onItemSelected: _onNavItemTapped,
        ),
      ),
    );
  }
}

