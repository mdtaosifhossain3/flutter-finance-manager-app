import 'package:finance_manager_app/services/report_pdf_service.dart';

class NotificationModel {
  final int? id;
  final String title;
  final String body;
  final DateTime date;

  /// Set for "your weekly / monthly report is ready" notifications.
  final ReportKind? reportKind;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.date,
    this.reportKind,
  });

  bool get isWeekly => reportKind == ReportKind.weekly;

  // Stored in the existing `isWeekly` column, so no migration is needed:
  // 0 = normal, 1 = weekly report, 2 = monthly report.
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'date': date.toIso8601String(),
    'isWeekly': switch (reportKind) {
      ReportKind.weekly => 1,
      ReportKind.monthly => 2,
      null => 0,
    },
  };

  factory NotificationModel.fromMap(Map<String, dynamic> map) =>
      NotificationModel(
        id: map['id'],
        title: map['title'],
        body: map['body'],
        date: DateTime.parse(map['date']),
        reportKind: switch (map['isWeekly']) {
          1 => ReportKind.weekly,
          2 => ReportKind.monthly,
          _ => null,
        },
      );
}
