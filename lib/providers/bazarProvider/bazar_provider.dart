import 'package:finance_manager_app/config/db/local/bazar_db/bazar_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/models/bazarModel/bazar_item_model.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BazarProvider with ChangeNotifier {
  final BazarDbHelper _db = BazarDbHelper.getInstance;

  List<BazarItem> _items = [];
  bool _isLoading = false;

  List<BazarItem> get items => _items;
  bool get isLoading => _isLoading;
  List<BazarItem> get boughtItems => _items.where((i) => i.isBought).toList();
  int get tripTotal =>
      boughtItems.fold(0, (sum, i) => sum + (i.currentPrice ?? 0));

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _db.getAllItems();
    } catch (e) {
      debugPrint('BazarProvider.loadItems: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String name, {String quantity = ''}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final exists = _items.any(
      (i) => i.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return;
    await _db.addItem(
      BazarItem(name: trimmed, quantity: quantity, updatedAt: DateTime.now()),
    );
    await loadItems();
  }

  Future<void> setPrice(BazarItem item, int? price, {String? quantity}) async {
    await _db.updateItem(
      BazarItem(
        id: item.id,
        name: item.name,
        quantity: quantity ?? item.quantity,
        lastPrice: item.lastPrice,
        previousPrice: item.previousPrice,
        currentPrice: price,
        updatedAt: DateTime.now(),
      ),
    );
    await loadItems();
  }

  Future<void> deleteItem(BazarItem item) async {
    // Remove right away: a swiped-away Dismissible must leave the tree now.
    _items = _items.where((i) => i.id != item.id).toList();
    notifyListeners();
    await _db.deleteItem(item.id!);
  }

  /// Saves the trip as one groceries expense and remembers the prices.
  Future<bool> finishTrip(AddExpenseProvider txProvider) async {
    final bought = boughtItems;
    if (bought.isEmpty) return false;

    final groceries = categoryItems.firstWhere((c) => c.key == 'groceries');
    final notes = bought
        .map((i) {
          final qty = i.quantity.isEmpty ? '' : ' (${i.quantity})';
          return '${i.name}$qty: ৳${i.currentPrice}';
        })
        .join('\n');

    await txProvider.addExpense(
      TransactionModel(
        type: TransactionType.expense,
        date: DateTime.now(),
        title: 'bazar_list'.tr,
        amount: tripTotal,
        notes: notes,
        paymentMethod: 'cash',
        icon: groceries.icon,
        iconBgColor: groceries.color.toARGB32(),
        categoryKey: groceries.key,
      ),
    );
    await _db.finishTrip();
    await loadItems();
    return true;
  }

  Future<void> deleteFull() async {
    await _db.deleteFull();
    _items = [];
    notifyListeners();
  }
}
