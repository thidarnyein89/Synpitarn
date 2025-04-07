import 'package:http/http.dart' as http;
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/data/app_config.dart';

import '../models/application.dart';

class ApplicationRepository {
  Future<Application> getApplication(User loginRequest) async {
    String url = ("${AppConfig.BASE_URL}/${AppConfig.PATH}/loan/application");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${loginRequest.token}",
        "x-user-id": loginRequest.id.toString(),
      },
    );

    return Application.applicationResponseFromJson(response.body);
  }
}
