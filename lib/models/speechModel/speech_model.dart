class SpeechModel {
  final String text;
  final String languageCode;
  final bool isBangla;

  SpeechModel({
    required this.text,
    required this.languageCode,
    required this.isBangla,
  });

  String get displayText {
    return '${isBangla ? '🇧🇩' : '🇺🇸'} $text';
  }

  SpeechModel copyWith({
    String? text,
    String? languageCode,
    DateTime? timestamp,
    bool? isBangla,
  }) {
    return SpeechModel(
      text: text ?? this.text,
      languageCode: languageCode ?? this.languageCode,
      isBangla: isBangla ?? this.isBangla,
    );
  }
}
