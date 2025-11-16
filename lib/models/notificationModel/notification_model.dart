class NotificationModel {
  final int? id;
  final String title;
  final String body;
  final DateTime date;
  final bool isWeekly;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isWeekly = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'date': date.toIso8601String(),
    'isWeekly': isWeekly ? 1 : 0,
  };

  factory NotificationModel.fromMap(Map<String, dynamic> map) =>
      NotificationModel(
        id: map['id'],
        title: map['title'],
        body: map['body'],
        date: DateTime.parse(map['date']),
        isWeekly: map['isWeekly'] == 1,
      );
}
