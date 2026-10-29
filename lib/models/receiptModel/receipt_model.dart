/// A receipt photo saved together with the transaction it created.
class ReceiptModel {
  final int? id;
  final int transactionId;
  final String imagePath;

  /// SHA-256 of the photo, to warn when the same photo is added twice.
  final String imageHash;
  final String? merchant;
  final int amount;
  final DateTime date;
  final String rawText;
  final DateTime createdAt;

  const ReceiptModel({
    this.id,
    required this.transactionId,
    required this.imagePath,
    required this.imageHash,
    this.merchant,
    required this.amount,
    required this.date,
    required this.rawText,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'transaction_id': transactionId,
    'image_path': imagePath,
    'image_hash': imageHash,
    'merchant': merchant,
    'amount': amount,
    'date': date.toIso8601String(),
    'raw_text': rawText,
    'created_at': createdAt.toIso8601String(),
  };

  factory ReceiptModel.fromMap(Map<String, dynamic> map) => ReceiptModel(
    id: map['id'] as int?,
    transactionId: map['transaction_id'] as int,
    imagePath: map['image_path'] as String,
    imageHash: map['image_hash'] as String,
    merchant: map['merchant'] as String?,
    amount: map['amount'] as int,
    date: DateTime.parse(map['date'] as String),
    rawText: (map['raw_text'] as String?) ?? '',
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
