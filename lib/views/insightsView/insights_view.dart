import 'dart:io';

import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/services/insights/insights_service.dart';
import 'package:finance_manager_app/services/insights/streak_service.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

/// Everything the Insights screen and the Home streak banner need.
class InsightsData {
  final StreakStats streak;
  final List<Insight> insights;
  final List<AchievementBadge> badges;
  final int spent;
  final int income;

  const InsightsData({
    required this.streak,
    required this.insights,
    required this.badges,
    required this.spent,
    required this.income,
  });

  static Future<InsightsData> load() async {
    final now = DateTime.now();
    final rows = await AddTransactionDbHelper.getInstance.getAllNotes();
    final all = rows.map(TransactionModel.fromMap).toList();

    bool inMonth(DateTime d, int year, int month) =>
        d.year == year && d.month == month;
    final lastMonthDate = DateTime(now.year, now.month - 1, 1);
    final thisMonth = all
        .where((t) => inMonth(t.date, now.year, now.month))
        .toList();
    final lastMonth = all
        .where(
          (t) => inMonth(t.date, lastMonthDate.year, lastMonthDate.month),
        )
        .toList();

    final insights = InsightsService.compute(
      thisMonth: thisMonth,
      lastMonth: lastMonth,
      now: now,
    );
    final streak = StreakService.compute(all, now);
    return InsightsData(
      streak: streak,
      insights: insights,
      badges: StreakService.badges(
        streak,
        spentLessThanLastMonth: insights.any(
          (i) => i.key == 'insight_spent_less',
        ),
      ),
      spent: thisMonth
          .where((t) => t.type == TransactionType.expense)
          .fold(0, (s, t) => s + t.amount),
      income: thisMonth
          .where((t) => t.type == TransactionType.income && t.includeInTotal)
          .fold(0, (s, t) => s + t.amount),
    );
  }
}

/// Translated text of an [Insight], with digits localized.
String insightText(Insight insight) {
  final params = insight.params.map(
    (k, v) => MapEntry(
      k,
      k == 'category' || k == 'day'
          ? v.tr
          : HelperFunctions.convertToBanglaDigits(v),
    ),
  );
  return insight.key.trParams(params);
}

String _taka(int amount) =>
    '৳${HelperFunctions.convertToBanglaDigits(amount.toString())}';

class InsightsView extends StatefulWidget {
  const InsightsView({super.key});

  /// Replaced in widget tests, which have no database.
  @visibleForTesting
  static Future<InsightsData> Function() loader = InsightsData.load;

  @override
  State<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends State<InsightsView> {
  late Future<InsightsData> _future = InsightsView.loader();
  final _shareController = ScreenshotController();

  Future<void> _shareMonth(InsightsData data) async {
    try {
      final bytes = await _shareController.captureFromWidget(
        MediaQuery(
          data: MediaQuery.of(context),
          child: Theme(
            data: Theme.of(context),
            child: Material(child: _MonthShareCard(data: data)),
          ),
        ),
        pixelRatio: 3,
      );
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/my_month_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'share_month_text'.tr),
      );
    } catch (e) {
      Get.snackbar('error'.tr, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'insights'.tr,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<InsightsData>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('insights_load_failed'.tr, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          setState(() => _future = InsightsView.loader()),
                      child: Text('retry'.tr),
                    ),
                  ],
                ),
              ),
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _future = InsightsView.loader());
              await _future;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StreakCard(stats: data.streak),
                const SizedBox(height: 20),
                Text(
                  'this_month_insights'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                for (final insight in data.insights) _InsightTile(insight),
                const SizedBox(height: 20),
                Text(
                  'badges'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                _BadgeGrid(badges: data.badges),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: data.spent == 0 && data.income == 0
                        ? null
                        : () => _shareMonth(data),
                    icon: const Icon(Icons.share_outlined),
                    label: Text('share_my_month'.tr),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final StreakStats stats;

  const _StreakCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A3D), Color(0xFFFF5E62)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 44)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'streak_days'.trParams({
                    'count': HelperFunctions.convertToBanglaDigits(
                      '${stats.currentStreak}',
                    ),
                  }),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stats.loggedToday
                      ? 'streak_logged_today'.tr
                      : 'streak_log_today'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '${'best_streak'.tr}: ${HelperFunctions.convertToBanglaDigits('${stats.bestStreak}')}  •  '
                  '${'no_spend_days'.tr}: ${HelperFunctions.convertToBanglaDigits('${stats.noSpendDays}')}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final Insight insight;

  const _InsightTile(this.insight);

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (insight.tone) {
      InsightTone.good => (Icons.trending_down_rounded, AppColors.success),
      InsightTone.warning => (Icons.warning_amber_rounded, AppColors.warning),
      InsightTone.neutral => (
        Icons.lightbulb_outline_rounded,
        AppColors.primaryBlue,
      ),
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(insightText(insight)),
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  final List<AchievementBadge> badges;

  const _BadgeGrid({required this.badges});

  @override
  Widget build(BuildContext context) {
    // Fixed tile height: Bangla text is taller, so an aspect ratio overflows.
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 116,
      ),
      children: [
        for (final b in badges)
          Opacity(
            opacity: b.unlocked ? 1 : 0.35,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: b.unlocked
                      ? AppColors.warning
                      : AppColors.textMuted.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    b.unlocked ? b.emoji : '🔒',
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    b.key.tr,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The image shared by "Share my month".
class _MonthShareCard extends StatelessWidget {
  final InsightsData data;

  const _MonthShareCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final month =
        '${HelperFunctions.getLocalizedMonth(DateFormat('MMM').format(now))} '
        '${HelperFunctions.convertToBanglaDigits('${now.year}')}';
    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.primaryPurple],
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              month,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              'my_month'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _stat('income'.tr, _taka(data.income))),
                Expanded(child: _stat('expense'.tr, _taka(data.spent))),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'streak_days'.trParams({
                'count': HelperFunctions.convertToBanglaDigits(
                  '${data.streak.currentStreak}',
                ),
              }),
            ),
            const SizedBox(height: 16),
            for (final i in data.insights.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• ${insightText(i)}'),
              ),
            const SizedBox(height: 16),
            const Text(
              'Hishab Rakhi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
