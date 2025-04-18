import 'package:synpitarn/models/user.dart';

class AppConfig {
  static String BASE_URL = "https://uat.synpitarn.com";
  static String PATH = "api/client";

  // For Bottom Navigation Bar Index
  static int HOME_INDEX = 0;
  static int LOAN_INDEX = 1;
  static int PROFILE_INDEX = 2;
  static int SETTING_INDEX = 3;
  static int CURRENT_INDEX = 0;

  static String INPUT_TYPE = "input";
  static String DROPDOWN_TYPE = "dropDown";

  static String ERR_MESSAGE = "Error is occur, please contact admin";

}

enum APPOINTMENT_STATUS { pending, approve, reject }
