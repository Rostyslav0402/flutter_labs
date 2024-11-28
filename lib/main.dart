import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final connectivityResult = await Connectivity().checkConnectivity();

  // Перевірка підключення до інтернету
  if (email != null && connectivityResult == ConnectivityResult.none) {
    runApp(const MyApp(initialRoute: '/home', showNetworkAlert: true));
  } else if (email != null) {
    runApp(const MyApp(initialRoute: '/home'));
  } else {
    runApp(const MyApp(initialRoute: '/login'));
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final bool showNetworkAlert;

  const MyApp({required this.initialRoute, super.key, this.showNetworkAlert = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LoginScreen(),   // Додано маршрут для '/'
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => HomeScreen(showNetworkAlert: showNetworkAlert),
        '/login_screen': (context) => const LoginScreen(), // Додано для /login_screen
      },
    );
  }
}
