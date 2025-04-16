class Item {
  String value = "";
  String text = "";

  Item({required this.value, required this.text});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      value: json['value'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'text': text,
    };
  }
}
