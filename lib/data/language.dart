import 'dart:ui';

enum LanguageType { my, en, th }

class Language {
  static LanguageType currentLanguage = LanguageType.my;
  late Locale locale;
  late String label;
  late String image;

  Language({required this.locale, required this.label, required this.image});
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
