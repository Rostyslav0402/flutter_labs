import 'package:flutter/material.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin.dart';

void main() {
  runApp(const FlashlightApp());
}

class FlashlightApp extends StatelessWidget {
  const FlashlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashlight App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FlashlightScreen(),
    );
  }
}

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlashlightScreenState createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  bool _isFlashlightOn = false;

  void _toggleFlashlight() async {
    try {
      await MyFlashlightPlugin.toggleFlashlight(!_isFlashlightOn); // Викликаємо метод плагіна
      setState(() {
        _isFlashlightOn = !_isFlashlightOn;
      });
    } catch (e) {
      // Якщо виникла помилка (наприклад, функціонал не підтримується)
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Помилка'),
          content: Text('Не вдалося змінити стан ліхтарика. $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ліхтарик')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isFlashlightOn ? 'Ліхтарик увімкнено' : 'Ліхтарик вимкнено',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleFlashlight,
              child: Text(_isFlashlightOn ? 'Вимкнути ліхтарик' : 'Увімкнути ліхтарик'),
            ),
          ],
        ),
      ),
    );
  }
}
