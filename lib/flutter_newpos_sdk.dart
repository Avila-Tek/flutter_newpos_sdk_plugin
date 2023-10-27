
import 'flutter_newpos_sdk_platform_interface.dart';

class FlutterNewposSdk {
  Future<String?> getPlatformVersion() {
    return FlutterNewposSdkPlatform.instance.getPlatformVersion();
  }
}
