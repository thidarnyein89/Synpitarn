import 'dart:convert';

import 'package:synpitarn/models/default/form_data.dart';

class Pages {
  final String type;
  final FormData formData;

  Pages({required this.type, required this.formData});

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      type: json['type'] ?? '',
      formData: FormData.fromJson(jsonDecode(json['form_data'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'form_data': formData,
    };
  }
}
