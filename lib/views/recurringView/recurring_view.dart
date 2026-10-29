import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/recurringModel/recurring_item_model.dart';
import 'package:finance_manager_app/models/walletModel/wallet_models.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/recurringProvider/recurring_provider.dart';
import 'package:finance_manager_app/services/recurring/recurring_schedule.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

String _taka(int v) => '৳${HelperFunctions.convertToBanglaDigits('$v')}';

String recurringScheduleText(RecurringItem i) {
  if (i.frequency == RecurringFrequency.weekly) {
    return 'every_weekday'.trParams({'day': 'weekday_${i.day}'.tr});
  }
  return 'every_month_on'.trParams({
    'day': HelperFunctions.convertToBanglaDigits('${i.day}'),
  });
}

class RecurringView extends StatefulWidget {
  const RecurringView({super.key});

  @override
  State<RecurringView> createState() => _RecurringViewState();
}

class _RecurringViewState extends State<RecurringView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<RecurringProvider>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecurringProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: customAppBar(
            title: 'recurring_bills'.tr,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Get.to(() => const RecurringFormView()),
            icon: const Icon(Icons.add),
            label: Text('add_recurring'.tr),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              if (provider.items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text('monthly_fixed_costs'.tr)),
                      const SizedBox(width: 12),
                      Text(
                        _taka(provider.monthlyBills),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              if (provider.items.isEmpty && !provider.isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Text(
                    'recurring_empty'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              for (final item in provider.items) _tile(item, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _tile(RecurringItem item, RecurringProvider provider) {
    final cat = RecurringProvider.categoryFor(item.categoryKey, item.isIncome);
    return Dismissible(
      key: ValueKey('recurring_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => provider.delete(item),
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          onTap: () => Get.to(() => RecurringFormView(item: item)),
          leading: CircleAvatar(
            backgroundColor: cat.color.withValues(alpha: 0.15),
            child: Icon(
              item.isIncome ? Icons.south_west : Icons.north_east,
              color: cat.color,
            ),
          ),
          title: Text(item.title),
          subtitle: Text(
            '${recurringScheduleText(item)}\n'
            '${'next_due'.tr}: ${HelperFunctions.getFormattedDate(item.nextDate)}'
            '${item.autoAdd ? '  •  ${'auto_add_short'.tr}' : ''}',
          ),
          isThreeLine: true,
          trailing: Text(
            _taka(item.amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.isIncome ? AppColors.success : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _Template {
  final String titleKey;
  final String categoryKey;
  final bool income;

  const _Template(this.titleKey, this.categoryKey, {this.income = false});
}

const _templates = [
  _Template('rec_house_rent', 'housing'),
  _Template('rec_electricity', 'bills_utilities'),
  _Template('rec_gas', 'bills_utilities'),
  _Template('rec_wifi', 'bills_utilities'),
  _Template('rec_mobile', 'bills_utilities'),
  _Template('rec_school_fee', 'education'),
  _Template('rec_dps', 'investment'),
  _Template('rec_emi', 'miscellaneous_expense'),
  _Template('rec_maid', 'housing'),
  _Template('rec_salary', 'salary', income: true),
];

class RecurringFormView extends StatefulWidget {
  final RecurringItem? item;

  const RecurringFormView({super.key, this.item});

  @override
  State<RecurringFormView> createState() => _RecurringFormViewState();
}

class _RecurringFormViewState extends State<RecurringFormView> {
  late final _title = TextEditingController(text: widget.item?.title ?? '');
  late final _amount = TextEditingController(
    text: widget.item == null ? '' : '${widget.item!.amount}',
  );
  late bool _income = widget.item?.isIncome ?? false;
  late String _category = widget.item?.categoryKey ?? 'bills_utilities';
  late String _method = widget.item?.paymentMethod ?? 'cash';
  late RecurringFrequency _frequency =
      widget.item?.frequency ?? RecurringFrequency.monthly;
  late int _day = widget.item?.day ?? DateTime.now().day;
  late bool _autoAdd = widget.item?.autoAdd ?? false;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _applyTemplate(_Template t) {
    setState(() {
      _title.text = t.titleKey.tr;
      _income = t.income;
      _category = t.categoryKey;
    });
  }

  void _setIncome(bool income) {
    setState(() {
      _income = income;
      _category = income ? 'salary' : 'bills_utilities';
    });
  }

  Future<void> _save() async {
    final amount = int.tryParse(_amount.text.trim()) ?? 0;
    final title = _title.text.trim();
    if (amount <= 0 || title.isEmpty || _saving) return;
    setState(() => _saving = true);

    final old = widget.item;
    final scheduleChanged =
        old == null || old.frequency != _frequency || old.day != _day;
    final item = RecurringItem(
      id: old?.id,
      title: title,
      amount: amount,
      isIncome: _income,
      categoryKey: _category,
      paymentMethod: _method,
      frequency: _frequency,
      day: _day,
      nextDate: scheduleChanged
          ? RecurringSchedule.firstDate(_frequency, _day, DateTime.now())
          : old.nextDate,
      autoAdd: _autoAdd,
    );
    final provider = context.read<RecurringProvider>();
    final txProvider = context.read<AddExpenseProvider>();
    await provider.save(item);
    // Due today: handle it right away instead of on the next app start.
    final pending = await provider.processDue(txProvider);
    if (!mounted) return;
    Navigator.pop(context);
    if (pending.isNotEmpty) await showDueRecurringDialog(pending);
  }

  InputDecoration _decoration(String label, {String? prefix}) =>
      InputDecoration(
        labelText: label,
        prefixText: prefix,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  @override
  Widget build(BuildContext context) {
    final categories = _income ? incomeCategoryItems : categoryItems;
    if (!categories.any((c) => c.key == _category)) {
      _category = categories.first.key;
    }

    return Scaffold(
      appBar: customAppBar(
        title: widget.item == null ? 'add_recurring'.tr : 'edit_recurring'.tr,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.item == null) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final t in _templates)
                  ActionChip(
                    label: Text(t.titleKey.tr),
                    onPressed: () => _applyTemplate(t),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text('expense'.tr)),
              ButtonSegment(value: true, label: Text('income'.tr)),
            ],
            selected: {_income},
            onSelectionChanged: (s) => _setIncome(s.first),
          ),
          const SizedBox(height: 16),
          TextField(controller: _title, decoration: _decoration('title_label'.tr)),
          const SizedBox(height: 12),
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _decoration('amount'.tr, prefix: '৳ '),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // Re-created when a template or the type changes the category.
            key: ValueKey('cat_${_income}_$_category'),
            initialValue: _category,
            isExpanded: true,
            decoration: _decoration('category'.tr),
            items: [
              for (final c in categories)
                DropdownMenuItem(value: c.key, child: Text(c.key.tr)),
            ],
            onChanged: (v) => setState(() => _category = v ?? _category),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _method,
            isExpanded: true,
            decoration: _decoration('wallet'.tr),
            items: [
              for (final w in allWallets)
                DropdownMenuItem(value: w.method, child: Text(w.method.tr)),
            ],
            onChanged: (v) => setState(() => _method = v ?? _method),
          ),
          const SizedBox(height: 16),
          SegmentedButton<RecurringFrequency>(
            segments: [
              ButtonSegment(
                value: RecurringFrequency.monthly,
                label: Text('monthly'.tr),
              ),
              ButtonSegment(
                value: RecurringFrequency.weekly,
                label: Text('weekly'.tr),
              ),
            ],
            selected: {_frequency},
            onSelectionChanged: (s) => setState(() {
              _frequency = s.first;
              _day = _frequency == RecurringFrequency.weekly
                  ? DateTime.now().weekday
                  : DateTime.now().day;
            }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey('day_${_frequency.name}'),
            initialValue: _day,
            decoration: _decoration(
              _frequency == RecurringFrequency.weekly
                  ? 'repeat_on_day'.tr
                  : 'repeat_on_date'.tr,
            ),
            items: _frequency == RecurringFrequency.weekly
                ? [
                    for (var d = 1; d <= 7; d++)
                      DropdownMenuItem(value: d, child: Text('weekday_$d'.tr)),
                  ]
                : [
                    for (var d = 1; d <= 31; d++)
                      DropdownMenuItem(
                        value: d,
                        child: Text(HelperFunctions.convertToBanglaDigits('$d')),
                      ),
                  ],
            onChanged: (v) => setState(() => _day = v ?? _day),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('auto_add'.tr),
            subtitle: Text(_autoAdd ? 'auto_add_on'.tr : 'auto_add_off'.tr),
            value: _autoAdd,
            onChanged: (v) => setState(() => _autoAdd = v),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: Text('save'.tr),
            ),
          ),
        ],
      ),
    );
  }
}

/// Asks about "ask first" bills that are due: add each one or skip it.
Future<void> showDueRecurringDialog(List<PendingRecurring> pending) async {
  if (pending.isEmpty) return;
  await Get.dialog(_DueRecurringDialog(pending: pending));
}

class _DueRecurringDialog extends StatefulWidget {
  final List<PendingRecurring> pending;

  const _DueRecurringDialog({required this.pending});

  @override
  State<_DueRecurringDialog> createState() => _DueRecurringDialogState();
}

class _DueRecurringDialogState extends State<_DueRecurringDialog> {
  late final List<PendingRecurring> _left = [...widget.pending];
  bool _busy = false;

  Future<void> _resolve(PendingRecurring p, bool add) async {
    if (_busy) return;
    setState(() => _busy = true);
    await context.read<RecurringProvider>().resolve(
      p,
      add: add,
      txProvider: context.read<AddExpenseProvider>(),
    );
    if (!mounted) return;
    setState(() {
      _left.remove(p);
      _busy = false;
    });
    if (_left.isEmpty) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('bills_due_title'.tr),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final p in _left)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.item.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        p.dates.length == 1
                            ? '${_taka(p.item.amount)}  •  ${HelperFunctions.getFormattedDate(p.dates.first)}'
                            : 'times_due'.trParams({
                                'count': HelperFunctions.convertToBanglaDigits(
                                  '${p.dates.length}',
                                ),
                                'amount': _taka(p.item.amount),
                              }),
                      ),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: _busy ? null : () => _resolve(p, false),
                            child: Text('skip'.tr),
                          ),
                          FilledButton(
                            onPressed: _busy ? null : () => _resolve(p, true),
                            child: Text(
                              p.item.isIncome
                                  ? 'add_income_now'.tr
                                  : 'add_expense_now'.tr,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('later'.tr),
        ),
      ],
    );
  }
}
