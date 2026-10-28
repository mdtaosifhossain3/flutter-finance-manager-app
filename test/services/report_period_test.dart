import 'package:finance_manager_app/models/notificationModel/notification_model.dart';
import 'package:finance_manager_app/services/report_pdf_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('lastWeek', () {
    test('is the Monday-Sunday week before the given day', () {
      // Wednesday 28 Oct 2026, late evening.
      final p = ReportPeriod.lastWeek(DateTime(2026, 10, 28, 22, 15));
      expect(p.start, DateTime(2026, 10, 19)); // Monday
      expect(p.end, DateTime(2026, 10, 26)); // next Monday, exclusive
      expect(p.lastMoment.isBefore(DateTime(2026, 10, 26)), isTrue);
      expect(p.lastMoment.day, 25); // Sunday
      expect(p.label, '19 Oct - 25 Oct 2026');
      expect(p.fileName, 'weekly_report_2026-10-19.pdf');
    });

    test('same result on Monday and Sunday of one week', () {
      final monday = ReportPeriod.lastWeek(DateTime(2026, 10, 26));
      final sunday = ReportPeriod.lastWeek(DateTime(2026, 11, 1, 23, 59));
      expect(monday.start, sunday.start);
      expect(monday.end, sunday.end);
    });

    test('crosses month and year boundaries', () {
      final p = ReportPeriod.lastWeek(DateTime(2027, 1, 6));
      expect(p.start, DateTime(2026, 12, 28));
      expect(p.end, DateTime(2027, 1, 4));
    });
  });

  group('lastMonth', () {
    test('is the previous calendar month', () {
      final p = ReportPeriod.lastMonth(DateTime(2026, 10, 28));
      expect(p.start, DateTime(2026, 9, 1));
      expect(p.end, DateTime(2026, 10, 1));
      expect(p.label, 'September 2026');
      expect(p.fileName, 'monthly_report_2026-09-01.pdf');
    });

    test('January gives December of the year before', () {
      final p = ReportPeriod.lastMonth(DateTime(2027, 1, 1));
      expect(p.start, DateTime(2026, 12, 1));
      expect(p.end, DateTime(2027, 1, 1));
    });

    test('includes the very last moment of the month', () {
      final p = ReportPeriod.lastMonth(DateTime(2026, 10, 5));
      final lastTx = DateTime(2026, 9, 30, 23, 59, 59, 999).toIso8601String();
      expect(lastTx.compareTo(p.lastMoment.toIso8601String()) <= 0, isTrue);
      final nextTx = DateTime(2026, 10, 1).toIso8601String();
      expect(nextTx.compareTo(p.lastMoment.toIso8601String()) > 0, isTrue);
    });
  });

  test('notification keeps its report kind', () {
    for (final kind in [ReportKind.weekly, ReportKind.monthly, null]) {
      final n = NotificationModel(
        title: 't',
        body: 'b',
        date: DateTime(2026, 11, 2),
        reportKind: kind,
      );
      final back = NotificationModel.fromMap(n.toMap());
      expect(back.reportKind, kind);
      expect(back.isWeekly, kind == ReportKind.weekly);
    }
    // Rows saved by the old code.
    expect(
      NotificationModel.fromMap({
        'id': 1,
        'title': 't',
        'body': 'b',
        'date': '2026-10-01T10:00:00.000',
        'isWeekly': 0,
      }).reportKind,
      isNull,
    );
  });
}
