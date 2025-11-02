import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/views/categoryView/pages/category_item_view.dart';
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
  late TabController _tabController;

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

  /// Get the currently selected categories
  // inside CategoryView State
  List<CategoryData> get currentCategories {
    final provider = context.watch<CategoryProvider>();
    final allCategories = provider.selectedType == TransactionType.expense
        ? expenseCategories
        : incomeCategories;

    final query = provider.searchQuery; // debounced/lowercased in your provider
    if (query.isEmpty) {
      return allCategories;
    }

    return allCategories.where((cat) => cat.matches(query)).toList();
  }

  /// Group categories by their section/group
  Map<String, List<CategoryData>> get groupedCategories {
    final Map<String, List<CategoryData>> grouped = {};
    for (var category in currentCategories) {
      grouped.putIfAbsent(category.group, () => []).add(category);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: customAppBar(
        title: 'category'.tr,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
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
              onPressed: provider.setIsSearchBarShowed,
              icon: Icon(
                provider.isSearchBarShowed ? Icons.search : Icons.close,
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabButtons(),
            if (provider.isSearchBarShowed) _buildSearchBar(),
            Expanded(child: _buildCategoryGrid()),
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// UI Components
  /// ----------------------------

  Widget _buildTabButtons() {
    final provider = context.watch<CategoryProvider>();

    Widget _tabButton(String title, TransactionType type, Color color) {
      final isSelected = provider.selectedType == type;
      return Expanded(
        child: GestureDetector(
          onTap: () =>
              context.read<CategoryProvider>().changeSelectedType(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              title.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _tabButton(
            'expenses',
            TransactionType.expense,
            AppColors.primaryBlue,
          ),
          _tabButton('income', TransactionType.income, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final provider = context.watch<CategoryProvider>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: provider.isSearchBarShowed
          ? Container(
              key: const ValueKey('search_bar'),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: 12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: provider.setSearchQuery,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'search'.tr,
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textMuted,
                  ),
                  suffixIcon: provider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textMuted,
                          ),
                          onPressed: () => provider.setSearchQuery(''),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCategoryGrid() {
    final selectedType = context.watch<CategoryProvider>().selectedType;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        key: ValueKey(selectedType),
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedCategories.entries
              .map((entry) => _buildCategorySection(entry.key, entry.value))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<CategoryData> categories) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              const itemWidth = 80.0;
              final crossAxisCount = (availableWidth / itemWidth).floor();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount.clamp(2, 6),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: categories.length,
                itemBuilder: (_, index) =>
                    _buildCategoryItem(categories[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryData category) {
    return GestureDetector(
      onTap: () => Get.to(
        () => CategoryItemView(
          categoryName: category.name,
          categoryIcon: category.icon,
          categoryColor: category.color,
          categoryKey: category.key,
        ),
      ),
      child: ClipRect(
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
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                category.name,
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
