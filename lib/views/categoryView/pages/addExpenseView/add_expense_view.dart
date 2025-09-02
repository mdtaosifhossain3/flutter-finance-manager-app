import 'package:finance_manager_app/providers/expense_provider.dart';
import 'package:finance_manager_app/views/categoryView/pages/addExpenseView/add_expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../config/db/local/local_db_helper.dart';
import '../../../../config/myColors/my_colors.dart';
import '../../../../globalWidgets/popup_dailogue_widget.dart';

class AddExpenseScreen extends StatefulWidget {
  final String categoryName;

  const AddExpenseScreen({super.key, required this.categoryName});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  LocalDBHelper localDBHelper = LocalDBHelper.getInstance;

  List<String> categories = [
    'Food',
    'Transport',
    'Medicine',
    'Groceries',
    'Rent',
    'Gifts',
    'Savings',
    'Entertainment',
  ];

  @override
  void initState() {
    super.initState();
    AddExpenseViewModel.selectedCategory = widget.categoryName;
    AddExpenseViewModel.amountController.text = '';
    AddExpenseViewModel.titleController.text = '';
    AddExpenseViewModel.messageController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.carbbeanGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Text(
                    'Add Expenses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Field
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cyprus,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => context.read<AddExpenseProvider>().selectDate(context,AddExpenseViewModel.currentDate),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AddExpenseViewModel.formatDate(AddExpenseViewModel.currentDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.cyprus,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.carbbeanGreen,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Category Field
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cyprus,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: AddExpenseViewModel.selectedCategory,
                            hint: const Text('Select the category'),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                AddExpenseViewModel.selectedCategory = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Amount Field
                      const Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cyprus,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: AddExpenseViewModel.amountController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '৳ 0.00',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Expense Title Field
                      const Text(
                        'Expense Title',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cyprus,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: AddExpenseViewModel.titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter title',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Message Field
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: AddExpenseViewModel.messageController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Message',
                            hintStyle: TextStyle(
                              color: AppColors.carbbeanGreen,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (AddExpenseViewModel.amountController.text.isEmpty ||
                                AddExpenseViewModel.titleController.text.isEmpty) {
                              Get.snackbar(
                                'Error!',
                                "Please fill all the fields.",
                                backgroundColor: MyColors.honeyDew,
                                borderRadius: 15,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                colorText: MyColors.cyprus,
                                icon: const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                duration: const Duration(seconds: 3),
                                overlayBlur: 1.5,
                                shouldIconPulse: true,
                                barBlur: 5,
                                padding: const EdgeInsets.all(16),
                                isDismissible: true,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                              return;
                            }

                            try {
                              await context
                                  .read<AddExpenseProvider>()
                                  .addExpense(
                                    selectedDate: AddExpenseViewModel.currentDate,
                                    titleController: AddExpenseViewModel.titleController,
                                    amountController: AddExpenseViewModel.amountController,
                                    selectedCategory: AddExpenseViewModel.selectedCategory,
                                    messageController: AddExpenseViewModel.messageController,
                                  );
                              AddExpenseViewModel.titleController.clear();
                            AddExpenseViewModel.amountController.clear();
                            AddExpenseViewModel.messageController.clear();

                              // Show success message
                              Get.snackbar(
                                'Success!',
                                'Your expense has been saved successfully.',
                                backgroundColor: MyColors.honeyDew,
                                borderRadius: 15,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                colorText: MyColors.cyprus,
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  color: MyColors.carbbeanGreen,
                                ),
                                duration: const Duration(seconds: 2),
                                overlayBlur: 1.5,
                                shouldIconPulse: true,
                                barBlur: 5,
                                padding: const EdgeInsets.all(16),
                                isDismissible: true,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );

                              // Wait a brief moment before popping
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              Get.snackbar(
                                'Error!',
                                'Failed to save expense. Please try again.',
                                backgroundColor: MyColors.honeyDew,
                                colorText: Colors.red,
                                icon: const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                duration: const Duration(seconds: 3),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.carbbeanGreen,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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

  // @override
  // void dispose() {
  //   AddExpenseViewModel.amountController.dispose();
  //   AddExpenseViewModel.titleController.dispose();
  //   AddExpenseViewModel.messageController.dispose();
  //   super.dispose();
  // }
}
