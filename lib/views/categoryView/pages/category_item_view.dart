import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/card_widget.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/category/category_item_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/categoryView/pages/transaction_form_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../config/enums/enums.dart';
import '../../../models/categoryModel/transaction_model.dart';

class CategoryItemView extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;

  const CategoryItemView({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  State<CategoryItemView> createState() =>
      _CategoryTransactionViewState();
}

class _CategoryTransactionViewState extends State<CategoryItemView> {
  List<TransactionModel> transactionModel = [];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryItemProvider>();
    List<TransactionModel> transactionModel = provider.filteredTransactions(
      selectedCategory: widget.categoryName,
    );

    return Scaffold(
      appBar: customAppBar(title: widget.categoryName,leading: Padding(
        padding: const EdgeInsets.only(left:10.0),
        child: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back)),
      )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header
            _buildCategoryHeader(transactionModel, provider),

            // Month Selector
            _buildMonthSelector(provider),

            // Transactions Header
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'transactions'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            // Transaction List
            _buildTransactionListView(transactionModel),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildCategoryHeader( tx, provider) {
    final totalAmount = tx.fold(
      0,
      (sum, transaction) => sum + transaction.amount,
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 16,
      ),
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
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
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
                  border: Border.all(color: Theme.of(context).dividerColor),
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
                    // Text(
                    //   '${_getMonthName(provider.selectedMonth.month)} ${provider.selectedMonth.year}',
                    //   style: Theme.of(context).textTheme.labelSmall,
                    // ),
                  //  SizedBox(height: 4),
                    Text(
                      'totalAmount'.tr,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(height: 6),
                    Text(
                      HelperFunctions.convertToBanglaDigits(totalAmount.toString()),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),

              // Transaction Count Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.2),
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
                      HelperFunctions.convertToBanglaDigits(tx.length.toString()),
                      style: Theme.of(context).textTheme.labelLarge,
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

  Widget _buildMonthSelector(provider) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 12,
        itemBuilder: (context, index) {
          DateTime month = DateTime(
            DateTime.now().year,
            DateTime.now().month - 6 + index,
          );
          bool isSelected =
              month.month == provider.selectedMonth.month &&
              month.year == provider.selectedMonth.year;
          bool isCurrentMonth =
              month.month == DateTime.now().month &&
              month.year == DateTime.now().year;

          return GestureDetector(
            onTap: () {
              provider.setSelectedMonth(month);
            },
            child: Container(
              width: 70,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
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
                    _getMonthName(month.month),
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    month.year.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
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

  Widget _buildTransactionListView(transactionModel) {
    if (transactionModel.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              SizedBox(height: 16),
              Text(
                'noTransactions'.tr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                'addFirstTransaction'.tr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: transactionModel.length,
        itemBuilder: (context, index) {
          final transaction = transactionModel[index];
          return CardWidget(transaction: transaction);
        },
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.to(
          TransactionFormPage(
            categoryColor: widget.categoryColor,
            categoryIcon: widget.categoryIcon,
            categoryName: widget.categoryName,
          ),
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      icon: Icon(Icons.add, color: AppColors.textPrimary),
      label: Text(
        "addTransaction".tr,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    final locale = Get.locale?.languageCode ?? 'en';
    if (locale == 'bn') {
      const months = [
        'জানুয়ারি',
        'ফেব্রুয়ারি',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টেম্বর',
        'অক্টোবর',
        'নভেম্বর',
        'ডিসেম্বর'
      ];
      return months[month - 1];
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return months[month - 1];    }

  }
}
