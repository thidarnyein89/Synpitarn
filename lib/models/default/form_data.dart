import 'package:synpitarn/models/default/form_widget.dart';

class FormData {
  final Map<String, dynamic> formConfig;
  final Map<String, dynamic> sections;
  final Map<String, dynamic> rows;
  final Map<String, FormWidget> controls;

  FormData({
    required this.formConfig,
    required this.sections,
    required this.rows,
    required this.controls,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    return FormData(
      formConfig: json['formConfig'] ?? {},
      sections: json['sections'] ?? {},
      rows: json['rows'] ?? {},
      controls: json['controls'] ?? {},
    );
  }
}
