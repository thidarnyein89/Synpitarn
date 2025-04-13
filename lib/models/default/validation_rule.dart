class ValidationRule {
  final String ruleType;
  final String errorMessage;
  final String additionalValue;

  ValidationRule({
    required this.ruleType,
    required this.errorMessage,
    required this.additionalValue,
  });

  factory ValidationRule.fromJson(Map<String, dynamic> json) {
    return ValidationRule(
      ruleType: json['ruleType'],
      errorMessage: json['errorMessage'],
      additionalValue: json['additionalValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ruleType': ruleType,
      'errorMessage': errorMessage,
      'additionalValue': additionalValue,
    };
  }
}