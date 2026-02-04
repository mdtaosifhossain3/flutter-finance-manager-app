import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/savings_goal_model.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddSavingsGoalDialog {
  static void show(BuildContext context, {SavingsGoal? goal}) {
    Get.dialog(
      _AddSavingsGoalDialogContent(goal: goal),
      barrierDismissible: false,
    );
  }
}

class _AddSavingsGoalDialogContent extends StatefulWidget {
  final SavingsGoal? goal;

  const _AddSavingsGoalDialogContent({this.goal});

  @override
  State<_AddSavingsGoalDialogContent> createState() =>
      _AddSavingsGoalDialogContentState();
}

class _AddSavingsGoalDialogContentState
    extends State<_AddSavingsGoalDialogContent> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal?.name ?? '');
    _amountController = TextEditingController(
      text: widget.goal?.targetAmount.toString() ?? '',
    );
    _selectedDate =
        widget.goal?.startDate ?? DateTime.now().toString().split(' ')[0];
    _dateController = TextEditingController(
      text: HelperFunctions.getFormattedDate(DateTime.parse(_selectedDate!)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null
          ? DateTime.parse(_selectedDate!)
          : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 5),
      ), // Allow future dates for goals
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked.toString().split(' ')[0];
        _dateController.text = HelperFunctions.getFormattedDate(
          DateTime.parse(_selectedDate!),
        );
      });
    }
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = context.read<SavingsProvider>();
      final name = _nameController.text.trim();
      final amount = double.parse(_amountController.text.trim());
      final date = _selectedDate!;

      if (widget.goal != null) {
        await provider.updateGoal(
          id: widget.goal!.id,
          name: name,
          targetAmount: amount,
          startDate: date,
        );
        if (mounted) {
          Get.back();
          Get.snackbar(
            'Success',
            'goalUpdated'.tr,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        }
      } else {
        await provider.createGoal(
          name: name,
          targetAmount: amount,
          startDate: date,
        );
        if (mounted) {
          Get.back();
          Get.snackbar(
            'Success',
            'goalCreated'.tr,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          e.toString(),
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primaryBlue;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Goal Name Field
                _buildLabel('goalName'.tr, isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _buildInputDecoration(
                    hint: 'enterGoalName'.tr,
                    icon: Icons.label_outline,
                    isDark: isDark,
                    primaryColor: primaryColor,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'goalNameRequired'.tr;
                    }
                    if (value!.length < 2) return 'goalNameTooShort'.tr;
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Target Amount Field
                _buildLabel('targetAmount'.tr, isDark),
                const SizedBox(height: 8),
                TextFormField(
                  autofocus: true,
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _buildInputDecoration(
                    hint: '0.00',
                    // icon: Icons.attach_money,
                    isDark: isDark,
                    primaryColor: primaryColor,
                    prefixText: '৳ ',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'amountRequired'.tr;
                    }
                    final amount = double.tryParse(value!);
                    if (amount == null) return 'invalidAmount'.tr;
                    if (amount <= 0) return 'amountMustBePositive'.tr;
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Start Date Field
                _buildLabel('startDate'.tr, isDark),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _dateController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: _buildInputDecoration(
                        hint: 'selectDate'.tr,
                        icon: Icons.calendar_today_outlined,
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'dateRequired'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isLoading ? null : () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveGoal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.goal != null ? 'update'.tr : 'create'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
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

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    IconData? icon,
    required bool isDark,
    required Color primaryColor,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black38),
      prefixIcon: icon != null
          ? Icon(
              icon,
              color: isDark ? Colors.white54 : Colors.black45,
              size: 20,
            )
          : null,
      prefixText: prefixText,
      prefixStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      filled: true,
      fillColor: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.grey.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.error.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
