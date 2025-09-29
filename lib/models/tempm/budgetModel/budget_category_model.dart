class BudgetCategoryModel {
  final int? id; // auto-increment
  final int budgetId; // FK -> budgets.id
  final String categoryName;
  final int allocatedAmount;

  BudgetCategoryModel({
    this.id,
    required this.budgetId,
    required this.categoryName,
    required this.allocatedAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'budgetId': budgetId,
      'categoryName': categoryName,
      'allocatedAmount': allocatedAmount,
    };
  }

  factory BudgetCategoryModel.fromMap(Map<String, dynamic> map) {
    return BudgetCategoryModel(
      id: map['id'],
      budgetId: map['budgetId'],
      categoryName: map['categoryName'],
      allocatedAmount: map['allocatedAmount'],
    );
  }
}
