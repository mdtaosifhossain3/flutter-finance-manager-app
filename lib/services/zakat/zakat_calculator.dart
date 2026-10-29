/// Zakat on wealth held for a lunar year. Gold and silver are entered in
/// bhori (1 bhori = 1 tola = 11.664 g), the unit used in Bangladesh.
class ZakatInput {
  final double cash;
  final double bank;
  final double mobileWallet;
  final double goldBhori;
  final double goldPricePerBhori;
  final double silverBhori;
  final double silverPricePerBhori;
  final double receivables;
  final double businessStock;
  final double otherAssets;
  final double debts;

  const ZakatInput({
    this.cash = 0,
    this.bank = 0,
    this.mobileWallet = 0,
    this.goldBhori = 0,
    this.goldPricePerBhori = 0,
    this.silverBhori = 0,
    this.silverPricePerBhori = 0,
    this.receivables = 0,
    this.businessStock = 0,
    this.otherAssets = 0,
    this.debts = 0,
  });
}

class ZakatResult {
  final double totalAssets;
  final double netWealth;

  /// 0 when neither gold nor silver price is known.
  final double nisab;
  final bool isDue;
  final double zakat;

  const ZakatResult({
    required this.totalAssets,
    required this.netWealth,
    required this.nisab,
    required this.isDue,
    required this.zakat,
  });
}

class ZakatCalculator {
  static const double nisabGoldBhori = 7.5;
  static const double nisabSilverBhori = 52.5;
  static const double rate = 0.025;

  static ZakatResult calculate(ZakatInput i) {
    final total =
        i.cash +
        i.bank +
        i.mobileWallet +
        i.goldBhori * i.goldPricePerBhori +
        i.silverBhori * i.silverPricePerBhori +
        i.receivables +
        i.businessStock +
        i.otherAssets;
    final net = total - i.debts;

    // The silver nisab is lower, so it is used when the price is known
    // (the more cautious view, widely followed in Bangladesh).
    final nisab = i.silverPricePerBhori > 0
        ? nisabSilverBhori * i.silverPricePerBhori
        : nisabGoldBhori * i.goldPricePerBhori;

    final isDue = nisab > 0 && net >= nisab;
    return ZakatResult(
      totalAssets: total,
      netWealth: net,
      nisab: nisab,
      isDue: isDue,
      zakat: isDue ? net * rate : 0,
    );
  }
}
