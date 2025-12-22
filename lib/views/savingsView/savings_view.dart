import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/savingsProvider/savings_provider.dart';
import 'package:finance_manager_app/views/savingsView/pages/add_savings_goal_dailogue.dart';
import 'package:finance_manager_app/views/savingsView/widgets/savings_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SavingsView extends StatefulWidget {
  const SavingsView({super.key});

  @override
  State<SavingsView> createState() => _SavingsViewState();
}

class _SavingsViewState extends State<SavingsView> {
  @override
  void initState() {
    super.initState();
    // Load all savings goals when view initializes
    Future.microtask(() {
      context.read<SavingsProvider>().loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'savingsGoals'.tr,
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
                // Get.to(const AddSavingsGoalView());
                AddSavingsGoalDialog.show(context);
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<SavingsProvider>(
          builder: (context, provider, child) {
            // Loading state
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }

            // Error state
            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${provider.error}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            // Empty state
            if (provider.goals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.savings_outlined,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'noSavingsGoalsYet'.tr,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'createYourFirstGoal'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        AddSavingsGoalDialog.show(context);
                      },
                      icon: const Icon(Icons.add),
                      label: Text('createGoal'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Goals list with summary
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    // Goals List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.goals.length,
                      itemBuilder: (context, index) {
                        final goal = provider.goals[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SavingsCardWidget(
                            provider: provider,
                            goal: goal,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
