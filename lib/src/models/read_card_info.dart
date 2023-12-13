part of flutter_newpos_sdk;

class ReadCardInfo {
  const ReadCardInfo({
    required this.cardType,
    required this.cardNumber,
    this.track1,
    this.track2,
    this.ic55Data,
    this.encryptPin,
    this.cardholderName,
    this.encryptedSN,
    this.tusn,
    this.expDate,
    this.track3,
    this.csn,
  });

  factory ReadCardInfo.fromJson(Map<String, dynamic> json) => ReadCardInfo(
        track1: json['track1'] as String?,
        track2: json['track2'] as String?,
        ic55Data: json['ic55Data'] as String?,
        encryptPin: json['encryptPin'] as String?,
        cardholderName: json['cardholderName'] as String?,
        encryptedSN: json['encryptedSN'] as String?,
        cardType: json['cardType'] as int,
        tusn: json['tusn'] as String?,
        cardNumber: json['cardNumber'] as String? ?? '',
        expDate: json['expDate'] as String?,
        track3: json['track3'] as String?,
        csn: json['csn'] as String?,
      );
  final String? track1;
  final String? track2;
  final String? ic55Data;
  final String? encryptPin;
  final String? cardholderName;
  final String? encryptedSN;
  final int cardType;
  final String? tusn;
  final String cardNumber;
  final String? expDate;
  final String? track3;
  final String? csn;

  Map<String, dynamic> toJson() => {
        'track1': track1,
        'track2': track2,
        'ic55Data': ic55Data,
        'encryptPin': encryptPin,
        'cardholderName': cardholderName,
        'encryptedSN': encryptedSN,
        'cardType': cardType,
        'tusn': tusn,
        'cardNumber': cardNumber,
        'expDate': expDate,
        'track3': track3,
        'csn': csn,
      };

  String get expirationDate {
    if (expDate == null) return '';
    if (expDate!.length < 4) return expDate!;
    final dayString = expDate!.substring(0, 2);
    final monthString = expDate!.substring(2, 4);
    return '$monthString/$dayString';
  }

  @override
  String toString() {
    return '(ReadCardInfo, $cardNumber, $expDate, $track2)';
  }
}
