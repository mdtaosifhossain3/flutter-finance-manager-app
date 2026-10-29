import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/walletProvider/wallet_provider.dart';
import 'package:finance_manager_app/services/autoSync/auto_sync_service.dart';
import 'package:finance_manager_app/services/parser/sms_parser.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

String _taka(int v) => '৳${HelperFunctions.convertToBanglaDigits('$v')}';

/// One parsed SMS in the review list.
class _Row {
  final ParsedSms sms;
  String categoryKey;
  bool selected;
  final bool duplicate;

  _Row(this.sms, {required this.duplicate})
    : categoryKey = sms.categoryKey,
      selected = !duplicate;
}

/// Paste (or share) bKash / Nagad / bank SMS, review them and save them as
/// transactions or wallet transfers.
class SmsImportView extends StatefulWidget {
  final String? initialText;

  /// Auto Sync items shown here; they leave the pending list once saved.
  final List<int> autoSyncIds;

  const SmsImportView({
    super.key,
    this.initialText,
    this.autoSyncIds = const [],
  });

  @override
  State<SmsImportView> createState() => _SmsImportViewState();
}

class _SmsImportViewState extends State<SmsImportView> {
  late final _text = TextEditingController(text: widget.initialText ?? '');
  List<_Row>? _rows;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if ((widget.initialText ?? '').trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _read());
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) return;
    _text.text = data!.text!;
    await _read();
  }

  Future<void> _read() async {
    FocusScope.of(context).unfocus();
    final parsed = SmsParser.parseAll(_text.text);
    final known = await _knownTrxIds();
    if (!mounted) return;
    setState(() {
      _rows = [
        for (final p in parsed)
          _Row(p, duplicate: p.trxId != null && known.contains(p.trxId)),
      ];
    });
  }

  /// TrxIDs already saved, from transaction notes and transfer notes.
  Future<Set<String>> _knownTrxIds() async {
    final List<Map<String, dynamic>> rows;
    try {
      rows = await AddTransactionDbHelper.getInstance.getAllNotes();
    } catch (_) {
      return {};
    }
    if (!mounted) return {};
    final notes = [
      for (final r in rows) (r['notes'] as String?) ?? '',
      for (final t in context.read<WalletProvider>().transfers) t.note,
    ];
    final re = RegExp(r'TrxID: ([A-Z0-9]+)');
    return {
      for (final n in notes)
        for (final m in re.allMatches(n)) m.group(1)!,
    };
  }

  CategoryItemModel _category(String key, bool income) {
    final list = income ? incomeCategoryItems : categoryItems;
    return list.firstWhere(
      (c) => c.key == key,
      orElse: () => list.firstWhere(
        (c) =>
            c.key ==
            (income ? 'miscellaneous_income' : 'miscellaneous_expense'),
      ),
    );
  }

  String _title(ParsedSms p) =>
      p.party == null ? p.titleKey.tr : '${p.titleKey.tr} ${p.party}';

  Future<void> _save() async {
    final rows = _rows?.where((r) => r.selected).toList() ?? [];
    if (rows.isEmpty || _saving) return;
    setState(() => _saving = true);

    final txProvider = context.read<AddExpenseProvider>();
    final wallets = context.read<WalletProvider>();
    final db = AddTransactionDbHelper.getInstance;

    try {
      for (final r in rows) {
        final p = r.sms;
        final note = p.trxId == null ? '' : 'TrxID: ${p.trxId}';

        if (p.kind == SmsKind.transfer) {
          final into = p.transferIntoWallet;
          await wallets.addTransfer(
            from: into ? p.otherWallet! : p.wallet,
            to: into ? p.wallet : p.otherWallet!,
            amount: p.amount,
            fee: p.fee,
            date: p.date,
            note: note,
          );
          continue;
        }

        final income = p.kind == SmsKind.income;
        final cat = _category(r.categoryKey, income);
        await db.insertItem(
          TransactionModel(
            type: income ? TransactionType.income : TransactionType.expense,
            date: p.date,
            title: _title(p),
            amount: p.amount,
            notes: note,
            paymentMethod: p.wallet,
            icon: cat.icon,
            iconBgColor: cat.color.toARGB32(),
            categoryKey: cat.key,
          ),
        );
        if (p.fee > 0 && !income) {
          final misc = _category('miscellaneous_expense', false);
          await db.insertItem(
            TransactionModel(
              type: TransactionType.expense,
              date: p.date,
              title: '${'transfer_fee'.tr} (${p.wallet.tr})',
              amount: p.fee,
              notes: note,
              paymentMethod: p.wallet,
              icon: misc.icon,
              iconBgColor: misc.color.toARGB32(),
              categoryKey: misc.key,
            ),
          );
        }
      }
      await txProvider.getTransactionsForMonth(txProvider.currentMonth);
      await wallets.load();
      await AutoSyncService.remove(widget.autoSyncIds);
      Get.back();
      Get.snackbar(
        'sms_import'.tr,
        'sms_saved'.trParams({
          'count': HelperFunctions.convertToBanglaDigits('${rows.length}'),
        }),
      );
    } catch (e) {
      Get.snackbar('error'.tr, '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    final selected = rows?.where((r) => r.selected).length ?? 0;

    return Scaffold(
      appBar: customAppBar(
        title: 'sms_import'.tr,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      bottomNavigationBar: selected == 0
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: Text(
                      'sms_save_selected'.trParams({
                        'count': HelperFunctions.convertToBanglaDigits(
                          '$selected',
                        ),
                      }),
                    ),
                  ),
                ),
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'sms_import_desc'.tr,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            minLines: 4,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'sms_paste_hint'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _paste,
                  icon: const Icon(Icons.content_paste),
                  label: Text('sms_paste'.tr),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _read,
                  icon: const Icon(Icons.auto_fix_high),
                  label: Text('sms_read'.tr),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (rows != null && rows.isEmpty)
            Text(
              'sms_nothing_found'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          if (rows != null)
            for (final r in rows) _rowCard(r),
        ],
      ),
    );
  }

  Widget _rowCard(_Row r) {
    final p = r.sms;
    final (label, color) = switch (p.kind) {
      SmsKind.income => ('income'.tr, AppColors.success),
      SmsKind.expense => ('expense'.tr, AppColors.error),
      SmsKind.transfer => ('transfer'.tr, AppColors.primaryBlue),
    };
    final String walletLine;
    if (p.kind == SmsKind.transfer) {
      final into = p.transferIntoWallet;
      final from = (into ? p.otherWallet! : p.wallet).tr;
      final to = (into ? p.wallet : p.otherWallet!).tr;
      walletLine = '$from → $to';
    } else {
      walletLine = p.wallet.tr;
    }
    final fee = p.fee > 0 ? '  •  ${'fee'.tr} ${_taka(p.fee)}' : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 12, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: r.selected,
              onChanged: (v) => setState(() => r.selected = v ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: color, fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _taka(p.amount),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(_title(p)),
                  Text(
                    '$walletLine  •  ${HelperFunctions.getFormattedDate(p.date)}$fee',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (r.duplicate)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'sms_already_added'.tr,
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (p.kind != SmsKind.transfer) ...[
                    const SizedBox(height: 6),
                    DropdownButton<String>(
                      value: r.categoryKey,
                      isExpanded: true,
                      isDense: true,
                      items: [
                        for (final c
                            in p.kind == SmsKind.income
                                ? incomeCategoryItems
                                : categoryItems)
                          DropdownMenuItem(value: c.key, child: Text(c.key.tr)),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => r.categoryKey = v);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
