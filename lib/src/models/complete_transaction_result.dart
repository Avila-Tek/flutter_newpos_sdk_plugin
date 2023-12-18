part of flutter_newpos_sdk;

/// Class that represents the result of a successful transaction.
class CompleteTransactionResult {
  /// Constant constructor that initializes the class.

  const CompleteTransactionResult({
    /// Information about the card used in the transaction (required).
    required this.card,

    /// PIN entered during the transaction (optional). Can be null.
    this.pin,
  });

  /// Stores information about the card used in the transaction.
  final ReadCardInfo card;

  /// Stores the PIN entered during the transaction, if required. Can be null.
  final String? pin;

  /// Overrides the `toString()` method to return a textual representation of the object.
  @override
  String toString() => 'CompleteTransactionResult(card: $card, pin: $pin)';
}
