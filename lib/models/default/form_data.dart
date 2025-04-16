import 'dart:convert';

import 'package:synpitarn/models/default/form_widget.dart';

class FormData {
  final Map<String, dynamic> formConfig;
  final Map<String, dynamic> sections;
  final Map<String, dynamic> rows;
  final List<FormWidget> controls;

  FormData({
    required this.formConfig,
    required this.sections,
    required this.rows,
    required this.controls,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    List<FormWidget> controlList = [];

    final controlsJson = json['controls'] ?? {};
    for (final key in controlsJson.keys) {
      final controlMap = controlsJson[key] as Map<String, dynamic>;
      controlList.add(FormWidget.fromJson(controlMap));
    }

    return FormData(
      formConfig: json['formConfig'] ?? {},
      sections: json['sections'] ?? {},
      rows: json['rows'] ?? {},
      controls: controlList,
    );
  }
}
