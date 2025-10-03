import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gold_project/Bloc/AuthBloc/auth_bloc.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/Bloc/MyOrders/my_orders_bloc.dart';
import 'package:gold_project/Bloc/Notifications/notification_bloc.dart';
import 'package:gold_project/Bloc/Profile/profile_bloc.dart';
import 'package:gold_project/Screens/BottomNavBar/DashboardScreen.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'Screens/Auth/Login/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Prefs.init();

  String? fcmToken = await Prefs.getFcmToken(); // now safely nullable
  if (fcmToken == null) {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      fcmToken = await messaging.getToken();
      developer.log('FCM Token: $fcmToken');
      if (fcmToken != null) {
        await Prefs.setFcmToken(fcmToken);
      }
    } catch (e) {
      developer.log('Error fetching FCM token: $e');
    }
  }

  bool loggedIn = Prefs.isLoggedIn();
  runApp(MyApp(loggedIn: loggedIn));
}


class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<DashboardBloc>(create: (_) => DashboardBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<MyOrdersBloc>(create: (_) => MyOrdersBloc()),
        BlocProvider<NotificationBloc>(create: (_) => NotificationBloc()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: loggedIn ? DashboardScreen() : LoginScreen(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}