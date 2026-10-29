import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:finance_manager_app/data/festival/festival_templates.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

String _taka(int v) => '৳${HelperFunctions.convertToBanglaDigits('$v')}';

class FestivalPlannerView extends StatelessWidget {
  const FestivalPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      appBar: customAppBar(
        title: 'festival_planner'.tr,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'festival_planner_desc'.tr,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          for (final t in festivalTemplates)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: Text(t.emoji, style: const TextStyle(fontSize: 30)),
                title: Text(t.key.tr),
                subtitle: Text(_subtitle(t, now)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.to(() => FestivalPlanEditView(template: t)),
              ),
            ),
        ],
      ),
    );
  }

  String _subtitle(FestivalTemplate t, DateTime now) {
    final total = t.items.fold(0, (s, i) => s + i.amount);
    final next = t.nextDate(now);
    if (next == null) return '${'estimated_cost'.tr}: ${_taka(total)}';
    final days = next.difference(now).inDays + 1;
    return '${'fest_days_left'.trParams({'count': HelperFunctions.convertToBanglaDigits('$days')})}'
        '  •  ${_taka(total)}';
  }
}

class FestivalPlanEditView extends StatefulWidget {
  final FestivalTemplate template;

  const FestivalPlanEditView({super.key, required this.template});

  @override
  State<FestivalPlanEditView> createState() => _FestivalPlanEditViewState();
}

class _FestivalPlanEditViewState extends State<FestivalPlanEditView> {
  late final List<TextEditingController> _amounts = [
    for (final i in widget.template.items)
      TextEditingController(text: '${i.amount}')
      ..addListener(() => setState(() {})),
  ];
  late DateTime _date =
      widget.template.nextDate(DateTime.now()) ??
      DateTime.now().add(const Duration(days: 60));
  bool _saving = false;

  @override
  void dispose() {
    for (final c in _amounts) {
      c.dispose();
    }
    super.dispose();
  }

  int get _total =>
      _amounts.fold(0, (s, c) => s + (int.tryParse(c.text.trim()) ?? 0));

  int get _daysLeft {
    final today = DateTime.now();
    final d = DateTime(
      _date.year,
      _date.month,
      _date.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
    return d < 1 ? 1 : d;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _createGoal() async {
    if (_total <= 0 || _saving) return;
    setState(() => _saving = true);
    try {
      await context.read<SavingsProvider>().createGoal(
        name: '${widget.template.emoji} ${widget.template.key.tr} ${_date.year}',
        targetAmount: _total.toDouble(),
        startDate: DateTime.now().toString().split(' ')[0],
      );
      Get.back();
      Get.snackbar(
        'festival_planner'.tr,
        'festival_goal_created'.trParams({
          'amount': _taka((_total / _daysLeft).ceil()),
        }),
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () => Get.toNamed(RoutesName.savingsView),
          child: Text('savings'.tr),
        ),
      );
    } catch (e) {
      Get.snackbar('error'.tr, '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.template;
    final perDay = (_total / _daysLeft).ceil();
    final perMonth = (_total / (_daysLeft / 30)).ceil();

    return Scaffold(
      appBar: customAppBar(
        title: '${t.emoji} ${t.key.tr}',
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(HelperFunctions.getFormattedDate(_date)),
              subtitle: Text(
                t.dateIsEstimate
                    ? 'festival_date_estimate'.tr
                    : 'festival_date_tap'.tr,
              ),
              trailing: const Icon(Icons.edit_calendar),
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 16),
          Text('festival_items'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (var i = 0; i < t.items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _amounts[i],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: t.items[i].key.tr,
                  prefixText: '৳ ',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _row('festival_total'.tr, _taka(_total), bold: true),
                _row(
                  'fest_days_left'.trParams({
                    'count': HelperFunctions.convertToBanglaDigits('$_daysLeft'),
                  }),
                  '',
                ),
                _row('save_per_day'.tr, _taka(perDay)),
                if (_daysLeft >= 45) _row('save_per_month'.tr, _taka(perMonth)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _total > 0 && !_saving ? _createGoal : null,
              icon: const Icon(Icons.savings_outlined),
              label: Text('create_savings_goal'.tr),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    final style = bold
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: style)),
          const SizedBox(width: 12),
          Text(value, style: style),
        ],
      ),
    );
  }
}
