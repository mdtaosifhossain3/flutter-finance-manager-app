import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/preview_card_button.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/preview_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AiProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: customAppBar(
        title: 'ai_review_title'.tr,
        titleStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'back'.tr,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: PreviewCardWidget(parsedDataEx: provider.parsedDataEx),
              ),
            ),
            PreviewCardButton(
              // Back to the input with the text kept, so it can be fixed.
              onEdit: () => Navigator.of(context).pop(),
              onSave: provider.parsedDataEx.isEmpty
                  ? null
                  : () {
                      provider.saveTransaction(context);
                      // Back to the home screen that opened the assistant,
                      // keeping its state, rather than building a new one.
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Get.snackbar(
                        '',
                        'ai_saved'.tr,
                        titleText: const SizedBox.shrink(),
                        icon: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                        ),
                        backgroundColor: AppColors.success,
                        colorText: Colors.white,
                        borderRadius: 12,
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 2),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
