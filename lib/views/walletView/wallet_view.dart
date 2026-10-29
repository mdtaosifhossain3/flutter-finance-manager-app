import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/walletModel/wallet_models.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/walletProvider/wallet_provider.dart';
import 'package:finance_manager_app/services/wallet/wallet_calculator.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

String walletTaka(int v) {
  final sign = v < 0 ? '-' : '';
  return '$sign৳${HelperFunctions.convertToBanglaDigits('${v.abs()}')}';
}

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<WalletProvider>().load(),
    );
  }

  Future<void> _editBalance(WalletBalance w) async {
    final provider = context.read<WalletProvider>();
    final result = await showDialog<_BalanceAction>(
      context: context,
      builder: (_) => _BalanceDialog(wallet: w),
    );
    if (result == null) return;
    if (result.remove) {
      await provider.removeWallet(w.info.method);
    } else if (result.balance != null) {
      await provider.setCurrentBalance(w, result.balance!);
    }
  }

  Future<void> _addWallet() async {
    final provider = context.read<WalletProvider>();
    final shown = provider.wallets.map((w) => w.info.method).toSet();
    final available = allWallets
        .where((w) => !shown.contains(w.method))
        .toList();
    if (available.isEmpty) {
      Get.snackbar('wallets'.tr, 'all_wallets_added'.tr);
      return;
    }
    final method = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.7,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: Text(
                    'add_wallet'.tr,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                ),
                for (final w in available)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: w.color.withValues(alpha: 0.15),
                      child: Icon(w.icon, color: w.color),
                    ),
                    title: Text(w.method.tr),
                    onTap: () => Navigator.pop(ctx, w.method),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (method != null) await provider.addWallet(method);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: customAppBar(
            title: 'wallets'.tr,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                onPressed: _addWallet,
                icon: const Icon(Icons.add_card),
                tooltip: 'add_wallet'.tr,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showTransferSheet(context),
            icon: const Icon(Icons.swap_horiz),
            label: Text('transfer_cash_out'.tr),
          ),
          body: RefreshIndicator(
            onRefresh: provider.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                _totalCard(provider.total),
                const SizedBox(height: 8),
                Text(
                  'wallet_tap_hint'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                for (final w in provider.wallets)
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: () => _editBalance(w),
                      leading: CircleAvatar(
                        backgroundColor: w.info.color.withValues(alpha: 0.15),
                        child: Icon(w.info.icon, color: w.info.color),
                      ),
                      title: Text(w.info.method.tr),
                      subtitle: Text(
                        '${'income'.tr} ${walletTaka(w.income + w.transferIn)}'
                        '  •  ${'expense'.tr} ${walletTaka(w.expense + w.transferOut)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Text(
                        walletTaka(w.balance),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: w.balance < 0 ? AppColors.error : null,
                            ),
                      ),
                    ),
                  ),
                if (provider.transfers.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'recent_transfers'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  for (final t in provider.transfers.take(20))
                    _transferTile(t, provider),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _totalCard(int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.primaryPurple],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('total_balance'.tr, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            walletTaka(total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transferTile(WalletTransfer t, WalletProvider provider) {
    final fee = t.fee > 0 ? '  •  ${'fee'.tr} ${walletTaka(t.fee)}' : '';
    return Dismissible(
      key: ValueKey('transfer_${t.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        await provider.deleteTransfer(
          t,
          txProvider: context.read<AddExpenseProvider>(),
        );
        return false; // the list rebuilds without it
      },
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.swap_horiz),
        title: Text('${t.fromMethod.tr} → ${t.toMethod.tr}'),
        subtitle: Text('${HelperFunctions.getFormattedDate(t.date)}$fee'),
        trailing: Text(walletTaka(t.amount)),
      ),
    );
  }
}

class _BalanceAction {
  final int? balance;
  final bool remove;

  const _BalanceAction({this.balance, this.remove = false});
}

class _BalanceDialog extends StatefulWidget {
  final WalletBalance wallet;

  const _BalanceDialog({required this.wallet});

  @override
  State<_BalanceDialog> createState() => _BalanceDialogState();
}

class _BalanceDialogState extends State<_BalanceDialog> {
  late final _controller = TextEditingController(
    text: '${widget.wallet.balance}',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.wallet.info.method.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('set_current_balance_desc'.tr),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))],
            decoration: InputDecoration(
              labelText: 'current_balance'.tr,
              prefixText: '৳ ',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, const _BalanceAction(remove: true)),
          child: Text(
            'remove_wallet'.tr,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: () {
            final v = int.tryParse(_controller.text.trim());
            if (v != null) Navigator.pop(context, _BalanceAction(balance: v));
          },
          child: Text('save'.tr),
        ),
      ],
    );
  }
}

/// Opens the transfer / cash-out sheet. Used by the Wallets screen and Home.
Future<void> showTransferSheet(
  BuildContext context, {
  String? from,
  String? to,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _TransferSheet(from: from, to: to),
  );
}

class _TransferSheet extends StatefulWidget {
  final String? from;
  final String? to;

  const _TransferSheet({this.from, this.to});

  @override
  State<_TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends State<_TransferSheet> {
  late String _from = widget.from ?? 'bkash';
  late String _to = widget.to ?? 'cash';
  final _amount = TextEditingController();
  final _fee = TextEditingController();
  final _rate = TextEditingController();
  bool _feeEdited = false;
  bool _saving = false;

  bool get _isCashOut =>
      walletInfo(_from).isMobileWallet && _to == 'cash';

  @override
  void initState() {
    super.initState();
    _amount.addListener(_suggestFee);
    _rate.addListener(_suggestFee);
    _loadRate();
  }

  @override
  void dispose() {
    _amount.dispose();
    _fee.dispose();
    _rate.dispose();
    super.dispose();
  }

  Future<void> _loadRate() async {
    final rate = await context.read<WalletProvider>().cashOutRate(_from);
    if (!mounted) return;
    _rate.text = rate == 0 ? '' : '$rate';
    _suggestFee();
  }

  void _suggestFee() {
    if (_feeEdited) return;
    final amount = int.tryParse(_amount.text.trim()) ?? 0;
    final rate = double.tryParse(_rate.text.trim()) ?? 0;
    final fee = _isCashOut ? WalletCalculator.cashOutFee(amount, rate) : 0;
    _fee.text = fee > 0 ? '$fee' : '';
    setState(() {});
  }

  Future<void> _save() async {
    final amount = int.tryParse(_amount.text.trim()) ?? 0;
    if (amount <= 0 || _from == _to || _saving) return;
    setState(() => _saving = true);
    final provider = context.read<WalletProvider>();
    final txProvider = context.read<AddExpenseProvider>();
    final rate = double.tryParse(_rate.text.trim());
    if (_isCashOut && rate != null) {
      await provider.saveCashOutRate(_from, rate);
    }
    await provider.addTransfer(
      from: _from,
      to: _to,
      amount: amount,
      fee: int.tryParse(_fee.text.trim()) ?? 0,
      txProvider: txProvider,
    );
    if (mounted) Navigator.pop(context);
  }

  Widget _walletDropdown(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      // Re-created when the swap button changes the value.
      key: ValueKey('$label-$value'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
      items: [
        for (final w in allWallets)
          DropdownMenuItem(
            value: w.method,
            child: Row(
              children: [
                Icon(w.icon, color: w.color, size: 18),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    w.method.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount = int.tryParse(_amount.text.trim()) ?? 0;
    final fee = int.tryParse(_fee.text.trim()) ?? 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'transfer_cash_out'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _walletDropdown('from'.tr, _from, (v) {
                    setState(() => _from = v);
                    _loadRate();
                  }),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      final t = _from;
                      _from = _to;
                      _to = t;
                    });
                    _loadRate();
                  },
                  icon: const Icon(Icons.swap_horiz),
                ),
                Expanded(
                  child: _walletDropdown('to'.tr, _to, (v) {
                    setState(() => _to = v);
                    _suggestFee();
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'amount'.tr,
                prefixText: '৳ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (_isCashOut) ...[
                  Expanded(
                    child: TextField(
                      controller: _rate,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'cash_out_charge'.tr,
                        suffixText: '%',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: TextField(
                    controller: _fee,
                    onChanged: (_) {
                      _feeEdited = true;
                      setState(() {});
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'fee'.tr,
                      prefixText: '৳ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isCashOut) ...[
              const SizedBox(height: 6),
              Text(
                'cash_out_rate_hint'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (amount > 0 && fee > 0) ...[
              const SizedBox(height: 12),
              Text(
                'transfer_total_out'.trParams({
                  'wallet': _from.tr,
                  'amount': walletTaka(amount + fee),
                }),
              ),
            ],
            if (_from == _to) ...[
              const SizedBox(height: 8),
              Text(
                'same_wallet_error'.tr,
                style: const TextStyle(color: AppColors.error),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: amount > 0 && _from != _to && !_saving
                    ? _save
                    : null,
                child: Text('save'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
