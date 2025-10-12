import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/budgetModel/budget_category_model.dart';
import 'package:finance_manager_app/models/budgetModel/budget_model.dart';
import 'package:finance_manager_app/providers/budget/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../data/budget/budget_categories.dart';

class AddBudgetView extends StatefulWidget {
  const AddBudgetView({super.key});

  @override
  State<AddBudgetView> createState() => _AddBudgetViewState();
}

class CategoryBudget {
  final String category;
  final double amount;

  CategoryBudget({required this.category, required this.amount});
}

class _AddBudgetViewState extends State<AddBudgetView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final List<BudgetCategoryModel> _selectedCategories = [];
  String? _currentCategory;
  final _categoryAmountController = TextEditingController();



  void _addCategory() {

    if (_currentCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    final String amount = _categoryAmountController.text;
    if (amount.isEmpty ||
        double.tryParse(amount) == null ||
        double.parse(amount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    setState(() {
      _selectedCategories.add(
        BudgetCategoryModel(
          categoryName: _currentCategory!,
          allocatedAmount: int.parse(amount),
        ),
      );
      _currentCategory = null;
      _categoryAmountController.clear();
    });
  }


  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _categoryAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Create Budget",leading: Padding(
        padding: const EdgeInsets.only(left:10.0),
        child: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back)),
      )),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    _buildHeaderCard(),
                    SizedBox(height: 24),

                    // Form Fields
                    _buildFormCard(),
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Budget',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Set spending limits and track your expenses',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Field
        _buildTextField(
          controller: _titleController,
          label: 'Budget Title',
          hint: 'e.g., Monthly Groceries',
          icon: Icons.title,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a budget title';
            }
            return null;
          },
        ),
        SizedBox(height: 20),

        // Amount Field
        _buildTextField(
          controller: _amountController,
          label: 'Budget Amount',
          hint: '0.00',
          icon: Icons.attach_money,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter budget amount';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
        SizedBox(height: 20),

        // Category Dropdown
        _buildCategoryDropdown(),
        SizedBox(height: 20),

        // Date Fields
        Row(
          children: [
            Expanded(child: _buildDateField(true)), // Start Date
            SizedBox(width: 16),
            Expanded(child: _buildDateField(false)), // End Date
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!, width: 2),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 8),

        // Selected Categories List
        if (_selectedCategories.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: _selectedCategories.map((categoryBudget) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      _getCategoryIcon(categoryBudget.categoryName),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryBudget.categoryName,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              '৳${categoryBudget.allocatedAmount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red[400],
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedCategories.removeWhere(
                              (item) =>
                                  item.categoryName ==
                                  categoryBudget.categoryName,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
        ],

        // Add New Category Section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: _currentCategory,
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: 'Select a category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                items: categories
                    .where(
                      (category) => !_selectedCategories.any(
                        (selected) => selected.categoryName == category,
                      ),
                    )
                    .map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Row(
                          children: [
                            _getCategoryIcon(category),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _currentCategory = value;
                  });
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _categoryAmountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: '৳',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _addCategory,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Icon(Icons.add),
          ),
        ),
        if (_selectedCategories.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Please add at least one category',
              style: TextStyle(color: Colors.red[400], fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDateField(bool isStartDate) {
    DateTime? selectedDate = isStartDate ? _startDate : _endDate;
    String label = isStartDate ? 'Start Date' : 'End Date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(isStartDate),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : 'Select date',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onTertiary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_shouldShowDateError(isStartDate))
          Padding(
            padding: EdgeInsets.only(top: 8, left: 12),
            child: Text(
              isStartDate
                  ? 'Please select start date'
                  : 'End date must be after start date',
              style: TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Theme.of(context).dividerColor),
              ),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _saveBudget,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Create Budget',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData iconData;
    Color color;

    switch (category.toLowerCase()) {
      case 'groceries':
        iconData = Icons.shopping_cart;
        color = Colors.green;
        break;
      case 'transportation':
        iconData = Icons.directions_car;
        color = Colors.blue;
        break;
      case 'entertainment':
        iconData = Icons.movie;
        color = Colors.purple;
        break;
      case 'utilities':
        iconData = Icons.electrical_services;
        color = Colors.orange;
        break;
      case 'dining out':
        iconData = Icons.restaurant;
        color = Colors.red;
        break;
      case 'shopping':
        iconData = Icons.shopping_bag;
        color = Colors.pink;
        break;
      case 'healthcare':
        iconData = Icons.local_hospital;
        color = Colors.teal;
        break;
      case 'education':
        iconData = Icons.school;
        color = Colors.indigo;
        break;
      case 'travel':
        iconData = Icons.flight;
        color = Colors.cyan;
        break;
      case 'insurance':
        iconData = Icons.security;
        color = Colors.brown;
        break;
      case 'savings':
        iconData = Icons.savings;
        color = Colors.green;
        break;
      case 'investment':
        iconData = Icons.trending_up;
        color = Colors.amber;
        break;
      default:
        iconData = Icons.category;
        color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 20);
  }

  Future<void> _selectDate(bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now().subtract(Duration(days: 365));
    DateTime lastDate = DateTime.now().add(Duration(days: 365 * 2));

    if (isStartDate && _endDate != null) {
      lastDate = _endDate!.subtract(Duration(days: 1));
    } else if (!isStartDate && _startDate != null) {
      firstDate = _startDate!.add(Duration(days: 1));
      initialDate = _startDate!.add(Duration(days: 1));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate)
          ? firstDate
          : initialDate.isAfter(lastDate)
          ? lastDate
          : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Reset end date if it's before the new start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  bool _shouldShowDateError(bool isStartDate) {
    if (isStartDate) {
      return false; // We'll handle start date validation in form submission
    } else {
      return _startDate != null &&
          _endDate != null &&
          _endDate!.isBefore(_startDate!);
    }
  }

  void _saveBudget() async {
    // Validate dates separately since they're not TextFormFields
    bool datesValid = true;


    if (_startDate == null) {
      datesValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a start date'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    if (_endDate == null) {
      datesValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an end date'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one category'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate() && datesValid) {
      // Create budget object
      final budget = {
        'title': _titleController.text.trim(),
        'categories': _selectedCategories
            .map(
              (cat) => {
                'category': cat.categoryName,
                'amount': cat.allocatedAmount,
              },
            )
            .toList(),
        'totalAmount': _selectedCategories.fold(
          0.0,
          (sum, cat) => sum + cat.allocatedAmount,
        ),
        'startDate': _startDate,
        'endDate': _endDate,
        'notes': _notesController.text.trim(),
        'createdAt': DateTime.now(),
      };

      // Create budget
      final budgetId = await context.read<BudgetProvider>().addBudget(
        BudgetModel(
          title: _titleController.text.trim(),
          totalAmount: int.parse(_amountController.text),
          startDate: _startDate!,
          endDate: _endDate!,
        ),
        _selectedCategories,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Budget created successfully!,$budgetId'),
            ],
          ),
          backgroundColor: Colors.green[600],
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back with the created budget
      Navigator.pop(context, budget);
    }
  }
}
