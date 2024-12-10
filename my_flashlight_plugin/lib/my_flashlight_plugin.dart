import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'my_flashlight_plugin_method_channel.dart';

abstract class MyFlashlightPluginPlatform extends PlatformInterface {
  /// Constructs a MyFlashlightPluginPlatform.
  MyFlashlightPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static MyFlashlightPluginPlatform _instance = MethodChannelMyFlashlightPlugin();

  /// The default instance of [MyFlashlightPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelMyFlashlightPlugin].
  static MyFlashlightPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MyFlashlightPluginPlatform] when
  /// they register themselves.
  static set instance(MyFlashlightPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
