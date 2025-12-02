import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class MonthPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const MonthPickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildMonthGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _selectedYear > widget.firstDate.year
              ? () {
                  setState(() {
                    _selectedYear--;
                  });
                }
              : null,
        ),
        Text("$_selectedYear", style: Theme.of(context).textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _selectedYear < widget.lastDate.year
              ? () {
                  setState(() {
                    _selectedYear++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildMonthGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final monthIndex = index + 1;
        final isSelected =
            _selectedYear == widget.initialDate.year &&
            monthIndex == _selectedMonth;
        // Check if month is within range
        final isBeforeFirstDate =
            _selectedYear == widget.firstDate.year &&
            monthIndex < widget.firstDate.month;
        final isAfterLastDate =
            _selectedYear == widget.lastDate.year &&
            monthIndex > widget.lastDate.month;
        final isDisabled = isBeforeFirstDate || isAfterLastDate;

        return InkWell(
          onTap: isDisabled
              ? null
              : () {
                  Navigator.pop(context, DateTime(_selectedYear, monthIndex));
                },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.textMuted.withValues(alpha: 0.2),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              DateFormat('MMM').format(DateTime(2024, monthIndex)),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isDisabled
                    ? AppColors.textMuted.withValues(alpha: 0.5)
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
