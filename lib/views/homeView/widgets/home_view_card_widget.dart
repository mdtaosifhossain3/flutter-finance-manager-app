import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/homeModel/home_model.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:finance_manager_app/views/categoryView/pages/category_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewCardWidget extends StatefulWidget {
  final CategorySummary transaction;
  const HomeViewCardWidget({super.key, required this.transaction});

  @override
  State<HomeViewCardWidget> createState() => _HomeViewCardWidgetState();
}

class _HomeViewCardWidgetState extends State<HomeViewCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: () => Get.to(
          () => CategoryItemView(
            categoryIcon: widget.transaction.icon,
            categoryColor: Color(widget.transaction.iconBgColor),
            categoryKey: widget.transaction.categoryName,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(widget.transaction.iconBgColor),
                //  borderRadius: BorderRadius.circular(12),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.transaction.icon, color: Colors.white),
            ),

            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.categoryName.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${HelperFunctions.convertToBanglaDigits(widget.transaction.count.toString())}${"totaltransactions".tr}",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Text(
              '${widget.transaction.type == TransactionType.expense ? "-" : ""}৳${HelperFunctions.convertToBanglaDigits(widget.transaction.total.toString())}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: widget.transaction.type == TransactionType.expense
                    ? AppColors.error
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
