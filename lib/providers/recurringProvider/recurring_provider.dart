import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/db/local/recurring_db/recurring_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/models/recurringModel/recurring_item_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/services/recurring/recurring_schedule.dart';
import 'package:finance_manager_app/services/reminder_helper.dart';
import 'package:flutter/foundation.dart';

/// An "ask first" item whose due dates have come.
class PendingRecurring {
  final RecurringItem item;
  final List<DateTime> dates;

  const PendingRecurring(this.item, this.dates);
}

class RecurringProvider with ChangeNotifier {
  final RecurringDbHelper _db = RecurringDbHelper.getInstance;

  List<RecurringItem> _items = [];
  bool _isLoading = false;

  List<RecurringItem> get items => _items;
  bool get isLoading => _isLoading;

  int get monthlyBills => _items
      .where((i) => !i.isIncome)
      .fold(
        0,
        (s, i) =>
            s +
            (i.frequency == RecurringFrequency.weekly ? i.amount * 4 : i.amount),
      );

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _db.getAll();
    } catch (e) {
      debugPrint('RecurringProvider.load: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save(RecurringItem item) async {
    final saved = item.id == null
        ? item.copyWith(id: await _db.insert(item))
        : item;
    if (item.id != null) await _db.update(item);
    await ReminderHelper.scheduleRecurringDue(saved);
    await load();
  }

  Future<void> delete(RecurringItem item) async {
    _items = _items.where((i) => i.id != item.id).toList();
    notifyListeners();
    await _db.delete(item.id!);
    await ReminderHelper.cancelRecurringDue(item.id!);
  }

  /// Adds the transactions of "auto add" items that are due and returns
  /// the "ask first" items that are due.
  Future<List<PendingRecurring>> processDue(
    AddExpenseProvider txProvider,
  ) async {
    await load();
    final today = DateTime.now();
    final pending = <PendingRecurring>[];
    var added = false;

    for (final item in _items) {
      final dates = RecurringSchedule.dueDates(
        nextDate: item.nextDate,
        frequency: item.frequency,
        day: item.day,
        today: today,
      );
      if (dates.isEmpty) continue;
      if (item.autoAdd) {
        await _addTransactions(item, dates);
        await _advance(item, dates.last);
        added = true;
      } else {
        pending.add(PendingRecurring(item, dates));
      }
    }

    if (added) {
      await txProvider.getTransactionsForMonth(txProvider.currentMonth);
      await load();
    }
    return pending;
  }

  /// The user answered an "ask first" item: add it or skip it. Either way
  /// it moves on to its next date.
  Future<void> resolve(
    PendingRecurring p, {
    required bool add,
    required AddExpenseProvider txProvider,
  }) async {
    if (add) await _addTransactions(p.item, p.dates);
    await _advance(p.item, p.dates.last);
    if (add) {
      await txProvider.getTransactionsForMonth(txProvider.currentMonth);
    }
    await load();
  }

  Future<void> _advance(RecurringItem item, DateTime lastDone) async {
    final next = item.copyWith(
      nextDate: RecurringSchedule.next(lastDone, item.frequency, item.day),
    );
    await _db.update(next);
    await ReminderHelper.scheduleRecurringDue(next);
  }

  Future<void> _addTransactions(
    RecurringItem item,
    List<DateTime> dates,
  ) async {
    final cat = categoryFor(item.categoryKey, item.isIncome);
    for (final d in dates) {
      await AddTransactionDbHelper.getInstance.insertItem(
        TransactionModel(
          type: item.isIncome ? TransactionType.income : TransactionType.expense,
          date: DateTime(d.year, d.month, d.day, 9),
          title: item.title,
          amount: item.amount,
          notes: '',
          paymentMethod: item.paymentMethod,
          icon: cat.icon,
          iconBgColor: cat.color.toARGB32(),
          categoryKey: cat.key,
        ),
      );
    }
  }

  static CategoryItemModel categoryFor(String key, bool income) {
    final list = income ? incomeCategoryItems : categoryItems;
    return list.firstWhere(
      (c) => c.key == key,
      orElse: () => list.firstWhere(
        (c) =>
            c.key == (income ? 'miscellaneous_income' : 'miscellaneous_expense'),
      ),
    );
  }

  Future<void> deleteFull() async {
    for (final i in _items) {
      if (i.id != null) await ReminderHelper.cancelRecurringDue(i.id!);
    }
    await _db.deleteFull();
    _items = [];
    notifyListeners();
  }
}
