import 'package:flutter/material.dart';
import 'package:gold_project/Screens/Auth/Login/LoginScreen.dart';
import 'package:gold_project/Screens/Auth/Register/RegisterScreen.dart';
import 'package:gold_project/Screens/BottomNavBar/DashboardScreen.dart';
import 'package:gold_project/Screens/Detailspage/DetailsPage.dart';
import 'package:gold_project/Screens/HomeScreens/CartPage/CartPage.dart';
import 'package:gold_project/Screens/HomeScreens/Catalog/CategoryScreen.dart';
import 'package:gold_project/Screens/HomeScreens/Home/HomeScreen.dart';
import 'package:gold_project/Screens/MyOrders/MyOrderDetailsPage.dart';
import 'package:gold_project/Screens/MyOrders/MyOrdersPage.dart';
import 'package:gold_project/Screens/Notification/NotificationPage.dart';
import 'package:gold_project/Screens/Profile/EditProfilePage.dart';
import 'package:gold_project/Screens/Profile/PersonalInfoPage.dart';

class AppRoutes {
  // ---------- Route names ----------
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String category = '/categoryScreen';
  static const String details = '/details';
  static const String cartPage = '/cartPage';
  static const String personalInfoPage = '/personalInfoPage';
  static const String editProfilePage = '/EditProfilePage';
  static const String orderPage = '/orderPage';
  static const String myOrderDetailsPage = '/myOrderDetailsPage';
  static const String notificationPage = '/notificationPage';

  // ---------- Central route generator ----------
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildPageRoute(const LoginScreen(), settings);
      case register:
        return _buildPageRoute(const RegisterScreen(), settings);
      case home:
        return _buildPageRoute(const HomeScreen(), settings);
      case dashboard:
        return _buildPageRoute(const DashboardScreen(), settings);
      case category:
        return _buildPageRoute(const CategoryScreen(), settings);
      case details:
        return _buildPageRoute(DetailsPage(), settings);
      case cartPage:
        return _buildPageRoute(CartPage(), settings);
      case personalInfoPage:
        return _buildPageRoute(PersonalInfoPage(), settings);
      case editProfilePage:
        return _buildPageRoute(EditProfilePage(), settings);
      case orderPage:
        return _buildPageRoute(MyOrdersPage(), settings);
      case myOrderDetailsPage:
        return _buildPageRoute(MyOrderDetailsPage(), settings);
      case notificationPage:
        return _buildPageRoute(NotificationPage(), settings);

      default:
        return _buildPageRoute(
          HomeScreen(),
          settings,
        );
    }
  }

  // ---------- Custom PageRoute with Fade + Slide ----------
  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        // Slide from right + fade
        const beginOffset = Offset(1.0, 0.0);
        const endOffset = Offset.zero;
        final tween = Tween(begin: beginOffset, end: endOffset)
            .chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }
}
