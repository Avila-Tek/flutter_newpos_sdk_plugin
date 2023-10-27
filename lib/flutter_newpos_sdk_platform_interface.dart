import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_newpos_sdk_method_channel.dart';

abstract class FlutterNewposSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterNewposSdkPlatform.
  FlutterNewposSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNewposSdkPlatform _instance = MethodChannelFlutterNewposSdk();

  /// The default instance of [FlutterNewposSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNewposSdk].
  static FlutterNewposSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNewposSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterNewposSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
