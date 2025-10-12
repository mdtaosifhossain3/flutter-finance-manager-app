import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/views/categoryView/pages/category_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../config/enums/enums.dart';
import '../../data/category/expense_cateogries.dart';
import '../../data/category/income_cateogries.dart';
import '../../models/categoryModel/category_data_model.dart';


class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategoryView>
    with TickerProviderStateMixin {
  //Tab Controller
  late TabController _tabController;

  //Get the current categories
  List<CategoryData> get currentCategories {
    final provider = context.watch<CategoryProvider>();
    final allCategories = provider.selectedType == TransactionType.expense
        ? expenseCategories
        : incomeCategories;

    if (provider.searchQuery.isEmpty) {
      return allCategories;
    }

    return allCategories
        .where((cat) => cat.name.toLowerCase().contains(provider.searchQuery))
        .toList();
  }


  // Map Groups
  Map<String, List<CategoryData>> get groupedCategories {
    Map<String, List<CategoryData>> grouped = {};
    for (var category in currentCategories) {
      if (!grouped.containsKey(category.group)) {
        grouped[category.group] = [];
      }
      grouped[category.group]!.add(category);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'category'.tr,actions: [
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.03,
          ),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
            ),
            onPressed: () {
              context.read<CategoryProvider>().setIsSearchBarShowed();
            },
            icon: context.watch<CategoryProvider>().isSearchBarShowed ? Icon(Icons.search) : Icon(Icons.close),
          ),
        ),
      ]),
        resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabButtons(),
            Consumer<CategoryProvider>(
                   builder: (context,provider,child) {
              return provider.isSearchBarShowed  ?  const SizedBox() :
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: 16,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                 // controller: searchController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'search'.tr,
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (value) {
                    provider.setSearchQuery(value);
                  },
                ),
              );
            }),
            Expanded(child: _buildCategoryGrid()),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 10,
      ),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<CategoryProvider>().changeSelectedType(
                  TransactionType.expense,
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      context.watch<CategoryProvider>().selectedType ==
                          TransactionType.expense
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:
                      context.watch<CategoryProvider>().selectedType ==
                          TransactionType.expense
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'expenses'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        context.watch<CategoryProvider>().selectedType ==
                            TransactionType.expense
                        ? Colors.white
                        : Colors.grey[600],
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
                context.read<CategoryProvider>().changeSelectedType(
                  TransactionType.income,
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      context.watch<CategoryProvider>().selectedType ==
                          TransactionType.income
                      ? Colors.blue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:
                      context.watch<CategoryProvider>().selectedType ==
                          TransactionType.income
                      ? [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'income'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        context.watch<CategoryProvider>().selectedType ==
                            TransactionType.income
                        ? Colors.white
                        : Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: SingleChildScrollView(
        key: ValueKey(context.watch<CategoryProvider>().selectedType),
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedCategories.entries.map((entry) {
            return _buildCategorySection(entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String sectionTitle,
    List<CategoryData> categories,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,

        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha:0.05),
        //     blurRadius: 8,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              sectionTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(categories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryData category) {
    return GestureDetector(
      onTap: () {
        // Handle category selection
        Get.to(
          () => CategoryItemView(
            categoryName: category.name,
            categoryIcon: category.icon,
            categoryColor: category.color,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: category.color.withValues(alpha: 0.15),
              ),
              child: Icon(category.icon, color: category.color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              category.name.length > 8
                  ? '${category.name.substring(0, 8)}...'
                  : category.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
