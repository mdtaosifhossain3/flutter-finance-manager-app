import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/models/tempm/budgetModel/budget_model.dart';
import 'package:finance_manager_app/models/tempm/budgetModel/budget_category_model.dart';
import 'package:finance_manager_app/views/budgetView/pages/add_budget_view.dart';
import 'package:finance_manager_app/views/budgetView/pages/budget_card_view.dart';
import 'package:finance_manager_app/views/budgetView/widgets/budget_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../providers/budget/budget_provider.dart';

class BudgetViewScreen extends StatelessWidget {
  const BudgetViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Budget Overview',
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03,
            ),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
              ),
              onPressed: () {
                Get.to(const AddBudgetView());
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<BudgetProvider>(builder: (context,provider,child){
         return provider.budgets.isEmpty
              ? const Center(child: Text("No budgets yet"))
              : ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: 10,
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.budgets.length,
            itemBuilder: (context, index) {
              final BudgetModel budget = provider.budgets[index];
              return BudgetCardWidget(provider:provider, budget:budget);
            },
          );
        })
      ),
    );
  }


}
