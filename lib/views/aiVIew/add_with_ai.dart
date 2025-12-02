import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/providers/speechProvider/speech_provider.dart';
import 'package:finance_manager_app/views/aiVIew/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddWithAiScreen extends StatefulWidget {
  const AddWithAiScreen({super.key});

  @override
  State<AddWithAiScreen> createState() => _AddWithAiScreenState();
}

class _AddWithAiScreenState extends State<AddWithAiScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Sync SpeechProvider with AiProvider's controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final aiProvider = Provider.of<AiProvider>(context, listen: false);
      final speechProvider = Provider.of<SpeechProvider>(
        context,
        listen: false,
      );
      speechProvider.setController(aiProvider.textController);
    });
  }

  Widget _buildInputSection() {
    final provider = Provider.of<AiProvider>(context);
    final speechProvider = Provider.of<SpeechProvider>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Input Area
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    controller: provider.textController,
                    focusNode: provider.focusNode,
                    maxLines: 5,
                    minLines: 3,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.5, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'input_placeholder_detailed'.tr,
                      hintStyle: TextStyle(
                        color: AppColors.textMuted.withValues(alpha: 0.4),
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  if (provider.textController.text.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          provider.textController.clear();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        tooltip: 'clear'.tr,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Controls Row
            Align(
              alignment: Alignment.centerRight,
              child: _buildVoiceInputControl(speechProvider),
            ),

            const SizedBox(height: 32),

            // Minimal Examples
            Text(
              'try_examples'.tr.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            _buildPromptExamples(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInputControl(SpeechProvider speechProvider) {
    final isListening = speechProvider.isListening;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isListening
              ? Colors.redAccent.withValues(alpha: 0.5)
              : Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: (isListening ? Colors.redAccent : AppColors.primaryBlue)
                .withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Language Selector Part
          Container(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: speechProvider.selectedLanguage.startsWith('bn')
                    ? 'bn'
                    : 'en',
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                isDense: true,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
                items: [
                  DropdownMenuItem(
                    value: "bn",
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("🇧🇩 Bangla")],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "en",
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("🇺🇸 English")],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) speechProvider.setLanguage(value);
                },
              ),
            ),
          ),

          // Divider
          Container(
            height: 24,
            width: 1,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          ),

          // Mic Button Part
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              if (isListening) {
                speechProvider.stopListening();
              } else {
                speechProvider.startListening();
              }
            },
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                  key: ValueKey(isListening),
                  color: isListening ? Colors.redAccent : AppColors.primaryBlue,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptExamples(AiProvider provider) {
    final examples = [
      'spent_50_groceries'.tr,
      'lunch_25_today'.tr,
      "my_salary".tr,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: examples.map((text) {
        return InkWell(
          onTap: () {
            provider.textController.text = text;
            provider.focusNode.requestFocus();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'analyzing_transaction'.tr,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'please_wait'.tr,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
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
        title: 'ai_assistant_title'.tr,
        titleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
        backgroundColor: Colors.transparent,
        leading: provider.isLoading
            ? null
            : IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                tooltip: 'back'.tr,
              ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: provider.isLoading ? _buildLoadingState() : _buildInputSection(),
      ),
      bottomNavigationBar: provider.isLoading
          ? null
          : ProcessButtonWidget(onTap: () => _handleProcessInput(provider)),
    );
  }

  void _handleProcessInput(AiProvider provider) async {
    final text = provider.textController.text.trim();
    // final hasNumber = RegExp(r'[0-9০-৯]+').hasMatch(text);

    if (text.isEmpty) {
      _showErrorSnackbar(
        title: 'empty_field'.tr,
        message: 'fields_empty_error'.tr,
        backgroundColor: AppColors.error,
      );
      return;
    }

    HapticFeedback.selectionClick();
    final success = await provider.processInput();

    if (success) {
      Get.to(() => const PreviewScreen())?.then((_) {
        provider.setLoading(false);
      });
    }
  }

  void _showErrorSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: Icon(
        backgroundColor == AppColors.error
            ? Icons.error_outline
            : Icons.warning_amber_rounded,
        color: Colors.white,
      ),
    );
  }
}

// Enhanced Process Button
class ProcessButtonWidget extends StatelessWidget {
  final void Function()? onTap;

  const ProcessButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0),
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.primaryPurple],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'process_with_ai'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
