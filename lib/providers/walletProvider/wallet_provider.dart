import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/db/local/wallet_db/wallet_db_helper.dart';
import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/models/walletModel/wallet_models.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/services/wallet/wallet_calculator.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletProvider with ChangeNotifier {
  final WalletDbHelper _db = WalletDbHelper.getInstance;
  final AddTransactionDbHelper _txDb = AddTransactionDbHelper.getInstance;

  List<WalletBalance> _wallets = [];
  List<WalletTransfer> _transfers = [];
  Map<String, int> _openings = {};
  bool _isLoading = false;

  List<WalletBalance> get wallets => _wallets;
  List<WalletTransfer> get transfers => _transfers;
  bool get isLoading => _isLoading;
  int get total => _wallets.fold(0, (s, w) => s + w.balance);

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _openings = await _db.getOpenings();
      _transfers = await _db.getTransfers();
      final rows = await _txDb.getAllNotes();
      _wallets = WalletCalculator.balances(
        openings: _openings,
        transactions: rows.map(TransactionModel.fromMap).toList(),
        transfers: _transfers,
      );
    } catch (e) {
      debugPrint('WalletProvider.load: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sets the opening balance so the wallet shows [actualBalance] now.
  Future<void> setCurrentBalance(WalletBalance wallet, int actualBalance) async {
    await _db.setOpening(
      wallet.info.method,
      WalletCalculator.openingFor(wallet, actualBalance),
    );
    await load();
  }

  Future<void> addWallet(String method) async {
    if (_wallets.any((w) => w.info.method == method)) return;
    await _db.setOpening(method, 0);
    // Keep the default wallets visible once the user starts customizing.
    for (final m in defaultWalletMethods) {
      if (!_openings.containsKey(m)) await _db.setOpening(m, 0);
    }
    await load();
  }

  Future<void> removeWallet(String method) async {
    await _db.removeWallet(method);
    await load();
  }

  Future<double> cashOutRate(String method) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('cash_out_rate_$method') ??
        WalletCalculator.defaultCashOutRates[method] ??
        0;
  }

  Future<void> saveCashOutRate(String method, double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('cash_out_rate_$method', rate);
  }

  /// Saves a transfer. A [fee] is also saved as an expense from the source
  /// wallet, so it shows up in reports.
  Future<void> addTransfer({
    required String from,
    required String to,
    required int amount,
    int fee = 0,
    DateTime? date,
    String note = '',
    AddExpenseProvider? txProvider,
  }) async {
    final when = date ?? DateTime.now();
    int? feeTxId;
    if (fee > 0) {
      final misc = categoryItems.firstWhere(
        (c) => c.key == 'miscellaneous_expense',
      );
      feeTxId = await _txDb.insertItem(
        TransactionModel(
          type: TransactionType.expense,
          date: when,
          title: '${'transfer_fee'.tr} (${from.tr})',
          amount: fee,
          notes: note,
          paymentMethod: from,
          icon: misc.icon,
          iconBgColor: misc.color.toARGB32(),
          categoryKey: misc.key,
        ),
      );
    }
    await _db.addTransfer(
      WalletTransfer(
        fromMethod: from,
        toMethod: to,
        amount: amount,
        fee: fee,
        feeTransactionId: feeTxId,
        date: when,
        note: note,
      ),
    );
    if (feeTxId != null) {
      await txProvider?.getTransactionsForMonth(txProvider.currentMonth);
    }
    await load();
  }

  Future<void> deleteTransfer(
    WalletTransfer t, {
    AddExpenseProvider? txProvider,
  }) async {
    await _db.deleteTransfer(t.id!);
    if (t.feeTransactionId != null) {
      await _txDb.deleteItem(t.feeTransactionId!);
      await txProvider?.getTransactionsForMonth(txProvider.currentMonth);
    }
    await load();
  }

  Future<void> deleteFull() async {
    await _db.deleteFull();
    _wallets = [];
    _transfers = [];
    _openings = {};
    notifyListeners();
  }
}
