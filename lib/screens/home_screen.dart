import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final bool showNetworkAlert;

  const HomeScreen({required this.showNetworkAlert, super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _email = '';
  String _nickname = '';
  bool _isLoading = true;
  // ignore: lines_longer_than_80_chars
  late StreamSubscription<List<ConnectivityResult>> _connectionSubscription; // Updated type

  @override
  void initState() {
    super.initState();
    _checkNetwork();
    _loadUserData();
    // ignore: lines_longer_than_80_chars
    _connectionSubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // ignore: lines_longer_than_80_chars
      // Handle the first connectivity result (assumes the first entry in the list is what you need)
      // ignore: lines_longer_than_80_chars
      final result = results.first; // Assuming the first result is the one you want
      if (result == ConnectivityResult.none) {
        // ignore: lines_longer_than_80_chars
        _showNetworkDialog('No Internet Connection', 'Please connect to the internet to enjoy full functionality.');
      } else {
        _showNetworkDialog('Connection Restored', 'You can now use the app.');
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _connectionSubscription.cancel();
    super.dispose();
  }

  /// Check network status
  Future<void> _checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: lines_longer_than_80_chars
      _showNetworkDialog('No Internet Connection', 'Please connect to the internet to enjoy full functionality.');
    }
  }

  /// Show network status dialog
  void _showNetworkDialog(String title, String content) {
    if (!mounted) return; // Check if widget is still in the widget tree
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Load user data
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _email = prefs.getString('email') ?? 'No email set';
      _nickname = prefs.getString('nickname') ?? 'No nickname set';
      _isLoading = false;
    });
  }

  /// Log out
  Future<void> _logout() async {
    final shouldLogout = await _showLogoutDialog();
    if (shouldLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  /// Show logout confirmation dialog
  Future<bool?> _showLogoutDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, $_nickname!', // Display nickname
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: const Icon(Icons.person),
              label: const Text('Go to Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
