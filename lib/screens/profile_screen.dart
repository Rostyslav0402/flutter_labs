import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text('Username: johndoe'),
            const Text('Email: johndoe@example.com'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Додайте логіку для редагування профілю
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
