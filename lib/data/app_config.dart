import 'package:synpitarn/models/user.dart';

class AppConfig {
  static String BASE_URL = "https://uat.synpitarn.com";
  static String PATH = "api/client";

  // For Bottom Navigation Bar Index
  static int HOME_INDEX = 0;
  static int PROFILE_INDEX = 1;
  static int SETTING_INDEX = 2;
  static int CURRENT_INDEX = 0;

  static User LOGIN_IN_USER = User.defaultUser();
}