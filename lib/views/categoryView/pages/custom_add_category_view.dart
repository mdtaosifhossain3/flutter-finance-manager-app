import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:flutter/material.dart';



class CreateCategoryPage extends StatefulWidget {
  @override
  _CreateCategoryPageState createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _groupController = TextEditingController();

  String selectedType = 'Expense';
  IconData selectedIcon = Icons.category;
  Color selectedColor = Colors.blue;
  bool isLoading = false;

  String? selectedGroup;
  bool isCustomGroup = false;

  // Existing groups for each type
  final Map<String, List<String>> existingGroups = {
    'Expense': [
      'Food & Shopping',
      'Transportation',
      'Bills & Utilities',
      'Entertainment',
      'Health & Fitness',
      'Personal Care',
      'Education',
      'Travel',
      'Gifts & Donations',
    ],
    'Income': [
      'Primary Income',
      'Investments',
      'Side Income',
      'Other Income',
      'Business Income',
      'Passive Income',
    ],
  };

  // Available icons for categories
  final List<IconData> availableIcons = [
    Icons.category,
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.local_gas_station,
    Icons.movie,
    Icons.fitness_center,
    Icons.local_hospital,
    Icons.school,
    Icons.home,
    Icons.directions_car,
    Icons.phone,
    Icons.wifi,
    Icons.flash_on,
    Icons.water_drop,
    Icons.local_cafe,
    Icons.flight,
    Icons.hotel,
    Icons.pets,
    Icons.sports,
    Icons.music_note,
    Icons.games,
    Icons.book,
    Icons.brush,
    Icons.construction,
    Icons.spa,
    Icons.shopping_bag,
    Icons.local_pharmacy,
    Icons.local_taxi,
    Icons.train,
    Icons.business,
    Icons.work,
    Icons.account_balance,
    Icons.trending_up,
    Icons.savings,
    Icons.credit_card,
    Icons.currency_exchange,
    Icons.card_giftcard,
    Icons.star,
    Icons.volunteer_activism,
    Icons.celebration,
  ];

  // Available colors for categories
  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.grey,
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFF96CEB4),
    Color(0xFFFFCE56),
    Color(0xFF6C5CE7),
    Color(0xFFFF7675),
    Color(0xFFFFB142),
    Color(0xFF00B894),
    Color(0xFF74B9FF),
    Color(0xFF81ECEC),
    Color(0xFFFF6B9D),
    Color(0xFFFF9F43),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Custom Category"),
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
                      _buildTypeSelector(),
                      SizedBox(height: 24),
                      _buildNameField(),
                      SizedBox(height: 20),
                      _buildGroupField(),
                      SizedBox(height: 24),
                      _buildIconSelector(),
                      SizedBox(height: 24),
                      _buildColorSelector(),
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



  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Type *',
          style: Theme.of(context).textTheme.bodyMedium
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Theme.of(context).dividerColor)
          ),

          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = 'Expense';
                      // Reset group selection when changing type
                      selectedGroup = null;
                      isCustomGroup = false;
                      _groupController.clear();
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedType == 'Expense' ? Theme.of(context).primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: selectedType == 'Expense' ? [
                        // BoxShadow(
                        //   color: Colors.red.withOpacity(0.3),
                        //   blurRadius: 8,
                        //   offset: Offset(0, 2),
                        // ),
                      ] : null,
                    ),
                    child: Text(
                      'Expense',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedType == 'Expense' ?  AppColors.textPrimary :AppColors.textMuted,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = 'Income';
                      // Reset group selection when changing type
                      selectedGroup = null;
                      isCustomGroup = false;
                      _groupController.clear();
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedType == 'Income' ? Theme.of(context).colorScheme.secondary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: selectedType == 'Income' ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Text(
                      'Income',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedType == 'Income' ? AppColors.textPrimary :AppColors.textMuted,
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Name *',
          style: Theme.of(context).textTheme.bodyMedium
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter category name',
            hintStyle: TextStyle(color: AppColors.textMuted),
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
            if (value == null || value.trim().isEmpty) {
              return 'Category name is required';
            }
            if (value.trim().length < 2) {
              return 'Category name must be at least 2 characters';
            }
            if (value.trim().length > 30) {
              return 'Category name must be less than 30 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGroupField() {
    List<String> currentGroups = existingGroups[selectedType] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Name *',
          style:Theme.of(context).textTheme.bodyMedium
        ),
        SizedBox(height: 8),

        // Dropdown for existing groups
        if (!isCustomGroup) ...[
          DropdownButtonFormField<String>(
            value: selectedGroup,
            decoration: InputDecoration(
              hintText: 'Select existing group',
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
            style: TextStyle(fontSize: 16,color:Theme.of(context).colorScheme.onSecondary),
            items: [
              ...currentGroups.map((String group) {
                return DropdownMenuItem<String>(
                  value: group,
                  child: Text(group),
                );
              }),
              DropdownMenuItem<String>(
                value: 'create_new',
                child: Row(
                  children: [
                    Icon(Icons.add, size: 16, color: AppColors.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Create New Group',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (String? value) {
              if (value == 'create_new') {
                setState(() {
                  isCustomGroup = true;
                  selectedGroup = null;
                });
              } else {
                setState(() {
                  selectedGroup = value;
                });
              }
            },
            validator: (value) {
              if (!isCustomGroup && (value == null || value.isEmpty || value == 'create_new')) {
                return 'Please select a group or create a new one';
              }
              return null;
            },
            icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSecondary),
          ),
        ],

        // Text field for custom group
        if (isCustomGroup) ...[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                // BoxShadow(
                //   color: Colors.black.withOpacity(0.05),
                //   blurRadius: 8,
                //   offset: Offset(0, 2),
                // ),

              ],
              border: Border.all(color: Theme.of(context).dividerColor)
            ),
            child: TextFormField(
              controller: _groupController,
              decoration: InputDecoration(
                hintText: 'Enter new group name',
                hintStyle: TextStyle(color: AppColors.textMuted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSecondary),
                  onPressed: () {
                    setState(() {
                      isCustomGroup = false;
                      _groupController.clear();
                      selectedGroup = null;
                    });
                  },
                ),
              ),
              style: TextStyle(fontSize: 16),
              validator: (value) {
                if (isCustomGroup) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Group name is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Group name must be at least 3 characters';
                  }
                  if (value.trim().length > 40) {
                    return 'Group name must be less than 40 characters';
                  }
                  // Check if group already exists
                  if (currentGroups.contains(value.trim())) {
                    return 'This group already exists';
                  }
                }
                return null;
              },
            ),
          ),
        ],

        // Helper text
        SizedBox(height: 8),
        Text(
          isCustomGroup
              ? 'Creating a new group for organizing categories'
              : 'Select from existing groups or create a new one',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Icon *',
          style: Theme.of(context).textTheme.bodyMedium
        ),
        SizedBox(height: 12),
        Container(
          height: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
              border: Border.all(color: Theme.of(context).dividerColor)
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: availableIcons.length,
            itemBuilder: (context, index) {
              final icon = availableIcons[index];
              final isSelected = selectedIcon == icon;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIcon = icon;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor.withOpacity(0.2) : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? selectedColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? selectedColor : Colors.grey[600],
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Color *',
          style:Theme.of(context).textTheme.bodyMedium
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            // boxShadow: [
            //   BoxShadow(
            //     color: Theme.of(context).dividerColor,
            //     blurRadius: 8,
            //     offset: Offset(0, 2),
            //   ),
            // ],
            border: Border.all(color: Theme.of(context).dividerColor)

          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: availableColors.length,
            itemBuilder: (context, index) {
              final color = availableColors[index];
              final isSelected = selectedColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              );
            },
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
          foregroundColor: AppColors.textPrimary,
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
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Creating...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
            ),
          ],
        )
            : Text(
          'Create Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Create CategoryData object
      final String finalGroupName = isCustomGroup
          ? _groupController.text.trim()
          : selectedGroup!;

      final newCategory = CategoryData(
        _nameController.text.trim(),
        selectedIcon,
        selectedColor,
        finalGroupName,
      );

      setState(() {
        isLoading = false;
      });

      // Show success dialog
      _showSuccessDialog(newCategory);
    }
  }

  void _showSuccessDialog(CategoryData category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Category Created!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${selectedType} • ${category.group}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your new category has been successfully created and is now available for use in transactions.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: Text('Create Another'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to category selection or previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedType == 'Expense' ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _groupController.clear();
    setState(() {
      selectedType = 'Expense';
      selectedIcon = Icons.category;
      selectedColor = Colors.blue;
      selectedGroup = null;
      isCustomGroup = false;
    });
  }
}

class CategoryData {
  final String name;
  final IconData icon;
  final Color color;
  final String group;

  CategoryData(this.name, this.icon, this.color, this.group);
}