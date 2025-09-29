import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key});

  @override
  _TransactionFormPageState createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String? selectedCategory;
  DateTime selectedDate = DateTime.now();
  String selectedPaymentMethod = 'Cash';

  bool isLoading = false;

  final List<String> categories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Health & Fitness',
    'Travel',
    'Education',
    'Personal Care',
    'Gifts & Donations',
  ];

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
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Add Transaction", centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.04,vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleField(),
                      SizedBox(height: 20),
                      _buildAmountField(),
                      SizedBox(height: 20),
                      _buildCategoryField(),
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
        Text('Title (Optional)', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Enter transaction title',
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
        Text('Amount *', style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            prefixText: '\$ ',
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
              return 'Amount is required';
            }
            if (double.tryParse(value) == null) {
              return 'Enter a valid amount';
            }
            if (double.parse(value) <= 0) {
              return 'Amount must be greater than 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category *', style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: InputDecoration(
            hintText: 'Select category',
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedCategory = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Category is required';
            }
            return null;
          },
          icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date *', style: Theme.of(context).textTheme.bodyMedium),
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
                  _formatDate(selectedDate),
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
        Text('Payment Method *', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedPaymentMethod,
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
          onChanged: (String? value) {
            setState(() {
              selectedPaymentMethod = value!;
            });
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
        Text('Notes (Optional)', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).dividerColor.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any additional notes...',
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
        onPressed: isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Saving...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Text(
                'Save Transaction',
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
      initialDate: selectedDate,
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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Collect form data
      final transactionData = {
        'title': _titleController.text.isEmpty ? null : _titleController.text,
        'amount': double.parse(_amountController.text),
        'category': selectedCategory,
        'date': selectedDate.toIso8601String(),
        'paymentMethod': selectedPaymentMethod,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
        'createdAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        isLoading = false;
      });

      // Show success message
      _showSuccessDialog(transactionData);
    }
  }

  void _showSuccessDialog(Map<String, dynamic> data) {
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
                  Text('Success!'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transaction saved successfully!'),
                  SizedBox(height: 16),
                  Text(
                    'Details:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Amount: \$${data['amount']}'),
                  Text('Category: ${data['category']}'),
                  Text('Payment: ${data['paymentMethod']}'),
                  Text('Date: ${_formatDate(selectedDate)}'),
                  if (data['title'] != null) Text('Title: ${data['title']}'),
                  if (data['notes'] != null) Text('Notes: ${data['notes']}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetForm();
                  },
                  child: Text('Add Another'),
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
                  child: Text('Done'),
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
    setState(() {
      selectedCategory = null;
      selectedDate = DateTime.now();
      selectedPaymentMethod = 'Cash';
    });
  }
}
