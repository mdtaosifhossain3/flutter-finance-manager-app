

import 'package:flutter/material.dart';

import '../config/enums/enums.dart';
import '../config/myColors/app_colors.dart';
import '../models/tempm/categoryModel/transaction_model.dart';
import '../utils/helper_functions.dart';

class CardWidget extends StatefulWidget {
  final TransactionModel transaction;
  const CardWidget({super.key, required this.transaction});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){_showTransactionDetails(widget.transaction);},
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color:Color(widget.transaction.iconBgColor),
                  //  borderRadius: BorderRadius.circular(12),
                  shape: BoxShape.circle
              ),
              child: Icon(widget.transaction.icon,color: Colors.white,),
            ),

            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.categoryName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    HelperFunctions.getFormattedDateTime(widget.transaction.date),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Text(
              '${widget.transaction.type == TransactionType.expense ?"-":""}৳${widget.transaction.amount}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: widget.transaction.type == TransactionType.expense ? AppColors.error:AppColors.lightTextMuted),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(TransactionModel transaction) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Transaction Details',
                    style: Theme.of(context).textTheme.headlineSmall
                ),
                Row(children: [

                  InkWell(
                    onTap: (){},
                    child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),),
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error
                        ,
                        size: 20,
                      ),
                    ),),

                ],)
              ],
            ),
            SizedBox(height: 20),
            _buildDetailRow('Category', transaction.categoryName),

            _buildDetailRow('Title', transaction.title),
            _buildDetailRow('Amount', '৳${transaction.amount.abs().toStringAsFixed(2)}'),
            _buildDetailRow('Date', HelperFunctions.formatDate(transaction.date)),
            if (transaction.notes != null)
              _buildDetailRow('Notes', transaction.notes!),

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
}
