import 'package:finance_manager_app/config/enums/enums.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/categoryModel/transaction_model.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/providers/category/transaction_provider.dart';
import 'package:finance_manager_app/providers/reportProvider/report_provider.dart';
import 'package:finance_manager_app/views/categoryView/widgets/calculator_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({
    super.key,
    this.transactionModel,
    this.categoryIcon,
    this.categoryColor,
    this.categoryKey,
  });
  final String? categoryKey;
  final String? categoryIcon;
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
  final _amountFocusNode = FocusNode();
  bool _includeInTotal = true; // Local state for checkbox

  // Payment methods keys for translation
  final List<String> paymentMethods = [
    'cash',
    'bankTransfer',
    'creditCard',
    'debitCard',
    'mobileWallet',
    'check',
    'bkash',
    'nagad',
    'rocket',
    'upay',
  ];
  @override
  void initState() {
    context.read<AddExpenseProvider>().selectedDate =
        widget.transactionModel?.date ?? DateTime.now();
    context.read<AddExpenseProvider>().selectedPaymentMethod =
        widget.transactionModel?.paymentMethod ?? "cash";
    _amountController.text = widget.transactionModel?.amount.toString() ?? "";
    _notesController.text = widget.transactionModel?.notes.toString() ?? "";
    _titleController.text = widget.transactionModel?.title.toString() ?? "";
    _includeInTotal = widget.transactionModel?.includeInTotal ?? true;

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _amountFocusNode.dispose();
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
                      _buildDateField(),
                      SizedBox(height: 20),
                      _buildPaymentMethodField(),
                      SizedBox(height: 20),
                      _buildNotesField(),
                      SizedBox(height: 40),
                      // Only show checkbox for income transactions
                      if ((widget.transactionModel?.type ??
                              context.watch<CategoryProvider>().selectedType) ==
                          TransactionType.income)
                        Row(
                          children: [
                            Checkbox(
                              value: _includeInTotal,
                              activeColor: AppColors.primaryBlue,
                              checkColor: AppColors.textPrimary,
                              onChanged: (value) {
                                setState(() {
                                  _includeInTotal = value!;
                                });
                              },
                            ),

                            Text('include_in_total_income'.tr),
                          ],
                        ),

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
        Text(
          'amountRequired'.tr,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          focusNode: _amountFocusNode,
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(16),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.calculate_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: _showCalculator,
            ),
          ),
          style: TextStyle(fontSize: 16),
          validator: (value) {
            if (value == null || value.isEmpty) return 'amountRequiredError'.tr;
            if (double.tryParse(value) == null) return 'amountValidError'.tr;
            if (double.parse(value) <= 0) return 'amountGreaterError'.tr;
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
    final provider = context.watch<AddExpenseProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'paymentMethodRequired'.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: provider.selectedPaymentMethod,
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
          items: paymentMethods.map((methodKey) {
            return DropdownMenuItem<String>(
              value: methodKey,
              child: Text(methodKey.tr), // ✅ localized text
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) provider.setselectedPaymentMethod(value);
          },
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
    final provider = context.read<AddExpenseProvider>();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      provider.setSelectedDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    final locale = Get.locale?.languageCode ?? 'en';
    if (locale == 'bn') {
      final banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      String d = date.day
          .toString()
          .split('')
          .map((e) => banglaDigits[int.parse(e)])
          .join();
      String m = date.month
          .toString()
          .split('')
          .map((e) => banglaDigits[int.parse(e)])
          .join();
      String y = date.year
          .toString()
          .split('')
          .map((e) => banglaDigits[int.parse(e)])
          .join();
      return '$d/$m/$y';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final text = _amountController.text.trim();
    final amount = int.tryParse(text) ?? 0;

    final tn = TransactionModel(
      type:
          widget.transactionModel?.type ??
          context.read<CategoryProvider>().selectedType,
      date: context.read<AddExpenseProvider>().selectedDate,
      title: _titleController.text == ""
          ? widget.categoryKey!.tr
          : _titleController.text,
      amount: amount,
      paymentMethod: context.read<AddExpenseProvider>().selectedPaymentMethod,
      icon: widget.transactionModel?.icon ?? widget.categoryIcon!,
      iconBgColor:
          widget.transactionModel?.iconBgColor ??
          widget.categoryColor!.toARGB32(),
      notes: _notesController.text,
      categoryKey:
          widget.transactionModel?.categoryKey ??
          widget.categoryKey ??
          widget.categoryKey!,
      includeInTotal: _includeInTotal, // Pass the checkbox value
    );

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final addExpenseProvider = context.read<AddExpenseProvider>();
      final reportProvider = context.read<ReportProvider>();

      if (widget.transactionModel != null) {
        await addExpenseProvider.updateTransaction(
          widget.transactionModel!.id!,
          tn,
        );
      } else {
        await addExpenseProvider.addExpense(tn);
      }

      if (!mounted) return;

      // Close the loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      reportProvider.warningshow();

      _resetForm();
      Get.back();
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // close loading
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('something_went_wrong'.tr)));
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _amountController.clear();
    _notesController.clear();
    context.read<AddExpenseProvider>().clearDate();
    setState(() {
      _includeInTotal = true; // Reset checkbox to default
    });
  }

  void _showCalculator() {
    // Unfocus current node (hide keyboard)
    _amountFocusNode.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalculatorBottomSheet(
        controller: _amountController,
        onClose: () {
          // Unfocus before closing
          _amountFocusNode.unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          Navigator.pop(context);
        },
      ),
    ).whenComplete(() {
      // Ensure keyboard stays hidden after calculator closes
      Future.delayed(Duration(milliseconds: 100), () {
        _amountFocusNode.unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      });
    });
  }
}
