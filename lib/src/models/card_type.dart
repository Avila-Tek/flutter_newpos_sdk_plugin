enum CardType {
  debito(['Debito']),
  credit(['Credito']),
  debitoCredito(['Credito,Debito', 'Debito/Credito']),
  unknown([]);

  const CardType(this.possibleValues);
  final List<String> possibleValues;
  // Getter to check if the card type is debitoCredito
  bool get isDebitCredito => this == CardType.debitoCredito;
  bool get isUnknown => this == CardType.unknown;

  // Function to convert string value to enum
  static CardType? fromValue(String value) {
    for (var cardType in CardType.values) {
      if (cardType.possibleValues.any((possibleValue) =>
          value.toLowerCase() == possibleValue.toLowerCase())) {
        return cardType;
      }
    }
    return null;
  }
}
