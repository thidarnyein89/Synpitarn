import 'dart:ui';

class Language {
  late Locale locale;
  late String label;
  late String image;

  Language({required this.locale, required this.label, required this.image});
}

class LanguageData {
  static List<Language> languages = [
    Language(
        locale: Locale('my'), label: 'Myanmar', image: 'assets/images/my.png'),
    Language(
        locale: Locale('en'), label: 'English', image: 'assets/images/en.png'),
    Language(locale: Locale('th'), label: 'Thai', image: 'assets/images/th.png')
  ];
}
