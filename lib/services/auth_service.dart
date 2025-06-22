import 'package:flutter/cupertino.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';

class AuthService {
  Future<void> logout(BuildContext context) async {
    User loginUser = await getLoginUser();
    User user = User.defaultUser();
    user.phoneNumber = loginUser.phoneNumber;

    setLoginUser(user);
    setLoginStatus(false);

    RouteService.goToMain(context);
  }
}
