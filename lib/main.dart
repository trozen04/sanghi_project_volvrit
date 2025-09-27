import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gold_project/Bloc/AuthBloc/auth_bloc.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/Bloc/MyOrders/my_orders_bloc.dart';
import 'package:gold_project/Bloc/Notifications/notification_bloc.dart';
import 'package:gold_project/Bloc/Profile/profile_bloc.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String? fcmToken = await Prefs.getFcmToken();
  if (fcmToken == null) {
    // Generate FCM token and save
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    fcmToken = await messaging.getToken();
    developer.log('FCM Token: $fcmToken');
    if (fcmToken != null) {
      await Prefs.setFcmToken(fcmToken);
    }
  }
  // Generate FCM token
  bool loggedIn = await Prefs.isLoggedIn();
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
        initialRoute: loggedIn ? AppRoutes.dashboard : AppRoutes.login,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
