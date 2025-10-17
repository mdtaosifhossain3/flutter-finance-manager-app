import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:finance_manager_app/views/aiVIew/service/voice_service.dart';
import 'package:finance_manager_app/views/mainView/Myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWithAiScreen extends StatefulWidget {
  const AddWithAiScreen({super.key});

  @override
  State<AddWithAiScreen> createState() => _AddWithAiScreenState();
}

class _AddWithAiScreenState extends State<AddWithAiScreen> {
  final TextEditingController _textController = TextEditingController();
  final VoiceService _voiceService = VoiceService();

  String _voiceText = '';
  bool _isListening = false;
  bool _isLoading = false;
  Map<String, dynamic>? _aiResult;

  @override
  void initState() {
    super.initState();
    _voiceService.init();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Rebuild so Generate button enabled/disabled updates
    if (mounted) setState(() {});
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _isListening = true;
        _voiceText = '';
      });
      await _voiceService.startListening(
        onResult: (text) {
          setState(() => _voiceText = text);
        },
        onStatus: (status) {
          // when speech_to_text reports done, stop listening state
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Speech Error: $error")));
        },
      );
    }
  }

  Future<void> _generateTransaction(String text) async {
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please type or speak a transaction first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _aiResult = null;
    });

    try {
      // TODO: Replace this mock with your AI API call / parser
      await Future.delayed(const Duration(seconds: 2));

      // Mock result -- replace with parsed result from your AI
      setState(() {
        _aiResult = {
          'amount': 350, // parse numeric value from text in real impl
          'category': 'Groceries', // parse category
          'note': text,
          'date': DateTime.now(),
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to analyze: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// When user presses the "Save & Generate" for voice input:
  /// copy voiceText into the text field and immediately generate.
  Future<void> _onSpeechSave() async {
    if (_voiceText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No voice input to save.")),
      );
      return;
    }

    _textController.text = _voiceText;
    await _generateTransaction(_voiceText);
  }

  /// When user presses Generate (for typed input)
  Future<void> _onGeneratePressed() async {
    final text = _textController.text;
    await _generateTransaction(text);
  }

  /// Final save after AI result confirmed
  void _onSavePressed() {
    // TODO: integrate DB / provider save here using _aiResult
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction added successfully!')),
    );
    Navigator.pop(context);
  }

  bool get _canGenerate {
    // generate possible if either text field has text OR voice text is present (but voice flow uses Save & Generate)
    return _textController.text.trim().isNotEmpty && !_isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "addtransactionwithai",leading: IconButton(onPressed: (){
        Get.to(()=>MyHomePage());
      }, icon: Icon(Icons.arrow_back))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input field
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Describe your transaction\n(e.g., Bought coffee 120)",
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 15),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.chat, color: Theme.of(context).primaryColor, size: 24),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: Theme.of(context).primaryColor, size: 24),
                      onPressed: _toggleListening,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
                maxLines: 6,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 16),

              // Live speech preview (separate flow). Save & Generate here affects textfield + generates.
              if (_voiceText.isNotEmpty || _isListening)
                Card(
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isListening ? "Listening..." : "Voice Input",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(_voiceText.isEmpty ? "Say something..." : _voiceText),
                        const SizedBox(height: 10),
                        if (!_isListening && _voiceText.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _onSpeechSave,
                            icon: const Icon(Icons.save),
                            label: const Text("Save & Generate"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          )
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Generate button for typed text
              ElevatedButton.icon(
                onPressed: _canGenerate ? _onGeneratePressed : null,
                icon: const Icon(Icons.auto_awesome, size: 22),
                label: const Text(
                  "Generate Transaction",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  disabledBackgroundColor: AppColors.textMuted,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),

              const SizedBox(height: 20),

              // Loading / Result section
              if (_isLoading)
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Analyzing your transaction...",
                        style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                    ],
                  ),
                )
              else if (_aiResult != null) ...[
                _buildAiResultCard(_aiResult!),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _onSavePressed,
                  icon: const Icon(Icons.check_circle, size: 22),
                  label: const Text(
                    "Save Transaction",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purpleGradientEnd,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ],

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiResultCard(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user, color: Theme.of(context).primaryColor, size: 22),
                const SizedBox(width: 8),
                const Text(
                  "AI Detected Transaction",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildResultRow("💰", "Amount", "${data['amount']}"),
            const SizedBox(height: 12),
            _buildResultRow("📂", "Category", data['category']),
            const SizedBox(height: 12),
            _buildResultRow("📝", "Note", data['note']),
            const SizedBox(height: 12),
            _buildResultRow(
              "📅",
              "Date",
              "${(data['date'] as DateTime).day}/${(data['date'] as DateTime).month}/${(data['date'] as DateTime).year}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
