import 'package:finance_manager_app/views/homeView/widgets/balance_card_widget.dart';
import 'package:finance_manager_app/views/homeView/widgets/header_widget.dart';
import 'package:finance_manager_app/views/homeView/widgets/period_selector_widget.dart';
import 'package:finance_manager_app/views/homeView/widgets/transaction_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<AddExpenseProvider>().getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            //Header
            HeaderWidget(),
            // Balance Card
            BalanceCardWidget(),
            const SizedBox(height: 20),
            // Transaction List
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: MyColors.honeyDew,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Period Selector
                    PeriodSelectorWidget(),
                    const SizedBox(height: 20),
                    TransactionListWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
