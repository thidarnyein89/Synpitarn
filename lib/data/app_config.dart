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
  static String NO_CURRENT_LOAN = "There is no apply loan";

  static List<String> PENDING_STATUS = ["pending", "complete-review"];
  static List<String> PRE_APPROVE_STATUS = [
    "pre-approved",
    "agree",
    "thlo-approved",
    "disburse-approved",
  ];
  static List<String> APPROVE_STATUS = ["disbursed"];
  static List<String> REJECT_STATUS = ["reject"];
}
