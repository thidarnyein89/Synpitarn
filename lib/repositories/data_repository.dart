import 'package:http/http.dart' as http;
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/data_response.dart';

class DataRepository {

  Future<DataResponse> getLoanTypes() async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/data/loan-types");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print(response.body);
    return DataResponse.dataResponseFromJson(response.body);
  }

  Future<DataResponse> getTimesPerMonth() async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/data/times-per-month");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    return DataResponse.dataResponseFromJson(response.body);
  }

  Future<DataResponse> getProvinces() async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/data/provinces");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    return DataResponse.dataResponseFromJson(response.body);
  }

}
