import 'package:finance_manager_app/config/myColors/my_colors.dart';
import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.bgProgressBar,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            '30%',
            style: TextStyle(
              color: MyColors.honeyDew,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: MyColors.bgProgressBarIndicator,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    color:  MyColors.honeyDew,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '৳20,000.00',
            style: TextStyle(
              color:  MyColors.honeyDew,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
