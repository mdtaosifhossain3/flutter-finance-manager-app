import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:finance_manager_app/services/zakat/zakat_calculator.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZakatView extends StatefulWidget {
  const ZakatView({super.key});

  @override
  State<ZakatView> createState() => _ZakatViewState();
}

class _ZakatViewState extends State<ZakatView> {
  // Field key -> controller. Keys double as translation keys.
  final Map<String, TextEditingController> _c = {
    for (final k in [
      'zakat_cash',
      'zakat_bank',
      'zakat_mobile_wallet',
      'zakat_gold_bhori',
      'zakat_gold_price',
      'zakat_silver_bhori',
      'zakat_silver_price',
      'zakat_receivables',
      'zakat_business_stock',
      'zakat_other_assets',
      'zakat_debts',
    ])
      k: TextEditingController(),
  };

  // Prices change rarely, so they're remembered between visits.
  static const _rememberedKeys = ['zakat_gold_price', 'zakat_silver_price'];

  @override
  void initState() {
    super.initState();
    for (final c in _c.values) {
      c.addListener(() => setState(() {}));
    }
    _prefill();
  }

  Future<void> _prefill() async {
    final prefs = await SharedPreferences.getInstance();
    for (final k in _rememberedKeys) {
      final v = prefs.getString(k);
      if (v != null) _c[k]!.text = v;
    }

    if (!mounted) return;
    final lend = context.read<GivenTakenProvider>();
    try {
      if (lend.contacts.isEmpty) await lend.loadContacts();
    } catch (_) {
      return;
    }
    if (!mounted) return;
    if (lend.totalWillGet > 0) {
      _c['zakat_receivables']!.text = '${lend.totalWillGet}';
    }
    if (lend.totalNeedToPay > 0) {
      _c['zakat_debts']!.text = '${lend.totalNeedToPay}';
    }
  }

  @override
  void dispose() {
    // Read the prices now; the controllers are gone when prefs is ready.
    final prices = {for (final k in _rememberedKeys) k: _c[k]!.text};
    SharedPreferences.getInstance().then((prefs) {
      prices.forEach(prefs.setString);
    });
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  double _v(String k) => double.tryParse(_c[k]!.text.trim()) ?? 0;

  ZakatResult get _result => ZakatCalculator.calculate(
    ZakatInput(
      cash: _v('zakat_cash'),
      bank: _v('zakat_bank'),
      mobileWallet: _v('zakat_mobile_wallet'),
      goldBhori: _v('zakat_gold_bhori'),
      goldPricePerBhori: _v('zakat_gold_price'),
      silverBhori: _v('zakat_silver_bhori'),
      silverPricePerBhori: _v('zakat_silver_price'),
      receivables: _v('zakat_receivables'),
      businessStock: _v('zakat_business_stock'),
      otherAssets: _v('zakat_other_assets'),
      debts: _v('zakat_debts'),
    ),
  );

  String _taka(double v) =>
      '৳${HelperFunctions.convertToBanglaDigits(v.round().toString())}';

  @override
  Widget build(BuildContext context) {
    final r = _result;
    return Scaffold(
      appBar: customAppBar(
        title: 'zakat_calculator'.tr,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _resultCard(r),
          const SizedBox(height: 20),
          _section('zakat_section_money'.tr, [
            'zakat_cash',
            'zakat_bank',
            'zakat_mobile_wallet',
          ]),
          _section('zakat_section_gold_silver'.tr, [
            'zakat_gold_bhori',
            'zakat_gold_price',
            'zakat_silver_bhori',
            'zakat_silver_price',
          ]),
          _section('zakat_section_other'.tr, [
            'zakat_receivables',
            'zakat_business_stock',
            'zakat_other_assets',
          ]),
          _section('zakat_section_deduct'.tr, ['zakat_debts']),
          const SizedBox(height: 8),
          Text(
            'zakat_disclaimer'.tr,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _resultCard(ZakatResult r) {
    final color = r.isDue ? AppColors.success : AppColors.primaryBlue;
    final String status;
    if (r.nisab <= 0) {
      status = 'zakat_enter_price'.tr;
    } else if (r.isDue) {
      status = 'zakat_due'.tr;
    } else {
      status = 'zakat_not_due'.tr;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'zakat_payable'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            _taka(r.zakat),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(status),
          const Divider(height: 24),
          _row('zakat_net_wealth'.tr, _taka(r.netWealth)),
          _row('zakat_nisab'.tr, r.nisab > 0 ? _taka(r.nisab) : '—'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label)),
        const SizedBox(width: 12),
        Text(value),
      ],
    ),
  );

  Widget _section(String title, List<String> keys) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final k in keys)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _c[k],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  labelText: k.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
