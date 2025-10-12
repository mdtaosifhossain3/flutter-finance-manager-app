import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({
    super.key,
    this.transactionModel,
    this.categoryName,
    this.categoryIcon,
    this.categoryColor,
  });
  final String? categoryName;
  final IconData? categoryIcon;
  final Color? categoryColor;
  final TransactionModel? transactionModel;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> paymentMethods = [
    'Cash',
    'Bank Transfer',
    'Credit Card',
    'Debit Card',
    'Mobile Wallet',
    'PayPal',
    'Crypto',
    'Check',
  ];

  @override
  void initState() {
    context.read<AddExpenseProvider>().selectedDate =
        widget.transactionModel?.date ?? DateTime.now();
    context.read<AddExpenseProvider>().selectedPaymentMethod =
        widget.transactionModel?.paymentMethod ?? "Cash";
    _amountController.text = widget.transactionModel?.amount.toString() ?? "";
    _notesController.text = widget.transactionModel?.notes.toString() ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "addTransaction".tr,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleField(),
                      SizedBox(height: 20),
                      _buildAmountField(),
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      _buildDateField(),
                      SizedBox(height: 20),
                      _buildPaymentMethodField(),
                      SizedBox(height: 20),
                      _buildNotesField(),
                      SizedBox(height: 40),
                      _buildSubmitButton(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('titleOptional'.tr, style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'titleHint'.tr,
            hintStyle: Theme.of(context).textTheme.bodySmall,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(16),
          ),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('amountRequired'.tr, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: 'amountHint'.tr,
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            prefixText: '৳ ',
            prefixStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
            // border: InputBorder.none,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(16),
          ),
          style: TextStyle(fontSize: 16),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'amountRequiredError'.tr;
            }
            if (double.tryParse(value) == null) {
              return 'amountValidError'.tr;
            }
            if (double.parse(value) <= 0) {
              return 'amountGreaterError'.tr;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('dateRequired'.tr, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                // BoxShadow(
                //   color: Theme.of(context).dividerColor,
                //   blurRadius: 8,
                //   offset: Offset(0, 2),
                // ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(context.watch<AddExpenseProvider>().selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).hintColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('paymentMethodRequired'.tr, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: context.watch<AddExpenseProvider>().selectedPaymentMethod,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(16),
          ),
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          items: paymentMethods.map((String method) {
            return DropdownMenuItem<String>(value: method, child: Text(method));
          }).toList(),
          onChanged: context
              .read<AddExpenseProvider>()
              .setselectedPaymentMethod,
          icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('notesOptional'.tr, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'notesHint'.tr,
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          'saveTransaction'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: context.read<AddExpenseProvider>().selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Use current time when saving the picked date
      context.read<AddExpenseProvider>().setSelectedDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Collect form data
      final text = _amountController.text.trim();
      final amount = int.tryParse(text) ?? 0;
      TransactionModel tn = TransactionModel(
        type:
            widget.transactionModel?.type ??
            context.read<CategoryProvider>().selectedType,
        date: context.read<AddExpenseProvider>().selectedDate,
        title: _titleController.text.isEmpty ? "" : _titleController.text,
        categoryName:
            widget.transactionModel?.categoryName ?? widget.categoryName!,
        amount: amount,
        paymentMethod: context.read<AddExpenseProvider>().selectedPaymentMethod,
        icon: widget.transactionModel?.icon ?? widget.categoryIcon!,
        iconBgColor:
            widget.transactionModel?.iconBgColor ??
            widget.categoryColor!.toARGB32(),
        notes: _notesController.text,
      );

      widget.transactionModel != null
          ? context.read<AddExpenseProvider>().updateTransaction(
              widget.transactionModel!.id!,
              tn,
            )
          : context.read<AddExpenseProvider>().addExpense(tn);

      _showSuccessDialog(tn);
    }
  }

  void _showSuccessDialog(TransactionModel data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Hero(
            tag: 'transaction_success_dialog',
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 28),
                  SizedBox(width: 12),
                  Text('successTitle'.tr),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('successMessage'.tr),
                  SizedBox(height: 16),
                  Text(
                    'details'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('${"amount".tr}: ৳${data.amount}'),
                  Text('${"category".tr}: ${data.categoryName}'),
                  Text('${"payment".tr}: ${data.paymentMethod}'),
                  Text(
                    '${"date".tr}: ${_formatDate(context.watch<AddExpenseProvider>().selectedDate)}',
                  ),
                  if (data.notes != null) Text('${"notes".tr}: ${data.notes}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetForm();
                  },
                  child: Text('addAnother'.tr),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Return to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: Text('done'.tr),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _amountController.clear();
    _notesController.clear();
    context.read<AddExpenseProvider>().clearDate();
  }
}
