import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:finance_manager_app/providers/notesProvider/notes_provider.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/services/insights/streak_service.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// Shown on the unsubscribe screen: what the user has built in the app and
/// would lose by leaving.
class RetentionSummaryCard extends StatefulWidget {
  const RetentionSummaryCard({super.key});

  @override
  State<RetentionSummaryCard> createState() => _RetentionSummaryCardState();
}

class _Summary {
  final int entries;
  final int months;
  final int tracked;
  final int bestStreak;
  final int goals;
  final int people;
  final int notes;

  const _Summary(
    this.entries,
    this.months,
    this.tracked,
    this.bestStreak,
    this.goals,
    this.people,
    this.notes,
  );
}

class _RetentionSummaryCardState extends State<RetentionSummaryCard> {
  late final Future<_Summary> _future = _load();

  Future<_Summary> _load() async {
    final savings = context.read<SavingsProvider>();
    final lend = context.read<GivenTakenProvider>();
    final notes = context.read<NotesProvider>();

    final rows = await AddTransactionDbHelper.getInstance.getAllNotes();
    final txs = rows.map(TransactionModel.fromMap).toList();
    await Future.wait([
      if (savings.goals.isEmpty) savings.loadGoals(),
      if (lend.contacts.isEmpty) lend.loadContacts(),
      if (notes.notes.isEmpty) notes.loadNotes(),
    ]).catchError((_) => <void>[]);

    return _Summary(
      txs.length,
      {for (final t in txs) '${t.date.year}-${t.date.month}'}.length,
      txs.fold(0, (s, t) => s + t.amount),
      StreakService.compute(txs, DateTime.now()).bestStreak,
      savings.goals.length,
      lend.contacts.length,
      notes.notes.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_Summary>(
      future: _future,
      builder: (context, snap) {
        final s = snap.data;
        if (s == null || s.entries == 0) return const SizedBox.shrink();
        String n(int v) => HelperFunctions.convertToBanglaDigits('$v');

        final lines = [
          ('📒', 'lose_entries'.trParams({'count': n(s.entries)})),
          ('🗓️', 'lose_months'.trParams({'count': n(s.months)})),
          ('💵', 'lose_tracked'.trParams({'amount': '৳${n(s.tracked)}'})),
          if (s.bestStreak > 1)
            ('🔥', 'lose_streak'.trParams({'count': n(s.bestStreak)})),
          if (s.goals > 0)
            ('🎯', 'lose_goals'.trParams({'count': n(s.goals)})),
          if (s.people > 0)
            ('🤝', 'lose_people'.trParams({'count': n(s.people)})),
          if (s.notes > 0)
            ('📝', 'lose_notes'.trParams({'count': n(s.notes)})),
        ];

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'lose_title'.tr,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              for (final (emoji, text) in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('$emoji  $text'),
                ),
              const SizedBox(height: 6),
              Text(
                'lose_footer'.tr,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}
