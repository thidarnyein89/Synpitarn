import 'dart:convert';

import 'package:synpitarn/models/default/pages.dart';

class DefaultData {
  Map<String, dynamic>? inputData;
  int versionId = 0;
  List<Pages> pages = [];

  DefaultData.defaultDefaultData();

  DefaultData({
    required this.inputData,
    required this.versionId,
    required this.pages,
  });

  factory DefaultData.defaultDataResponseFromJson(String str) =>
      DefaultData.fromJson(json.decode(str));

  factory DefaultData.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic> tempInputData = {};
    List<Pages> tempPages = [];

    if (json['input_data'] != null && json['input_data']['input_data'] != null) {
      tempInputData = json['input_data'];
    }
    else {
      tempInputData["version_id"] = json['pages'][0]['version_id'];
    }

    if (json['pages'] != null && json['pages'] is List) {
      for (var item in json['pages']) {
        tempPages.add(Pages.fromJson(item));
      }
    }

    return DefaultData(
      inputData: json['input_data'] == null ? {} : jsonDecode(tempInputData["input_data"]),
      versionId: tempInputData["version_id"],
      pages: tempPages
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "input_data": {
        "input_data": jsonEncode(inputData),
        "version_id": versionId,
      },
      "pages": pages.map((page) => page.toJson()).toList(),
    };
  }

  String defaultDataResponseToJson() => json.encode(toJson());

}
