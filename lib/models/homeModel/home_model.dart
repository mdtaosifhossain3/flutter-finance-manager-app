import 'package:finance_manager_app/config/enums/enums.dart';

class CategorySummary {
  final String categoryName;
  final int count;
  final int total;
  final String icon;
  final int iconBgColor;
  final TransactionType type;
  final DateTime latestDate;

  CategorySummary({
    required this.categoryName,
    required this.count,
    required this.total,
    required this.icon,
    required this.iconBgColor,
    required this.type,
    required this.latestDate,
  });
}
