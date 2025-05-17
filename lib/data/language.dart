import 'dart:ui';

import 'package:synpitarn/data/shared_value.dart';

enum LanguageType { my, en, th }

class Language {
  static LanguageType defaultLanguage = LanguageType.my;
  static LanguageType currentLanguage = defaultLanguage;
  late Locale locale;
  late String label;
  late String image;

  Language({required this.locale, required this.label, required this.image}) {
    getLanguage().then((language) => currentLanguage = language);
  }
}

class LanguageData {
  static List<Language> languages = [
    Language(
        locale: Locale(LanguageType.my.name), label: 'Myanmar', image: 'assets/images/my.png'),
    Language(
        locale: Locale(LanguageType.en.name), label: 'English', image: 'assets/images/en.png'),
    Language(locale: Locale(LanguageType.th.name), label: 'Thai', image: 'assets/images/th.png')
  ];
}
