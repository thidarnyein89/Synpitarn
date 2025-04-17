import 'package:http/http.dart' as http;
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/models/user.dart';

class DefaultRepository {
  Future<DefaultResponse> getDefaultData(User loginRequest) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/form/type/default");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginRequest.token}",
        "x-user-id": loginRequest.id.toString(),
      },
    );

    return DefaultResponse.defaultResponseFromJson(response.body);
  }

}
