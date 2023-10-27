import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_newpos_sdk/flutter_newpos_sdk.dart';
import 'package:flutter_newpos_sdk/flutter_newpos_sdk_platform_interface.dart';
import 'package:flutter_newpos_sdk/flutter_newpos_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNewposSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNewposSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterNewposSdkPlatform initialPlatform = FlutterNewposSdkPlatform.instance;

  test('$MethodChannelFlutterNewposSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNewposSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterNewposSdk flutterNewposSdkPlugin = FlutterNewposSdk();
    MockFlutterNewposSdkPlatform fakePlatform = MockFlutterNewposSdkPlatform();
    FlutterNewposSdkPlatform.instance = fakePlatform;

    expect(await flutterNewposSdkPlugin.getPlatformVersion(), '42');
  });
}
