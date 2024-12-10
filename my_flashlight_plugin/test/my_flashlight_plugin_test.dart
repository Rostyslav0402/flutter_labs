import 'package:flutter_test/flutter_test.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin_platform_interface.dart';
import 'package:my_flashlight_plugin/my_flashlight_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMyFlashlightPluginPlatform
    with MockPlatformInterfaceMixin
    implements MyFlashlightPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MyFlashlightPluginPlatform initialPlatform = MyFlashlightPluginPlatform.instance;

  test('$MethodChannelMyFlashlightPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMyFlashlightPlugin>());
  });

  test('getPlatformVersion', () async {
    MockMyFlashlightPluginPlatform fakePlatform = MockMyFlashlightPluginPlatform();
    MyFlashlightPluginPlatform.instance = fakePlatform;

    expect(await MyFlashlightPlugin.getPlatformVersion(), '42');
  });
}
