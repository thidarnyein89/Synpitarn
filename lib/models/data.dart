import 'package:synpitarn/data/language.dart';

class Item {
  String value = "";
  Data? text;

  Item.defaultItem();

  Item.named({required this.value, required String text}) {
    List<String> parts = text.split("|").map((e) => e.trim()).toList();
    this.text = Data(
      id: 0,
      key: value,
      mm: parts.length > 0 ? parts[0] : parts[0],
      en: parts.length > 1 ? parts[1] : parts[0],
      th: parts.length > 2 ? parts[2] : parts[0],
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item.defaultItem()
      ..value = json['value'] ?? ''
      ..text = Data.fromJson(json['text'] ?? {});
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'text': text?.toJson(),
    };
  }
}

class Data {
  int id = 0;
  String key = "";
  String en = "";
  String mm = "";
  String th = "";

  Data.defaultData();

  Data(
      {required this.id,
      required this.key,
      required this.en,
      required this.mm,
      required this.th});

  Data.named(this.id, this.key, String text) {
    List<String> parts = text.split("|").map((e) => e.trim()).toList();
    mm = parts.length > 0 ? parts[0] : parts[0];
    en = parts.length > 1 ? parts[1] : parts[0];
    th = parts.length > 2 ? parts[2] : parts[0];
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      key: json.containsKey('key') ? json['key'] : '',
      en: json.containsKey('name') ? json['name'] : json['name_en'] ?? '',
      mm: json.containsKey('name') ? json['name'] : json['name_mm'] ?? '',
      th: json.containsKey('name') ? json['name'] : json['name_th'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'en': en,
      'mm': mm,
      'th': th,
    };
  }

  String getText() {
    switch (Language.currentLanguage) {
      case LanguageType.my:
        return mm;
      case LanguageType.th:
        return th;
      default:
        return en;
    }
  }
}
