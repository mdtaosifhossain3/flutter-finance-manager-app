class BudgetModel {
  final int? id; // auto-increment
  final String title;
  final int totalAmount;
  final DateTime startDate;
  final DateTime endDate;

  BudgetModel({
    this.id,
    required this.title,
    required this.totalAmount,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'totalAmount': totalAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      title: map['title'],
      totalAmount: map['totalAmount'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }
}
