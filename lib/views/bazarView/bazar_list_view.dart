import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/bazarModel/bazar_item_model.dart';
import 'package:finance_manager_app/providers/bazarProvider/bazar_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

String _taka(int v) => '৳${HelperFunctions.convertToBanglaDigits('$v')}';

/// Common items offered as one-tap chips (translation keys).
const _suggestions = [
  'bazar_rice',
  'bazar_lentil',
  'bazar_oil',
  'bazar_onion',
  'bazar_potato',
  'bazar_egg',
  'bazar_fish',
  'bazar_meat',
  'bazar_vegetables',
  'bazar_sugar',
  'bazar_salt',
  'bazar_milk',
];

class BazarListView extends StatefulWidget {
  const BazarListView({super.key});

  @override
  State<BazarListView> createState() => _BazarListViewState();
}

class _BazarListViewState extends State<BazarListView> {
  final _addController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<BazarProvider>().loadItems(),
    );
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  Future<void> _add(String name) async {
    await context.read<BazarProvider>().addItem(name);
    _addController.clear();
  }

  Future<void> _enterPrice(BazarItem item) async {
    final provider = context.read<BazarProvider>();
    if (item.isBought) {
      await provider.setPrice(item, null);
      return;
    }

    final result = await showDialog<(int, String)>(
      context: context,
      builder: (_) => _PriceDialog(item: item),
    );
    if (result != null) {
      await provider.setPrice(item, result.$1, quantity: result.$2);
    }
  }

  Future<void> _finish() async {
    final provider = context.read<BazarProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('bazar_finish'.tr),
        content: Text(
          'bazar_finish_confirm'.trParams({
            'amount': _taka(provider.tripTotal),
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final saved = await provider.finishTrip(context.read<AddExpenseProvider>());
    if (saved) Get.snackbar('bazar_list'.tr, 'bazar_saved'.tr);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BazarProvider>(
      builder: (context, provider, _) {
        final names = provider.items.map((i) => i.name.toLowerCase()).toSet();
        final chips = _suggestions
            .where((k) => !names.contains(k.tr.toLowerCase()))
            .toList();

        return Scaffold(
          appBar: customAppBar(
            title: 'bazar_list'.tr,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          bottomNavigationBar: provider.boughtItems.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _finish,
                        child: Text(
                          '${'bazar_finish'.tr} • ${_taka(provider.tripTotal)}',
                        ),
                      ),
                    ),
                  ),
                ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _addController,
                textInputAction: TextInputAction.done,
                onSubmitted: _add,
                decoration: InputDecoration(
                  hintText: 'bazar_add_hint'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () => _add(_addController.text),
                  ),
                ),
              ),
              if (chips.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final k in chips)
                      ActionChip(
                        label: Text('+ ${k.tr}'),
                        onPressed: () => _add(k.tr),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              if (provider.items.isEmpty && !provider.isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'bazar_empty'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              for (final item in provider.items) _itemTile(item, provider),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _itemTile(BazarItem item, BazarProvider provider) {
    final subtitle = <String>[
      if (item.quantity.isNotEmpty) item.quantity,
      if (item.lastPrice > 0)
        '${'bazar_last_time'.tr}: ${_taka(item.lastPrice)}',
    ].join('  •  ');

    // Price change of the last trip vs the one before.
    Widget? change;
    if (item.lastPrice > 0 && item.previousPrice > 0) {
      final diff = item.lastPrice - item.previousPrice;
      if (diff != 0) {
        change = Text(
          '${diff > 0 ? '▲' : '▼'} ${_taka(diff.abs())}',
          style: TextStyle(
            fontSize: 12,
            color: diff > 0 ? AppColors.error : AppColors.success,
          ),
        );
      }
    }

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => provider.deleteItem(item),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: () => _enterPrice(item),
          leading: Icon(
            item.isBought ? Icons.check_circle : Icons.radio_button_unchecked,
            color: item.isBought ? AppColors.success : null,
          ),
          title: Text(
            item.name,
            style: item.isBought
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: subtitle.isEmpty ? null : Text(subtitle),
          trailing: item.isBought
              ? Text(
                  _taka(item.currentPrice!),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : change,
        ),
      ),
    );
  }
}

/// Asks for the price paid (and quantity) for one item. Pops with
/// `(price, quantity)`, or null when cancelled.
///
/// The controllers live in this State so they are disposed only after the
/// dialog's closing animation, when its TextFields are gone.
class _PriceDialog extends StatefulWidget {
  final BazarItem item;

  const _PriceDialog({required this.item});

  @override
  State<_PriceDialog> createState() => _PriceDialogState();
}

class _PriceDialogState extends State<_PriceDialog> {
  late final _price = TextEditingController(
    text: widget.item.lastPrice > 0 ? '${widget.item.lastPrice}' : '',
  );
  late final _qty = TextEditingController(text: widget.item.quantity);

  @override
  void dispose() {
    _price.dispose();
    _qty.dispose();
    super.dispose();
  }

  void _save() {
    final value = int.tryParse(_price.text.trim());
    if (value == null || value <= 0) return;
    Navigator.pop(context, (value, _qty.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return AlertDialog(
      title: Text(item.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _price,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'bazar_price_paid'.tr,
              prefixText: '৳ ',
              helperText: item.lastPrice > 0
                  ? '${'bazar_last_time'.tr}: ${_taka(item.lastPrice)}'
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _qty,
            decoration: InputDecoration(
              labelText: 'bazar_quantity'.tr,
              hintText: 'bazar_quantity_hint'.tr,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr),
        ),
        TextButton(onPressed: _save, child: Text('save'.tr)),
      ],
    );
  }
}
