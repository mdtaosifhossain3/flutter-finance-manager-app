import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;

  /// Initialize the speech recognizer
  Future<void> init() async {
    _isAvailable = await _speech.initialize();
  }

  bool get isListening => _isListening;

  /// Start listening and return recognized words in real time
  Future<void> startListening({
    required Function(String text) onResult,
    Function(String status)? onStatus,
    Function(String error)? onError,
  }) async {
    if (!_isAvailable) await init();

    if (_isAvailable) {
      _isListening = true;
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenMode: stt.ListenMode.confirmation,
        onSoundLevelChange: (level) {},
      );
      _speech.statusListener = (status) {
        if (onStatus != null) onStatus(status);
      };
      _speech.errorListener = (error) {
        if (onError != null) onError(error.errorMsg);
      };
    } else {
      debugPrint("Speech recognition not available");
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
  }

  /// Cancel the speech recognition session completely
  Future<void> cancel() async {
    await _speech.cancel();
    _isListening = false;
  }
}
