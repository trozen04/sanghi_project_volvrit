import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/AuthBloc/auth_bloc.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/Bloc/MyOrders/my_orders_bloc.dart';
import 'package:gold_project/Bloc/Notifications/notification_bloc.dart';
import 'package:gold_project/Bloc/Profile/profile_bloc.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required for async before runApp
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
          // Force textScaleFactor to 1 globally
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        initialRoute: loggedIn ? AppRoutes.dashboard : AppRoutes.login,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

