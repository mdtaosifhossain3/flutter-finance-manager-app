import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/models/walletModel/wallet_models.dart';

class WalletCalculator {
  /// Cash-out charge (percent) suggested per wallet. Users can change it,
  /// since providers change their rates.
  static const Map<String, double> defaultCashOutRates = {
    'bkash': 1.85,
    'nagad': 1.49,
    'rocket': 1.8,
    'upay': 1.4,
  };

  static int cashOutFee(int amount, double ratePercent) =>
      (amount * ratePercent / 100).round();

  /// Balances for the wallets in [openings] plus any wallet that has
  /// activity, in the order of [allWallets].
  static List<WalletBalance> balances({
    required Map<String, int> openings,
    required List<TransactionModel> transactions,
    required List<WalletTransfer> transfers,
  }) {
    final income = <String, int>{};
    final expense = <String, int>{};
    final tIn = <String, int>{};
    final tOut = <String, int>{};

    for (final t in transactions) {
      final map = t.type == TransactionType.income ? income : expense;
      map[t.paymentMethod] = (map[t.paymentMethod] ?? 0) + t.amount;
    }
    for (final t in transfers) {
      tOut[t.fromMethod] = (tOut[t.fromMethod] ?? 0) + t.amount;
      tIn[t.toMethod] = (tIn[t.toMethod] ?? 0) + t.amount;
    }

    final used = {
      ...openings.keys,
      ...income.keys,
      ...expense.keys,
      ...tIn.keys,
      ...tOut.keys,
    };
    if (used.isEmpty) used.addAll(defaultWalletMethods);

    final known = allWallets.map((w) => w.method).toList();
    final ordered = used.toList()
      ..sort((a, b) {
        final ia = known.indexOf(a), ib = known.indexOf(b);
        return (ia < 0 ? 99 : ia).compareTo(ib < 0 ? 99 : ib);
      });

    return [
      for (final m in ordered)
        WalletBalance(
          info: walletInfo(m),
          opening: openings[m] ?? 0,
          income: income[m] ?? 0,
          expense: expense[m] ?? 0,
          transferIn: tIn[m] ?? 0,
          transferOut: tOut[m] ?? 0,
        ),
    ];
  }

  /// Opening balance that makes [wallet] show [actualBalance] now.
  static int openingFor(WalletBalance wallet, int actualBalance) =>
      actualBalance - (wallet.balance - wallet.opening);
}
