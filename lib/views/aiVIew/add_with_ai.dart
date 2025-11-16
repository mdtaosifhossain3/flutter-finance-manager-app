import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/ai_textfield_widget.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/preview_card_button.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/preview_card_widget.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/process_button_widget.dart';
import 'package:finance_manager_app/views/mainView/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddWithAiScreen extends StatefulWidget {
  const AddWithAiScreen({super.key});

  @override
  State<AddWithAiScreen> createState() => _AiMoneyAssistantViewState();
}

class _AiMoneyAssistantViewState extends State<AddWithAiScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    // Don't start animation here - only start when recording
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildVoiceButton() {
    final provider = Provider.of<AiProvider>(context);

    // Start/stop animation based on recording state
    if (provider.isRecording && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!provider.isRecording && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            provider.toggleRecording();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: provider.isRecording
                  ? LinearGradient(
                      colors: [
                        AppColors.error,
                        AppColors.error.withValues(alpha: 0.7),
                      ],
                    )
                  : LinearGradient(
                      colors: [AppColors.primaryBlue, AppColors.primaryPurple],
                    ),
              boxShadow: [
                BoxShadow(
                  color:
                      (provider.isRecording
                              ? AppColors.error
                              : AppColors.primaryBlue)
                          .withValues(
                            alpha: provider.isRecording
                                ? 0.4 * _pulseController.value
                                : 0.3,
                          ),
                  blurRadius: provider.isRecording
                      ? 30 + (20 * _pulseController.value)
                      : 20,
                  spreadRadius: provider.isRecording
                      ? 5 * _pulseController.value
                      : 0,
                ),
              ],
            ),
            child: Icon(
              provider.isRecording ? Icons.stop : Icons.mic,
              size: 36,
              color: AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputSection() {
    final provider = Provider.of<AiProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 24,
      ),
      child: Column(
        children: [
          AiTextFieldWidget(
            focusNode: provider.focusNode,
            textController: provider.textController,
          ),
          const SizedBox(height: 24),
          _buildVoiceButton(),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final provider = Provider.of<AiProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 24,
      ),
      child: provider.isLoading
          ? Center(
              child:  SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.white,
                ),
              ),
            )
          : Column(
              children: [
                PreviewCardWidget(parsedDataEx: provider.parsedDataEx),
                const SizedBox(height: 24),
                PreviewCardButton(
                  editTransactionButton: () {
                    HapticFeedback.selectionClick();
                    provider.editTransaction();
                  },
                  deleteTransactionButton: () {
                    HapticFeedback.lightImpact();
                    provider.deleteTransaction();
                  },
                  saveTransactionButton: () {
                    HapticFeedback.mediumImpact();
                    provider.saveTransaction(context);
                  },
                ),
              ],
            ),
    );


  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AiProvider>(context);

    return Scaffold(
      appBar: customAppBar(
        title: "ai_assistant".tr,
        leading: IconButton(
          onPressed: () => Get.to(MainView()),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: provider.showPreview
                      ? _buildPreview()
                      : _buildInputSection(),
                ),
              ],
            ),
            // Loading overlay
            if (provider.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.55),
                  child: Center(
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: provider.showPreview
          ? null
          : ProcessButtonWidget(
              isLoading: provider.isLoading,
              onTap: () {
                final text = provider.textController.text.trim();
                final hasNumber = RegExp(r'\d+').hasMatch(text);

                if (text.isEmpty) {
                  Get.snackbar(
                    'empty_field'.tr,
                    'fields_empty_error'.tr,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.error.withValues(alpha: 0.9),
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(10),
                    borderRadius: 10,
                    duration: const Duration(seconds: 2),
                  );
                  return;
                } else if (!hasNumber) {
                  Get.snackbar(
                    'invalid_input'.tr,
                    'invalid_prompt_error'.tr,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.warning.withValues(alpha: 0.9),
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(10),
                    borderRadius: 10,
                    duration: const Duration(seconds: 3),
                  );
                  return;
                }

                HapticFeedback.selectionClick();
                provider.processInput();
              },
            ),
    );
  }
}
