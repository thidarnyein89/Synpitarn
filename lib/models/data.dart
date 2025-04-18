class Item {
  String value = "";
  Data? text;

  Item.defaultItem();

  Item.named({required this.value, required String text}) {
    List<String> parts = text.split("|").map((e) => e.trim()).toList();
    this.text = Data(
      id: 0,
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
  String en = "";
  String mm = "";
  String th = "";

  Data.defaultData();

  Data({
    required this.id, required this.en, required this.mm, required this.th
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      en: json.containsKey('name') ? json['name'] : json['name_en'] ?? '',
      mm: json.containsKey('name') ? json['name'] : json['name_mm'] ?? '',
      th: json.containsKey('name') ? json['name'] : json['name_th'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en': en,
      'mm': mm,
      'th': th,
    };
  }
}
