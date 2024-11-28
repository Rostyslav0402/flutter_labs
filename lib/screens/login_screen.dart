import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_project/services/shared_preferences_user_storage.dart';
import 'package:my_project/services/user_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserStorage _userStorage = SharedPreferencesUserStorage();

  /// Перевірка стану мережі
  Future<bool> _checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      await _showNetworkDialog();
      return false;
    }
    return true;
  }

  /// Показати діалог про відсутність інтернету
  Future<void> _showNetworkDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please connect to the internet to log in.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Логіка логіну
  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Перевірка наявності інтернету
      final hasNetwork = await _checkNetwork();
      if (!hasNetwork) return;

      final bool isValid = await _userStorage.validateLogin(
        _usernameController.text,
        _passwordController.text,
      );

      if (!mounted) return; // Перевірка, чи не закрито вікно

      if (isValid) {
        // Зберігаємо дані в SharedPreferences для автологіну
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _usernameController.text);

        // Показуємо повідомлення про успішний вхід
        await _showSuccessDialog();
        if(mounted){
        Navigator.pushNamed(context, '/home');
         } // Перехід на головну сторінку
      } else {
        _showLoginFailedDialog();
      }
    }
  }

  /// Показ діалогового вікна про успішний вхід
  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Successful'),
          content: const Text('Welcome back!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Показ діалогового вікна про невдалий вхід
  void _showLoginFailedDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Поле для введення email
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Поле для введення пароля
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Кнопка для входу
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              // Кнопка для переходу на сторінку реєстрації
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Перехід до сторінки реєстрації
                },
                child: const Text('Don\'t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
