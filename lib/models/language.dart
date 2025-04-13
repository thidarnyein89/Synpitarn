class Language {
  String en = "";
  String mm = "";
  String th = "";

  Language.defaultLanguage();

  Language({required this.en, required this.mm, required this.th});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      en: json['en'],
      mm: json['mm'],
      th: json['th'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'mm': mm,
      'th': th,
    };
  }
}
