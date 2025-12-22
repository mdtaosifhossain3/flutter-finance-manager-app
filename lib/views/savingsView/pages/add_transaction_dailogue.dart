import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/models/savings_goal_model.dart';
import 'package:finance_manager_app/models/savings_transaction_model.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddTransactionDialog {
  static void show(
    BuildContext context,
    SavingsGoal goal, {
    SavingsTransaction? transaction,
  }) {
    Get.dialog(
      _AddTransactionDialogContent(goal: goal, transaction: transaction),
      barrierDismissible: false,
    );
  }
}

class _AddTransactionDialogContent extends StatefulWidget {
  final SavingsGoal goal;
  final SavingsTransaction? transaction;

  const _AddTransactionDialogContent({required this.goal, this.transaction});

  @override
  State<_AddTransactionDialogContent> createState() =>
      _AddTransactionDialogContentState();
}

class _AddTransactionDialogContentState
    extends State<_AddTransactionDialogContent> {
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _noteController;

  bool _isAdd = true;
  String? _selectedDate;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final txn = widget.transaction;
    _amountController = TextEditingController(
      text: txn?.amount.toString() ?? '',
    );
    _selectedDate = txn?.date ?? DateTime.now().toString().split(' ')[0];
    _dateController = TextEditingController(
      text: HelperFunctions.getFormattedDate(DateTime.parse(_selectedDate!)),
    );
    _noteController = TextEditingController(text: txn?.note ?? '');
    _isAdd = txn != null ? txn.isAdd : true;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null
          ? DateTime.parse(_selectedDate!)
          : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = context.read<SavingsProvider>();
      final amount = double.parse(_amountController.text.trim());
      final note = _noteController.text.trim();

      // Check if removing more than saved (only for new remove transactions or if editing to remove more)
      // For simplicity, we'll just check if current amount allows it.
      // Ideally we should calculate the net change but this is a safe check.
      if (!_isAdd) {
        double currentAmount = widget.goal.currentAmount;
        // If editing, we need to revert the effect of the current transaction before checking
        if (widget.transaction != null) {
          if (widget.transaction!.isAdd) {
            currentAmount -= widget.transaction!.amount;
          } else {
            currentAmount += widget.transaction!.amount;
          }
        }

        if (amount > currentAmount) {
          if (mounted) {
            Get.snackbar(
              'Error',
              'cannotRemoveMoreThanSaved'.tr,
              backgroundColor: AppColors.error,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      if (widget.transaction != null) {
        await provider.updateTransaction(
          id: widget.transaction!.id,
          goalId: widget.goal.id,
          type: _isAdd ? 'add' : 'remove',
          newAmount: amount,
          date: _selectedDate!,
          note: note.isEmpty ? null : note,
        );
        if (mounted) {
          Get.back();
          Get.snackbar(
            'Success',
            'transactionUpdated'.tr,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        }
      } else {
        await provider.addTransaction(
          goalId: widget.goal.id,
          type: _isAdd ? 'add' : 'remove',
          amount: amount,
          date: _selectedDate!,
          note: note.isEmpty ? null : note,
        );
        if (mounted) {
          Get.back();
          Get.snackbar(
            'Success',
            'transactionAdded'.tr,
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Field
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onTap: _selectDate,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'dateRequired'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Toggle: Add / Remove
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).cardColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isAdd = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _isAdd
                                    ? AppColors.success
                                    : AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'add'.tr,
                                  style: TextStyle(
                                    color: _isAdd
                                        ? Colors.white
                                        : AppColors.success,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isAdd = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: !_isAdd
                                    ? AppColors.error
                                    : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'remove'.tr,
                                  style: TextStyle(
                                    color: !_isAdd
                                        ? Colors.white
                                        : AppColors.error,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',

                      //  labelText: 'amount'.tr,
                      // prefixIcon: Icon(
                      //   Icons.monetization_on_outlined,
                      //   color: Theme.of(context).primaryColor,
                      // ),
                      prefixText: '৳ ',
                      prefixStyle: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'amountRequired'.tr;
                      final amount = double.tryParse(value!);
                      if (amount == null) return 'invalidAmount'.tr;
                      if (amount <= 0) return 'amountMustBePositive'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 12),

                  // Note Field
                  TextFormField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'enterNote'.tr,
                      labelText: '${'note'.tr} (${'optional'.tr})',
                      prefixIcon: const Icon(Icons.note_outlined, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('cancel'.tr),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveTransaction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isAdd
                                ? AppColors.success
                                : AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  _isAdd ? 'add'.tr : 'remove'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
