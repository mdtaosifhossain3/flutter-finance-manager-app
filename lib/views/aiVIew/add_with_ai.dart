import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/providers/aiProvider/ai_provider.dart';
import 'package:finance_manager_app/providers/speechProvider/speech_provider.dart';
import 'package:finance_manager_app/views/aiVIew/preview_screen.dart';
import 'package:finance_manager_app/views/aiVIew/widgets/ai_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddWithAiScreen extends StatefulWidget {
  /// Start listening right away (opened from the home screen widget's mic).
  final bool startVoice;

  const AddWithAiScreen({super.key, this.startVoice = false});

  @override
  State<AddWithAiScreen> createState() => _AddWithAiScreenState();
}

class _AddWithAiScreenState extends State<AddWithAiScreen> {
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
      if (widget.startVoice) speechProvider.startListening();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AiProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: customAppBar(
        title: 'ai_assistant_title'.tr,
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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ai_heading'.tr,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ai_subheading'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _InputCard(provider: provider),
                    const SizedBox(height: 28),
                    Text(
                      'ai_examples_title'.tr,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final key in [
                      'ai_example_1',
                      'ai_example_2',
                      'ai_example_3',
                    ])
                      _ExampleTile(
                        text: key.tr,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          provider.textController.text = key.tr;
                          provider.textController.selection =
                              TextSelection.collapsed(
                                offset: provider.textController.text.length,
                              );
                        },
                      ),
                  ],
                ),
              ),
            ),
            // Part of the body (not bottomNavigationBar) so it stays above
            // the keyboard.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: provider.textController,
              builder: (context, value, _) => AiPrimaryButton(
                label: 'process_with_ai'.tr,
                icon: Icons.auto_awesome_rounded,
                onTap: value.text.trim().isEmpty
                    ? null
                    : () => _handleProcessInput(provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleProcessInput(AiProvider provider) async {
    FocusScope.of(context).unfocus();
    final speech = Provider.of<SpeechProvider>(context, listen: false);
    if (speech.isListening) speech.stopListening();

    final success = await provider.processInput();
    if (success) {
      Get.to(() => const PreviewScreen())?.then((_) {
        provider.setLoading(false);
      });
    }
  }
}

/// Text box with the microphone built in, so typing and speaking live
/// together.
class _InputCard extends StatelessWidget {
  final AiProvider provider;

  const _InputCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final speech = Provider.of<SpeechProvider>(context);
    final listening = speech.isListening;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: listening
              ? AppColors.error.withValues(alpha: 0.6)
              : theme.dividerColor.withValues(alpha: 0.4),
          width: listening ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: provider.textController,
            focusNode: provider.focusNode,
            minLines: 4,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: listening ? 'ai_listening'.tr : 'ai_input_hint'.tr,
              hintStyle: TextStyle(
                color: listening
                    ? AppColors.error.withValues(alpha: 0.8)
                    : AppColors.textMuted.withValues(alpha: 0.7),
                fontSize: 17,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                _LanguageToggle(speech: speech),
                const Spacer(),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: provider.textController,
                  builder: (context, value, _) => value.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            provider.clearInput();
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: AppColors.textMuted,
                          tooltip: 'clear'.tr,
                        ),
                ),
                const SizedBox(width: 4),
                _MicButton(speech: speech),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  final SpeechProvider speech;

  const _MicButton({required this.speech});

  @override
  Widget build(BuildContext context) {
    final listening = speech.isListening;

    return Tooltip(
      message: listening ? 'ai_listening'.tr : 'ai_tap_to_speak'.tr,
      child: Material(
        color: listening ? AppColors.error : AppColors.primaryBlue,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            HapticFeedback.selectionClick();
            listening ? speech.stopListening() : speech.startListening();
          },
          child: SizedBox(
            width: 52,
            height: 52,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                listening ? Icons.stop_rounded : Icons.mic_rounded,
                key: ValueKey(listening),
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Picks the voice language. Only affects speaking; typing works in any.
class _LanguageToggle extends StatelessWidget {
  final SpeechProvider speech;

  const _LanguageToggle({required this.speech});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBangla = speech.selectedLanguage.startsWith('bn');

    Widget option(String label, String code, bool selected) => GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        speech.setLanguage(code);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: selected ? Colors.white : AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          option('বাংলা', 'bn', isBangla),
          option('EN', 'en', !isBangla),
        ],
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ExampleTile({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: AppColors.primaryBlue.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
                Icon(
                  Icons.north_west_rounded,
                  size: 16,
                  color: AppColors.textMuted.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
