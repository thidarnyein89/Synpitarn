import 'package:synpitarn/models/default/item.dart';
import 'package:synpitarn/models/default/validation_rule.dart';

class FormWidget {
  final String uniqueId;
  final String type;
  final String name;
  final String label;
  final String subLabel;
  final bool isShowLabel;
  final String placeholderText;
  final String containerClass;
  final String additionalContainerClass;
  final String additionalFieldClass;
  final String additionalLabelClass;
  final String defaultValue;
  final List<ValidationRule> validations;
  final String typeAttribute;
  final String dataMode;
  final bool multiple;
  final List<Item> items;
  final String apiURL;
  final String apiTextKey;
  final String apiValueKey;

  FormWidget({
    required this.uniqueId,
    required this.type,
    required this.name,
    required this.label,
    required this.subLabel,
    required this.isShowLabel,
    required this.placeholderText,
    required this.containerClass,
    required this.additionalContainerClass,
    required this.additionalFieldClass,
    required this.additionalLabelClass,
    required this.defaultValue,
    required this.validations,
    required this.typeAttribute,
    required this.dataMode,
    required this.multiple,
    required this.items,
    required this.apiURL,
    required this.apiTextKey,
    required this.apiValueKey,
  });

  factory FormWidget.fromJson(Map<String, dynamic> json) {
    return FormWidget(
      uniqueId: json['uniqueId'] ?? "",
      type: json['type'] ?? "",
      name: json['name'] ?? "",
      label: json['label'] ?? "",
      subLabel: json['subLabel'] ?? "",
      isShowLabel: json['isShowLabel'] ?? "",
      placeholderText: json['placeholderText'] ?? "",
      containerClass: json['containerClass'] ?? "",
      additionalContainerClass: json['additionalContainerClass'] ?? "",
      additionalFieldClass: json['additionalFieldClass'] ?? "",
      additionalLabelClass: json['additionalLabelClass'] ?? "",
      defaultValue: json['defaultValue'] ?? "",
      validations: (json['validations'] as List)
          .map((v) => ValidationRule.fromJson(v))
          .toList(),
      typeAttribute: json['typeAttribute'] ?? "",
      dataMode: json['dataMode'] ?? "",
      multiple: json['multiple'] ?? false,
      items: json.containsKey('items')
          ? (json['items'] as List).map((item) => Item.fromJson(item)).toList()
          : [],
      apiURL: json['apiURL'] ?? "",
      apiTextKey: json['apiTextKey'] ?? "",
      apiValueKey: json['apiValueKey'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uniqueId': uniqueId,
      'type': type,
      'name': name,
      'label': label,
      'subLabel': subLabel,
      'isShowLabel': isShowLabel,
      'placeholderText': placeholderText,
      'containerClass': containerClass,
      'additionalContainerClass': additionalContainerClass,
      'additionalFieldClass': additionalFieldClass,
      'additionalLabelClass': additionalLabelClass,
      'defaultValue': defaultValue,
      'validations': validations.map((v) => v.toJson()).toList(),
      'typeAttribute': typeAttribute,
      'dataMode': dataMode,
      'multiple': multiple,
      'items': items.map((item) => item.toJson()).toList(),
      'apiURL': apiURL,
      'apiTextKey': apiTextKey,
      'apiValueKey': apiValueKey,
    };
  }
}
