class BudgetCategoryModel {
  final int? id; // auto-increment
  final int? budgetId; // FK -> budgets.id
  final String categoryName;
  final int spent;
  final String icon;
  final int iconBgColor;

  BudgetCategoryModel({
    this.id,
    this.budgetId,
    required this.categoryName,
    this.spent = 0,
    required this.icon,
    required this.iconBgColor,
  });

  BudgetCategoryModel copyWith({
    int? id,
    int? budgetId,
    String? categoryName,
    int? spent,
    String? icon,
    int? iconBgColor,
  }) {
    return BudgetCategoryModel(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      categoryName: categoryName ?? this.categoryName,
      spent: spent ?? this.spent,
      icon: icon ?? this.icon,
      iconBgColor: iconBgColor ?? this.iconBgColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'budgetId': budgetId,
      'categoryName': categoryName,
      'spent': spent,
      'icon': icon,
      'iconBgColor': iconBgColor,
    };
  }

  factory BudgetCategoryModel.fromMap(Map<String, dynamic> map) {
    return BudgetCategoryModel(
      id: map['id'],
      budgetId: map['budgetId'],
      categoryName: map['categoryName'],
      spent: map['spent'],
      iconBgColor: map['iconBgColor'],
      icon: map['icon'],
    );
  }
}
