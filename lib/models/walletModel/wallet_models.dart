import 'package:flutter/material.dart';

/// A wallet is one payment method (cash, bKash, bank…). Transactions already
/// store their payment method, so a wallet's balance is its opening balance
/// plus income minus expenses in that method, plus transfers.
class WalletInfo {
  final String method;
  final IconData icon;
  final Color color;

  const WalletInfo(this.method, this.icon, this.color);

  bool get isMobileWallet =>
      const {'bkash', 'nagad', 'rocket', 'upay', 'mobileWallet'}.contains(
        method,
      );
}

/// Same keys as the payment methods on the transaction form.
const List<WalletInfo> allWallets = [
  WalletInfo('cash', Icons.payments_outlined, Color(0xFF10B981)),
  WalletInfo('bkash', Icons.phone_android, Color(0xFFE2136E)),
  WalletInfo('nagad', Icons.phone_android, Color(0xFFF7941D)),
  WalletInfo('rocket', Icons.phone_android, Color(0xFF8C3494)),
  WalletInfo('upay', Icons.phone_android, Color(0xFF0D6EFD)),
  WalletInfo('bankTransfer', Icons.account_balance_outlined, Color(0xFF2563EB)),
  WalletInfo('debitCard', Icons.credit_card, Color(0xFF0891B2)),
  WalletInfo('creditCard', Icons.credit_card, Color(0xFF7C3AED)),
  WalletInfo('mobileWallet', Icons.account_balance_wallet_outlined, Color(0xFF64748B)),
  WalletInfo('check', Icons.receipt_long_outlined, Color(0xFF78716C)),
];

/// Shown even before the user has touched them.
const defaultWalletMethods = ['cash', 'bkash', 'nagad'];

WalletInfo walletInfo(String method) => allWallets.firstWhere(
  (w) => w.method == method,
  orElse: () => WalletInfo(method, Icons.account_balance_wallet_outlined, const Color(0xFF64748B)),
);

/// Money moved between two of the user's own wallets (cash out, cash in,
/// ATM withdrawal…). Not income or expense. A fee is saved separately as an
/// expense transaction, whose id is kept in [feeTransactionId].
class WalletTransfer {
  final int? id;
  final String fromMethod;
  final String toMethod;
  final int amount;
  final int fee;
  final int? feeTransactionId;
  final DateTime date;
  final String note;

  const WalletTransfer({
    this.id,
    required this.fromMethod,
    required this.toMethod,
    required this.amount,
    this.fee = 0,
    this.feeTransactionId,
    required this.date,
    this.note = '',
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'from_method': fromMethod,
    'to_method': toMethod,
    'amount': amount,
    'fee': fee,
    'fee_tx_id': feeTransactionId,
    'date': date.toIso8601String(),
    'note': note,
  };

  factory WalletTransfer.fromMap(Map<String, dynamic> m) => WalletTransfer(
    id: m['id'] as int?,
    fromMethod: m['from_method'] as String,
    toMethod: m['to_method'] as String,
    amount: m['amount'] as int,
    fee: m['fee'] as int? ?? 0,
    feeTransactionId: m['fee_tx_id'] as int?,
    date: DateTime.parse(m['date'] as String),
    note: m['note'] as String? ?? '',
  );
}

class WalletBalance {
  final WalletInfo info;
  final int opening;
  final int income;
  final int expense;
  final int transferIn;
  final int transferOut;

  const WalletBalance({
    required this.info,
    required this.opening,
    this.income = 0,
    this.expense = 0,
    this.transferIn = 0,
    this.transferOut = 0,
  });

  int get balance => opening + income - expense + transferIn - transferOut;
}
