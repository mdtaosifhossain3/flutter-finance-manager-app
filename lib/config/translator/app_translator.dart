import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {'settings': 'Hello', 'welcome': 'Welcome'},
    'bn_BD': {'settings': 'হ্যালো', 'welcome': 'স্বাগতম'},
  };
}
