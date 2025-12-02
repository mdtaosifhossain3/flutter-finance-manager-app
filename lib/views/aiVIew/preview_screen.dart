import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/preview_card_button.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/preview_card_widget.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AiProvider>(context);

    return Scaffold(
      appBar: customAppBar(
        title: 'preview'.tr,
        titleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'back'.tr,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              PreviewCardWidget(parsedDataEx: provider.parsedDataEx),
              const SizedBox(height: 24),
              PreviewCardButton(
                editTransactionButton: () {
                  HapticFeedback.selectionClick();
                  provider
                      .editTransaction(); // Just notifies listeners, doesn't change nav
                  Get.back(); // Go back to input screen
                },
                deleteTransactionButton: () {
                  HapticFeedback.lightImpact();
                  provider.deleteTransaction(); // Clears data
                  Get.back(); // Go back to input screen
                },
                saveTransactionButton: () {
                  HapticFeedback.mediumImpact();
                  provider.saveTransaction(context);
                  Get.offAll(() => const MainView()); // Navigate to Home
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
