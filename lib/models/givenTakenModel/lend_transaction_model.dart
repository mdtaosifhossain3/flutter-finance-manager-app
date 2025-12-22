class LendTransaction {
  final int? id;
  final int contactId;
  final String type; // 'given' or 'taken'
  final int amount;
  final String date;
  final String? note;
  final DateTime createdAt;

  LendTransaction({
    this.id,
    required this.contactId,
    required this.type,
    required this.amount,
    required this.date,
    this.note,
    required this.createdAt,
  });

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'contact_id': contactId,
      'type': type,
      'amount': amount,
      'date': date,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create from database Map
  factory LendTransaction.fromMap(Map<String, dynamic> map) {
    return LendTransaction(
      id: map['id'] as int?,
      contactId: map['contact_id'] as int,
      type: map['type'] as String,
      amount: map['amount'] as int,
      date: map['date'] as String,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Create a copy with some fields updated
  LendTransaction copyWith({
    int? id,
    int? contactId,
    String? type,
    int? amount,
    String? date,
    String? note,
    DateTime? createdAt,
  }) {
    return LendTransaction(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'LendTransaction(id: $id, contactId: $contactId, type: $type, amount: $amount)';
  }
}
