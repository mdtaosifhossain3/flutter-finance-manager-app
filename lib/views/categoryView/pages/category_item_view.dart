import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/category/expense_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/categoryView/pages/transaction_form_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoryTransactionView extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;

  const CategoryTransactionView({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  State<CategoryTransactionView> createState() => _CategoryTransactionViewState();
}

class _CategoryTransactionViewState extends State<CategoryTransactionView> {
  DateTime selectedMonth = DateTime.now();
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _generateSampleTransactions();
  }

  void _generateSampleTransactions() {
    // Sample transactions for different months
    transactions = [
      // Current month
      Transaction(
        id: '1',
        title: 'Weekly grocery shopping',
        amount: -85.50,
        date: DateTime.now().subtract(Duration(days: 2)),
        notes: 'Walmart - family groceries',
        tags: ['essentials', 'family'],
      ),
      Transaction(
        id: '2',
        title: 'Organic vegetables',
        amount: -32.75,
        date: DateTime.now().subtract(Duration(days: 5)),
        notes: 'Farmers market',
        tags: ['organic', 'healthy'],
      ),
      Transaction(
        id: '3',
        title: 'Cashback reward',
        amount: 12.50,
        date: DateTime.now().subtract(Duration(days: 8)),
        notes: 'Credit card cashback',
        tags: ['reward'],
      ),
      Transaction(
        id: '4',
        title: 'Monthly bulk shopping',
        amount: -156.30,
        date: DateTime.now().subtract(Duration(days: 10)),
        notes: 'Costco - bulk items',
        tags: ['bulk', 'savings'],
      ),
      Transaction(
        id: '5',
        title: 'Fresh fruits and snacks',
        amount: -28.90,
        date: DateTime.now().subtract(Duration(days: 15)),
        notes: 'Local grocery store',
        tags: ['fresh', 'snacks'],
      ),
      // Previous month
      Transaction(
        id: '6',
        title: 'Monthly grocery budget',
        amount: -245.80,
        date: DateTime(selectedMonth.year, selectedMonth.month - 1, 25),
        notes: 'Multiple stores',
        tags: ['monthly'],
      ),
    ];
  }

  List<Transaction> get filteredTransactions {
    return transactions.where((transaction) {
      return transaction.date.year == selectedMonth.year &&
          transaction.date.month == selectedMonth.month;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  double get totalAmount {
    return filteredTransactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalIncome {
    return filteredTransactions
        .where((t) => t.amount > 0)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses {
    return filteredTransactions
        .where((t) => t.amount < 0)
        .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());
  }

  double get netBalance {
    return totalIncome - totalExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: customAppBar(title: widget.categoryName),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Category Header
            _buildCategoryHeader(),

            // Month Selector
            _buildMonthSelector(),


            // Transactions Header
            _buildTransactionsHeader(),

            // Transaction List
            _buildTransactionListView(),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }
  Widget _buildCategoryHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.04,vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
           Theme.of(context).cardColor,
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Name with Icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).dividerColor)
                ),
                child: Icon(
                  widget.categoryIcon,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                widget.categoryName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          SizedBox(height: 20),

          // Monthly Total Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getMonthName(selectedMonth.month)} ${selectedMonth.year}',
                      style: Theme.of(context).textTheme.labelSmall
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.labelLarge
                    ),
                    SizedBox(height: 6),
                    Text(
                      totalAmount.abs().toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headlineLarge
                    ),
                  ],
                ),
              ),

              // Transaction Count Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '${filteredTransactions.length}',
                      style: Theme.of(context).textTheme.labelLarge
                    ),
                  ],
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
  Widget _buildMonthSelector() {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 12,
        itemBuilder: (context, index) {
          DateTime month = DateTime(DateTime.now().year, DateTime.now().month - 6 + index);
          bool isSelected = month.month == selectedMonth.month && month.year == selectedMonth.year;
          bool isCurrentMonth = month.month == DateTime.now().month && month.year == DateTime.now().year;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMonth = month;
              });
            },
            child: Container(
              width: 70,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCurrentMonth && !isSelected
                      ? Theme.of(context).dividerColor
                      : Theme.of(context).dividerColor,
                  width: 1,
                ),

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getMonthName(month.month).substring(0, 3),
                    style: TextStyle(
                      color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    month.year.toString(),
                    style: TextStyle(
                      color: isSelected ? AppColors.textPrimary :AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildTransactionsHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transactions',
            style: Theme.of(context).textTheme.headlineSmall
          ),
          Text(
            '${filteredTransactions.length} items',
            style: Theme.of(context).textTheme.labelMedium
          ),
        ],
      ),
    );
  }
  Widget _buildTransactionListView() {
    if (filteredTransactions.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color:Theme.of(context).colorScheme.onSecondary,
              ),
              SizedBox(height: 16),
              Text(
                'No transactions found',
                style:Theme.of(context).textTheme.bodyMedium
              ),
              SizedBox(height: 8),
              Text(
                'Add your first transaction to get started',
                style:Theme.of(context).textTheme.bodySmall
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filteredTransactions.map((transaction) => _buildTransactionCard(transaction)).toList(),
    );
  }
  Widget _buildTransactionCard(Transaction transaction) {
    bool isIncome = transaction.amount > 0;
    Color amountColor = isIncome ? Colors.green[600]! : Colors.red[600]!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTransactionDetails(transaction),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Amount Indicator
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: amountColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                //  child: Center(child: Text("1",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.textPrimary),)),
                ),
                SizedBox(width: 16),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: Theme.of(context).textTheme.titleMedium
                      ),
                      if (transaction.notes.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          transaction.notes,
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Amount and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isIncome ? '+' : '-'}\$${transaction.amount.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      HelperFunctions.getFormattedDateTime(transaction.date),
                      style: Theme.of(context).textTheme.labelSmall
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.to(TransactionFormPage(categoryColor: widget.categoryColor,categoryIcon: widget.categoryIcon,categoryName: widget.categoryName,));
     print(context.read<AddExpenseProvider>().expenseList);
        },
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      icon: Icon(Icons.add,color: AppColors.textPrimary),
      label: Text(
        'Add Transaction',
        style: TextStyle(fontWeight: FontWeight.w600,color: AppColors.textPrimary),
      ),
    );
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Transaction details
            Text(
              'Transaction Details',
              style: Theme.of(context).textTheme.headlineSmall
            ),
            SizedBox(height: 20),

            _buildDetailRow('Title', transaction.title),
            _buildDetailRow('Amount', '${transaction.amount > 0 ? '+' : '-'}\$${transaction.amount.abs().toStringAsFixed(2)}'),
            _buildDetailRow('Date', _formatFullDate(transaction.date)),
            if (transaction.notes.isNotEmpty)
              _buildDetailRow('Notes', transaction.notes),
            if (transaction.tags.isNotEmpty)
              _buildDetailRow('Tags', transaction.tags.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium
            ),
          ),
        ],
      ),
    );
  }



  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatFullDate(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String notes;
  final List<String> tags;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.notes = '',
    this.tags = const [],
  });
}

