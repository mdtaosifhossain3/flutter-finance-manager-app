import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:flutter/material.dart';

class BalanceExpenseCardWidget extends StatelessWidget {
  final Color? bgColor;
  final Color? totalBTColor;
  final Color? totalETColor;
  final Color? textColor;
  final Color? iconColor;


  const BalanceExpenseCardWidget({
    super.key,this.bgColor,this.totalBTColor,this.totalETColor,this.textColor, this.iconColor,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildBalanceCard(
            title: 'Total Balance',
            amount: '৳ 7,783.00',
            icon: Icons.account_balance_wallet_outlined,
            amountColor: totalBTColor ?? MyColors.honeyDew,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildBalanceCard(
           title: 'Total Expense',
            amount: '৳ 1,187.40',
            icon:Icons.trending_up,
            amountColor: totalETColor ?? MyColors.honeyDew,
          ),
        ),
      ],
    );
  }
  Widget _buildBalanceCard({ required String title, required String  amount, required IconData icon, required Color amountColor }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:bgColor ?? Colors.white.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color:iconColor ?? MyColors.honeyDew, size: 16),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(color:textColor ?? MyColors.honeyDew, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
