part of flutter_newpos_sdk;

class BluetoothDevice {
  BluetoothDevice({
    required this.address,
    required this.name,
    required this.type,
  });

  factory BluetoothDevice.fromMap(Map<dynamic, dynamic> map) {
    return BluetoothDevice(
      address: map['address'] as String,
      name: map['name'] as String,
      type: map['type'] as int,
    );
  }
  final String address;
  final String name;
  final int type;

  @override
  String toString() {
    return 'BluetoothDeviceModel{address: $address, name: $name, type: $type}';
  }
}
