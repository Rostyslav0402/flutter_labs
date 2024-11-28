import 'package:flutter/material.dart';
import 'package:my_project/services/shared_preferences_user_storage.dart';
import 'package:my_project/services/user_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserStorage _userStorage = SharedPreferencesUserStorage();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _userStorage.saveUserData(
        _usernameController.text,
        _passwordController.text,
        _nicknameController.text,
      );
      if(!mounted) return;
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Nickname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your nickname';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: validatePassword,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
