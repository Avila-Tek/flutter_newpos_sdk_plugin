part of flutter_newpos_sdk;

/// A class representing a device info object.
///
/// This class contains information about the device's firmware version, device type, KSN, and current ele per.
///
/// Parameters:
///
/// * `firmwareVersion` (required): The device's firmware version.
/// * `deviceType` (required): The device's type.
/// * `ksn` (required): The device's KSN.
/// * `currentElePer` (required): The device's current ele per.
class DeviceInfo {
  /// Constructs a new `DeviceInfo` object.
  const DeviceInfo({
    required this.firmwareVersion,
    required this.deviceType,
    required this.ksn,
    required this.currentElePer,
  });

  /// Creates a new `DeviceInfo` object from a map.
  factory DeviceInfo.fromMap(Map<dynamic, dynamic> map) {
    return DeviceInfo(
      firmwareVersion: map['firmwareVersion'] as String,
      deviceType: map['deviceType'] as String,
      ksn: map['ksn'] as String,
      currentElePer: double.parse(map['currentElePer'].toString()),
    );
  }

  /// The device's firmware version.
  final String firmwareVersion;

  /// The device's type.
  final String deviceType;

  /// The device's KSN.
  final String ksn;

  /// The device's current ele per.
  final double currentElePer;
}
