import 'package:finance_manager_app/data/category/category_item_data.dart';
import 'package:finance_manager_app/data/category/income_item_data.dart';
import 'package:finance_manager_app/models/categoryModel/category_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/category/category_provider.dart';
import 'package:finance_manager_app/views/categoryView/pages/category_item_view.dart';
import '../../config/enums/enums.dart';

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

  List<CategoryItemModel> get currentCategoriesItem {
    final provider = context.watch<CategoryProvider>();
    final allCategories = provider.selectedType == TransactionType.expense
        ? categoryItems
        : incomeCategoryItems;

    final query = provider.searchQuery; // debounced/lowercased in your provider
    if (query.isEmpty) {
      return allCategories;
    }

    return allCategories.where((cat) => cat.matches(query)).toList();
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
                provider.isSearchBarShowed ? Icons.close : Icons.search,
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
            SizedBox(height: 20),
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

    Widget tabButton(String title, TransactionType type, Color color) {
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
          tabButton('expenses', TransactionType.expense, AppColors.primaryBlue),
          tabButton('income', TransactionType.income, Colors.blue),
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
                    color: Colors.black.withValues(alpha: 0.05),
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
    final provider = context.watch<CategoryProvider>();
    final selectedType = provider.selectedType;
    final categories = currentCategoriesItem;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800
            ? 7
            : constraints.maxWidth > 600
            ? 6
            : constraints.maxWidth > 400
            ? 4
            : 3;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: categories.isEmpty
              ? Center(
                  key: ValueKey(
                    'empty_${selectedType}_${provider.searchQuery}',
                  ),
                  child: Text(
                    'No categories found'.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : GridView.builder(
                  key: ValueKey("${selectedType}_${provider.searchQuery}"),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryTile(category: category);
                  },
                ),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryItemModel category;

  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Get.to(
        () => CategoryItemView(
          categoryIcon: category.icon,
          categoryColor: category.color,
          categoryKey: category.key,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: category.color.withValues(alpha: 0.15),
            child: Icon(category.icon, color: category.color, size: 26),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
