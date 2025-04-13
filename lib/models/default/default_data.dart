import 'package:synpitarn/models/document.dart';

class DefaultData {
  String? inputData;

  DefaultData.defaultDefaultData();

  DefaultData({
    required this.inputData,
  });

  factory DefaultData.fromJson(Map<String, dynamic> json) {
    return DefaultData(inputData: json['input_data']["input_data"]);
  }

  Map<String, dynamic> toJson() {
    return {'input_data': inputData};
  }
}
