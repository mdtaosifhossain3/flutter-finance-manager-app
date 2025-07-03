import 'package:finance_manager_app/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:get/route_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _selectedPeriod = 'Monthly';

  List screens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildBalanceCard(),
            const SizedBox(height: 20),
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
                    _buildPeriodSelector(),
                    const SizedBox(height: 20),
                    _buildTransactionsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi, Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '30% Of Your Expenses, Looks Good.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutesName.notificationView);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.lightGreen,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      color: MyColors.cyprus,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$7,783.00',
                    style: TextStyle(
                      color: MyColors.cyprus,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Expense',
                    style: TextStyle(
                      color: MyColors.cyprus,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '-\$1,187.40',
                    style: TextStyle(
                      color: MyColors.oceanBlue,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.white,
              color: MyColors.carbbeanGreen,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '30%',
                style: TextStyle(
                  color: MyColors.cyprus,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$20,000.00',
                style: TextStyle(
                  color: MyColors.cyprus,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Daily', 'Weekly', 'Monthly'].map((period) {
          final isSelected = period == _selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? MyColors.carbbeanGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : MyColors.cyprus,
                    fontFamily: 'Poppins',
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Expanded(
      child: ListView(
        children: [
          _buildTransactionItem(
            'Salary',
            '18:27 - April 30',
            'Monthly',
            '\$4,000.00',
            Icons.account_balance_wallet,
            isIncome: true,
          ),
          _buildTransactionItem(
            'Groceries',
            '17:00 - April 24',
            'Pantry',
            '-\$100.00',
            Icons.shopping_basket,
          ),
          _buildTransactionItem(
            'Rent',
            '8:30 - April 15',
            'Rent',
            '-\$674.40',
            Icons.home,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String category,
    String amount,
    IconData icon, {
    bool isIncome = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome ? MyColors.carbbeanGreen : MyColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isIncome ? MyColors.carbbeanGreen : Colors.red,
                ),
              ),
              Text(
                category,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
