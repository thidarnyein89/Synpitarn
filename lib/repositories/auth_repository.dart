import 'package:synpitarn/data_model/request/login_request.dart';

import '../data_model/response/login_response.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(LoginRequest loginRequest) async {
    var post_body = jsonEncode({
      "email": "${email}",
      "password": "$password",
      "identity_matrix": AppConfig.purchase_code,
      "login_by": loginBy
    });

    String url = ("${AppConfig.BASE_URL}/auth/login");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body);

    return loginResponseFromJson(response.body);
  }
}