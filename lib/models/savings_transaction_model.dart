class SavingsTransaction {
  final int id;
  final int goalId;
  final String type; // 'add' or 'remove'
  final double amount;
  final String date;
  final String? note;
  final DateTime createdAt;

  SavingsTransaction({
    required this.id,
    required this.goalId,
    required this.type,
    required this.amount,
    required this.date,
    this.note,
    required this.createdAt,
  });

  /// Check if this is an add transaction
  bool get isAdd => type == 'add';

  /// Check if this is a remove transaction
  bool get isRemove => type == 'remove';

  /// Get sign prefix for display (+ or -)
  String get signPrefix => isAdd ? '+' : '-';

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal_id': goalId,
      'type': type,
      'amount': amount,
      'note': note,
      'date': date,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create from database Map
  static SavingsTransaction fromMap(Map<String, dynamic> map) {
    return SavingsTransaction(
      id: map['id'] as int,
      goalId: map['goal_id'] as int,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Create a copy with some fields updated
  SavingsTransaction copyWith({
    int? id,
    int? goalId,
    String? type,
    double? amount,
    String? date,
    String? note,
    DateTime? createdAt,
  }) {
    return SavingsTransaction(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SavingsTransaction(id: $id, goal: $goalId, $signPrefix$amount, $type, date: $date)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          goalId == other.goalId &&
          type == other.type &&
          amount == other.amount &&
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^
      goalId.hashCode ^
      type.hashCode ^
      amount.hashCode ^
      date.hashCode;
}
