class Expense {
  final int? sno;
  final String date;
  final String title;
  final double amount;
  final String icon;
  final String month;
  final String time;
  final String categoryName;
  final String message;

  Expense({
    this.sno,
    required this.date,
    required this.title,
    required this.amount,
    required this.icon,
    required this.month,
    required this.time,
    required this.categoryName,
    required this.message,
  });

  // Convert Expense object to a Map
  Map<String, dynamic> toMap() {
    return {
      'sno': sno,
      'date': date,
      'title': title,
      'amount': amount, // Note: keeping the typo to match database schema
      'icon': icon,
      'month': month,
      'time': time,
      'category_name': categoryName,
      'message': message,
    };
  }

  // Create an Expense object from a Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      sno: map['sno'] as int?,
      date: map['date'] as String,
      title: map['title'] as String,
      amount: map['amount'] as double, // Note: keeping the typo to match database schema
      icon: map['icon'] as String,
      month: map['month'] as String,
      time: map['time'] as String,
      categoryName: map['category_name'] as String,
      message: map['message'] as String,
    );
  }

  // Create a copy of the current Expense with optional new values
  Expense copyWith({
    int? sno,
    String? date,
    String? title,
    double? amount,
    String? icon,
    String? month,
    String? time,
    String? categoryName,
    String? message,
  }) {
    return Expense(
      sno: sno ?? this.sno,
      date: date ?? this.date,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      icon: icon ?? this.icon,
      month: month ?? this.month,
      time: time ?? this.time,
      categoryName: categoryName ?? this.categoryName,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'Expense(sno: $sno, date: $date, title: $title, amount: $amount, icon: $icon, month: $month, time: $time, categoryName: $categoryName,message:$message)';
  }
}
