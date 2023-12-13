part of flutter_newpos_sdk;

class DeviceScanned {
  const DeviceScanned({required this.device, required this.timestamp});

  factory DeviceScanned.fromDevice(BluetoothDevice device) {
    return DeviceScanned(
      device: device,
      timestamp: DateTime.now(),
    );
  }

  final BluetoothDevice device;
  final DateTime timestamp;

  @override
  String toString() {
    return 'DeviceScanned{device: $device, timestamp: $timestamp}';
  }
}
