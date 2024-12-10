import 'dart:async';
import 'package:flutter/services.dart';

class MyFlashlightPlugin {
  static const MethodChannel _channel = MethodChannel('my_flashlight_plugin');

  static Future<String?> getPlatformVersion() async {
    try {
      final String? version = await _channel.invokeMethod('getPlatformVersion');
      return version;
    } on PlatformException catch (e) {
      throw 'Не вдалося отримати версію платформи: ${e.message}';
    }
  }

  static Future<void> toggleFlashlight(bool turnOn) async {
    try {
      await _channel.invokeMethod('toggleFlashlight', {'turnOn': turnOn});
    } on PlatformException catch (e) {
      throw 'Не вдалося змінити стан ліхтарика: ${e.message}';
    }
  }
}
