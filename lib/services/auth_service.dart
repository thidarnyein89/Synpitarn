import 'package:flutter/cupertino.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';

class AuthService {

  void logout(BuildContext context) {
    setLoginUser(User.defaultUser());
    setLoginStatus(false);

    RouteService.goToMain(context);
  }

}