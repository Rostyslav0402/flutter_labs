import 'package:flutter/material.dart';
import 'package:my_project/services/shared_preferences_user_storage.dart';
import 'package:my_project/services/user_storage.dart';

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

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final bool isValid = await _userStorage.validateLogin(
        _usernameController.text,
        _passwordController.text,
      );
      if(!mounted) return; // Перевірка, чи не закрито вікно
      if (isValid) {
        Navigator.pushNamed(context, '/home'); // Перехід на головну сторінку
      } else {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Закрити діалог
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
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
