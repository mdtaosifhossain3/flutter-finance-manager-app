import 'package:finance_manager_app/models/speechModel/speech_model.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechProvider with ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  final List<SpeechModel> _speechHistory = [];

  // Internal controller if no external one is provided
  final TextEditingController _internalController = TextEditingController();

  // Reference to the active controller (defaults to internal)
  TextEditingController? _externalController;

  TextEditingController get textEditingController =>
      _externalController ?? _internalController;

  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isBangla = false;
  String _lastWords = '';
  String _selectedLanguage = 'en-US';

  // Getters
  bool get speechEnabled => _speechEnabled;
  bool get isListening => _isListening;
  bool get isBangla => _isBangla;
  String get lastWords => _lastWords;
  String get selectedLanguage => _selectedLanguage;
  List<SpeechModel> get speechHistory => _speechHistory;
  String get currentText => textEditingController.text;

  // Set external controller
  void setController(TextEditingController controller) {
    _externalController = controller;
    // Don't notify listeners here to avoid build loops if called during build
  }

  // Set language explicitly
  void setLanguage(String langCode) {
    if (langCode == 'bn') {
      _selectedLanguage = 'bn-BD';
      _isBangla = true;
    } else {
      _selectedLanguage = 'en-US';
      _isBangla = false;
    }
    notifyListeners();
  }

  // Initialize speech recognition
  Future<void> initializeSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        _isListening = _speechToText.isListening;
        notifyListeners();
      },
      onError: (error) {
        //  print('Speech error: $error');
        _isListening = false; // Ensure listening state is reset on error
        notifyListeners();
      },
    );
    notifyListeners();
  }

  // Start listening
  Future<void> startListening() async {
    if (!_speechEnabled) {
      await initializeSpeech(); // Try initializing if not enabled
      if (!_speechEnabled) return;
    }

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: Duration(minutes: 4),
      pauseFor: Duration(seconds: 15),
      localeId: _selectedLanguage,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.confirmation,
      ),
    );

    _isListening = true;
    notifyListeners();
  }

  // Stop listening
  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    notifyListeners();
  }

  // Handle speech results
  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;

    // Update the active controller
    textEditingController.text = _lastWords;
    // Move cursor to end
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: _lastWords.length),
    );

    if (result.finalResult && _lastWords.trim().isNotEmpty) {
      _addToHistory(_lastWords);
    }
    notifyListeners();
  }

  // Add to history
  void _addToHistory(String text) {
    final speechEntry = SpeechModel(
      text: text,
      languageCode: _selectedLanguage,
      isBangla: _isBangla,
    );

    _speechHistory.insert(0, speechEntry);

    // Keep only last 50 entries
    if (_speechHistory.length > 50) {
      _speechHistory.removeLast();
    }
  }

  // Switch language (Toggle)
  void switchLanguage() {
    if (_selectedLanguage.startsWith('en')) {
      setLanguage('bn');
    } else {
      setLanguage('en');
    }
  }

  // Clear history
  void clearHistory() {
    _speechHistory.clear();
    _lastWords = '';
    textEditingController.clear();
    notifyListeners();
  }

  // Add manual text
  void addManualText(String text) {
    if (text.trim().isNotEmpty) {
      textEditingController.text = text;
      _addToHistory(text);
    }
  }

  // Load text from history
  void loadFromHistory(SpeechModel speech) {
    textEditingController.text = speech.text;
    _selectedLanguage = speech.languageCode;
    _isBangla = speech.isBangla;
    notifyListeners();
  }

  // Update current text
  void updateCurrentText(String text) {
    textEditingController.text = text;
    notifyListeners();
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }
}
