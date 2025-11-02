import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/ai_textfield_widget.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/preview_card_button.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/preview_card_widget.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/process_button_widget.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/suggestion_chips_widget.dart';
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
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildSpeechStatusBanner() {
    final provider = Provider.of<AiProvider>(context);

    // If speech is enabled, no need to show anything
    if (provider.speechEnabled) return const SizedBox.shrink();

    // Determine message
    final message =
        provider.speechErrorMessage ??
        'Speech recognition not available on this device.';

    // ⚠️ Show GetX Snackbar instead of a visible banner
    Future.microtask(() {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Speech Error ⚠️',
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () => provider.initSpeech(),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        );
      }
    });

    // Return nothing (no visible banner)
    return const SizedBox.shrink();
  }

  Widget _buildVoiceButton() {
    final provider = Provider.of<AiProvider>(context);

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
          _buildSpeechStatusBanner(),
          SuggestionChipsWidget(textController: provider.textController),
          const SizedBox(height: 32),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Analyzing...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
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
        title: "AI Assistant",
        leading: IconButton(
          onPressed: () => Get.back(),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Analyzing...',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
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
      bottomNavigationBar: provider.showPreview
          ? null
          : ProcessButtonWidget(
              isLoading: provider.isLoading,
              onTap: () {
                final text = provider.textController.text.trim();
                final hasNumber = RegExp(r'\d+').hasMatch(text);

                if (text.isEmpty) {
                  Get.snackbar(
                    'Empty Field ⚠️',
                    'Fields can’t be empty.',
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
                    'Invalid Input ❌',
                    'Please enter a valid transaction prompt (e.g., "Paid 500 for food").',
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
