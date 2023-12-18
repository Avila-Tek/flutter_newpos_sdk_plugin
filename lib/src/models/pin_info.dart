part of flutter_newpos_sdk;

/// Represents information about a PIN requirement for a specific transaction.

class PinInfo {
  /// Creates a new `PinInfo` object.
  const PinInfo({
    required this.tagRes,
    required this.needPin,
  });

  /// The response tag, identifying the transaction within the system.
  final String tagRes;

  /// Whether a PIN is required for the transaction.
  final bool needPin;
}
