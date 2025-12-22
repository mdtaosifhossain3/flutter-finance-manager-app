import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/givenTakenModel/lend_transaction_model.dart';
import 'package:finance_manager_app/providers/givenTakenProvider/given_taken_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddEditTransactionView extends StatefulWidget {
  final int contactId;
  final LendTransaction? transaction;

  const AddEditTransactionView({
    super.key,
    required this.contactId,
    this.transaction,
  });

  @override
  State<AddEditTransactionView> createState() => _AddEditTransactionViewState();
}

class _AddEditTransactionViewState extends State<AddEditTransactionView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'given'; // 'given' or 'taken'
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _isEdit = true;
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note ?? '';
      _selectedDate = DateTime.parse(widget.transaction!.date);
      _selectedType = widget.transaction!.type;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: _isEdit ? 'edit_record'.tr : 'add_record'.tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: _isEdit
            ? [
                IconButton(
                  onPressed: _confirmDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'transaction_type'.tr,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeButton(
                        label: 'given'.tr,
                        type: 'given',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTypeButton(
                        label: 'taken'.tr,
                        type: 'taken',
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'amount'.tr,
                  controller: _amountController,
                  hint: '0',
                  prefixText: '৳ ',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'amount_required'.tr;
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'enter_valid_amount'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildDateField(),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'note'.tr,
                  controller: _noteController,
                  hint: 'enter_note'.tr,
                  maxLines: 2,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _saveTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _isEdit ? 'update'.tr : 'save'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? prefixText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'date'.tr,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String label,
    required String type,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _confirmDelete() {
    Get.dialog(
      AlertDialog(
        title: Text('delete_transaction'.tr),
        content: Text('confirm_delete_transaction'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () async {
              await context.read<GivenTakenProvider>().deleteTransaction(
                widget.transaction!.id!,
                widget.contactId,
              );
              Get.back(); // Close dialog
              Get.back(); // Go back to details
              Get.snackbar('success'.tr, 'transaction_deleted'.tr);
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<GivenTakenProvider>();
    final amount = int.parse(_amountController.text);
    final note = _noteController.text.trim();
    final date = _selectedDate.toIso8601String();

    try {
      if (_isEdit) {
        await provider.updateTransaction(
          id: widget.transaction!.id!,
          contactId: widget.contactId,
          type: _selectedType,
          amount: amount,
          date: date,
          note: note,
        );
      } else {
        await provider.addTransaction(
          contactId: widget.contactId,
          type: _selectedType,
          amount: amount,
          date: date,
          note: note,
        );
      }
      Get.back();
      Get.snackbar(
        'success'.tr,
        _isEdit ? 'transaction_updated'.tr : 'transaction_added'.tr,
      );
    } catch (e) {
      Get.snackbar('error'.tr, '${'failed_to_save_transaction'.tr}: $e');
    }
  }
}
