import 'package:finance_manager_app/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/myColors/my_colors.dart';

class PeriodSelectorWidget extends StatefulWidget {
  const PeriodSelectorWidget({super.key});

  @override
  State<PeriodSelectorWidget> createState() => _PeriodSelectorWidgetState();
}

class _PeriodSelectorWidgetState extends State<PeriodSelectorWidget> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Daily', 'Weekly', 'Monthly'].map((period) {
          final isSelected = period == context.watch<HomeViewProvider>().selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<HomeViewProvider>().updateSelectedPeriod(period),
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
}
