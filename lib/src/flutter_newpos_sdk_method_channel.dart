import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_newpos_sdk_platform_interface.dart';

/// An implementation of [FlutterNewposSdkPlatform] that uses method channels.
class MethodChannelFlutterNewposSdk extends FlutterNewposSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_newpos_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
