class BudgetCategoryModel {
  final int? id; // auto-increment
  final int? budgetId; // FK -> budgets.id
  final String categoryName;
  final int allocatedAmount;
  final int spent;
 // final int color;

  BudgetCategoryModel({
    this.id,
    this.budgetId,
    required this.categoryName,
    required this.allocatedAmount,
    this.spent = 0,
 //   required this.color,


  });

  BudgetCategoryModel copyWith({
    int? id,
    int? budgetId,
    String? categoryName,
    int? allocatedAmount,
    int? spent,
  }) {
    return BudgetCategoryModel(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      categoryName: categoryName ?? this.categoryName,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spent: spent ?? this.spent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'budgetId': budgetId,
      'categoryName': categoryName,
      'allocatedAmount': allocatedAmount,
      'spent': spent,
   //   'color': color,

    };
  }

  factory BudgetCategoryModel.fromMap(Map<String, dynamic> map) {
    return BudgetCategoryModel(
      id: map['id'],
      budgetId: map['budgetId'],
      categoryName: map['categoryName'],
      allocatedAmount: map['allocatedAmount'],
      spent: map['spent'],
     // color: map['color'],

    );
  }
}
