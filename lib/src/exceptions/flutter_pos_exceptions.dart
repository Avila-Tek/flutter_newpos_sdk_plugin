part of flutter_newpos_sdk;

class FlutterPosException implements Exception {
  const FlutterPosException({
    required this.code,
    required this.message,
  });
  final String code;
  final String message;
}

class BluetoothConnectionFailed extends FlutterPosException {
  BluetoothConnectionFailed({
    super.code = 'BLUETOOTH_CONNECTION_FAILED',
    super.message = 'Bluetooth connection failed',
  });
}
