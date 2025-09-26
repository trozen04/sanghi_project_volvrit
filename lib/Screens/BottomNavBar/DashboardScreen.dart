import 'package:flutter/material.dart';
import 'package:gold_project/Screens/BottomNavBar/CustomNavbar.dart';
import 'package:gold_project/Screens/HomeScreens/CartPage/CartPage.dart';
import 'package:gold_project/Screens/HomeScreens/Catalog/CategoryScreen.dart';
import 'package:gold_project/Screens/HomeScreens/Home/HomeScreen.dart';
import 'package:gold_project/Screens/Profile/ProfilePage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screens with access to current setState
    final List<Widget> screens = [
      HomeScreen(),
      CategoryScreen(),
      CartPage(
        onBackToHome: () {
          setState(() {
            selectedIndex = 0; // navigate to HomeScreen
          });
        },
      ),
      ProfilePage(),
    ];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: screens[selectedIndex], // show the selected screen
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
