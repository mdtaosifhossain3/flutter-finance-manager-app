// Renders the premium screens on a small phone (320 x 568) in English and
// Bangla with sample data. Any overflow or layout exception fails the test.
import 'package:finance_manager_app/config/db/local/category_db/add_transaction_db_helper.dart';
import 'package:finance_manager_app/config/translator/app_translator.dart';
import 'package:finance_manager_app/data/festival/festival_templates.dart';
import 'package:finance_manager_app/models/bazarModel/bazar_item_model.dart';
import 'package:finance_manager_app/models/recurringModel/recurring_item_model.dart';
import 'package:finance_manager_app/models/walletModel/wallet_models.dart';
import 'package:finance_manager_app/providers/bazarProvider/bazar_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:finance_manager_app/providers/recurringProvider/recurring_provider.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/providers/walletProvider/wallet_provider.dart';
import 'package:finance_manager_app/services/insights/insights_service.dart';
import 'package:finance_manager_app/services/insights/streak_service.dart';
import 'package:finance_manager_app/services/recurring/recurring_schedule.dart';
import 'package:finance_manager_app/views/bazarView/bazar_list_view.dart';
import 'package:finance_manager_app/views/festivalView/festival_planner_view.dart';
import 'package:finance_manager_app/views/insightsView/insights_view.dart';
import 'package:finance_manager_app/views/recurringView/recurring_view.dart';
import 'package:finance_manager_app/views/smsImportView/sms_import_view.dart';
import 'package:finance_manager_app/views/walletView/wallet_view.dart';
import 'package:finance_manager_app/views/zakatView/zakat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _now = DateTime.now();

class FakeWalletProvider extends WalletProvider {
  @override
  List<WalletBalance> get wallets => [
    for (final w in allWallets)
      WalletBalance(
        info: w,
        opening: 1250000,
        income: 98765,
        expense: 1234567,
        transferIn: 5000,
        transferOut: 2000,
      ),
  ];

  @override
  List<WalletTransfer> get transfers => [
    WalletTransfer(
      id: 1,
      fromMethod: 'bankTransfer',
      toMethod: 'mobileWallet',
      amount: 1500000,
      fee: 27750,
      date: _now,
    ),
  ];

  @override
  Future<void> load() async {}

  @override
  Future<double> cashOutRate(String method) async => 1.85;
}

class FakeFewWalletsProvider extends FakeWalletProvider {
  @override
  List<WalletBalance> get wallets => [
    WalletBalance(info: allWallets.first, opening: 500),
  ];
}

class FakeBazarProvider extends BazarProvider {
  final _list = [
    BazarItem(
      id: 1,
      name: 'Miniket chal (premium quality rice)',
      quantity: '25 kg bosta',
      lastPrice: 1850,
      previousPrice: 1700,
      updatedAt: _now,
    ),
    BazarItem(
      id: 2,
      name: 'পেঁয়াজ',
      quantity: '৫ কেজি',
      lastPrice: 450,
      previousPrice: 600,
      currentPrice: 400,
      updatedAt: _now,
    ),
    BazarItem(id: 3, name: 'Dim', updatedAt: _now),
  ];

  @override
  List<BazarItem> get items => _list;
  @override
  List<BazarItem> get boughtItems => _list.where((i) => i.isBought).toList();
  @override
  int get tripTotal => 400;
  @override
  Future<void> loadItems() async {}
}

class FakeRecurringProvider extends RecurringProvider {
  @override
  List<RecurringItem> get items => [
    RecurringItem(
      id: 1,
      title: 'বাসা ভাড়া — মিরপুর ১০, ৩য় তলা ফ্ল্যাট',
      amount: 2500000,
      isIncome: false,
      categoryKey: 'housing',
      paymentMethod: 'bankTransfer',
      frequency: RecurringFrequency.monthly,
      day: 31,
      nextDate: _now,
      autoAdd: true,
    ),
    RecurringItem(
      id: 2,
      title: 'Salary',
      amount: 9500000,
      isIncome: true,
      categoryKey: 'salary',
      paymentMethod: 'bankTransfer',
      frequency: RecurringFrequency.weekly,
      day: 3,
      nextDate: _now,
    ),
  ];

  @override
  int get monthlyBills => 2500000;
  @override
  Future<void> load() async {}
}

Widget _app(Widget home, Locale locale, {WalletProvider? wallets}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AddExpenseProvider(
          addTransactionDbHelper: AddTransactionDbHelper.getInstance,
        ),
      ),
      ChangeNotifierProvider<WalletProvider>(
        create: (_) => wallets ?? FakeWalletProvider(),
      ),
      ChangeNotifierProvider<BazarProvider>(create: (_) => FakeBazarProvider()),
      ChangeNotifierProvider<RecurringProvider>(
        create: (_) => FakeRecurringProvider(),
      ),
      ChangeNotifierProvider(create: (_) => GivenTakenProvider()),
      ChangeNotifierProvider(create: (_) => SavingsProvider()),
    ],
    child: GetMaterialApp(
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),
      home: home,
    ),
  );
}

const _locales = [Locale('en', 'US'), Locale('bn', 'BD')];

Future<void> _pump(WidgetTester tester, Widget screen, Locale locale) async {
  tester.view.physicalSize = const Size(320 * 3, 568 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_app(screen, locale));
  await tester.pump(const Duration(milliseconds: 300));
}

InsightsData _sampleInsights() {
  const stats = StreakStats(
    currentStreak: 128,
    bestStreak: 365,
    loggedToday: false,
    noSpendDays: 12,
    totalEntries: 1234,
  );
  return InsightsData(
    streak: stats,
    insights: const [
      Insight('insight_spent_more', {
        'percent': '122',
        'amount': '1234567',
      }, InsightTone.warning),
      Insight('insight_top_category', {
        'category': 'office_supplies_equipment',
        'amount': '9876543',
        'percent': '87',
      }, InsightTone.neutral),
      Insight('insight_busiest_day', {'day': 'weekday_4'}, InsightTone.neutral),
      Insight('insight_projection_over', {
        'amount': '12345678',
        'over': '2345678',
      }, InsightTone.warning),
      Insight('insight_saved', {
        'amount': '123456',
        'percent': '12',
      }, InsightTone.good),
    ],
    badges: StreakService.badges(stats, spentLessThanLastMonth: true),
    spent: 9876543,
    income: 12345678,
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final locale in _locales) {
    group('${locale.languageCode}:', () {
      testWidgets('Insights with data and when loading fails', (tester) async {
        InsightsView.loader = () async => _sampleInsights();
        await _pump(tester, const InsightsView(), locale);
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, -2000));
        await tester.pump();

        InsightsView.loader = () => Future.error('no db');
        await _pump(tester, const InsightsView(key: ValueKey(2)), locale);
        await tester.pumpAndSettle();
        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets('Zakat calculator', (tester) async {
        await _pump(tester, const ZakatView(), locale);
        await tester.enterText(find.byType(TextField).first, '99999999');
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -3000));
        await tester.pump();
      });

      testWidgets('Festival planner and every template', (tester) async {
        await _pump(tester, const FestivalPlannerView(), locale);
        for (final t in festivalTemplates) {
          await _pump(tester, FestivalPlanEditView(template: t), locale);
          await tester.drag(find.byType(ListView), const Offset(0, -2000));
          await tester.pump();
        }
      });

      testWidgets('Bazar list with items and price dialog', (tester) async {
        await _pump(tester, const BazarListView(), locale);
        // Items sit below the add field and chips on a small screen.
        await tester.scrollUntilVisible(
          find.byType(ListTile),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);
        await tester.tap(find.byType(TextButton).first);
        await tester.pumpAndSettle();
      });

      testWidgets('Wallets, add wallet sheet and transfer sheet', (
        tester,
      ) async {
        await _pump(tester, const WalletView(), locale);
        await tester.drag(find.byType(ListView), const Offset(0, -3000));
        await tester.pump();

        // Balance dialog
        await tester.drag(find.byType(ListView), const Offset(0, 3000));
        await tester.pump();
        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(TextButton).at(1));
        await tester.pumpAndSettle();

        // Transfer sheet, then swap the wallets
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).first, '25000');
        await tester.pump();
        await tester.tap(find.byIcon(Icons.swap_horiz).last);
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.swap_horiz).last);
        await tester.pumpAndSettle();
      });

      testWidgets('Add wallet sheet', (tester) async {
        tester.view.physicalSize = const Size(320 * 3, 568 * 3);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          _app(const WalletView(), locale, wallets: FakeFewWalletsProvider()),
        );
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.byIcon(Icons.add_card));
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsOneWidget);
        await tester.drag(find.byType(BottomSheet), const Offset(0, -500));
        await tester.pumpAndSettle();
      });

      testWidgets('Bills list, form and due dialog', (tester) async {
        await _pump(tester, const RecurringView(), locale);
        await _pump(tester, const RecurringFormView(), locale);
        await tester.tap(find.byType(ActionChip).at(5)); // school fee
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, -2000));
        await tester.pump();
        await _pump(
          tester,
          RecurringFormView(item: FakeRecurringProvider().items.first),
          locale,
        );

        await _pump(tester, const SizedBox(), locale);
        final items = FakeRecurringProvider().items;
        showDueRecurringDialog([
          PendingRecurring(items[0], [_now]),
          PendingRecurring(items[1], [_now, _now, _now]),
        ]);
        await tester.pumpAndSettle();
      });

      testWidgets('SMS import with every kind of message', (tester) async {
        await _pump(
          tester,
          const SmsImportView(
            initialText:
                'You have received Tk 1,500.00 from 01712345678. Fee Tk 0.00. TrxID BJT8K2M1QX at 28/10/2026 19:42\n\n'
                'Cash Out Tk 20,000.00 to 01812345678 successful. Fee Tk 370.00. TrxID BJT9A1B2C3 at 29/10/2026 10:05\n\n'
                'Payment Tk 250.00 to Shwapno Super Shop Dhanmondi Branch successful. TrxID BJT0000002 at 29/10/2026 12:00\n\n'
                'Your A/C XXXX1234 is credited with BDT 45,000.00 on 01-10-2026.',
          ),
          locale,
        );
        await tester.pumpAndSettle();
        // Drag from the top: a drag on the SMS text box scrolls the box.
        for (
          var i = 0;
          i < 6 && find.byType(Checkbox).evaluate().isEmpty;
          i++
        ) {
          await tester.dragFrom(const Offset(160, 100), const Offset(0, -300));
          await tester.pumpAndSettle();
        }
        expect(find.byType(Checkbox), findsWidgets);
        for (var i = 0; i < 10; i++) {
          await tester.dragFrom(const Offset(160, 100), const Offset(0, -300));
          await tester.pump();
        }
        expect(find.byType(Checkbox), findsWidgets);
        await tester.drag(find.byType(ListView), const Offset(0, -3000));
        await tester.pump();
      });
    });
  }
}
