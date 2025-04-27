class LoanStatus {
  static List<String> PENDING_STATUS = ["pending", "complete-review"];
  static List<String> PRE_APPROVE_STATUS = [
    "pre-approved",
    "thlo-approved",
    "approved",
    "agree",
    "ready-to-disburse",
    "disburse-approved",
  ];
  static List<String> DISBURSE_STATUS = ["disbursed", "paid"];
  static List<String> REJECT_STATUS = ["reject"];
  static List<String> POSTPONE_STATUS = ["postpone"];

  static List<String> APPOINTMENT_PENDING_STATUS = ["pending"];
  static List<String> APPOINTMENT_DONE_STATUS = ["accept", "done"];
}