class LoginRequest {
  String phone_number;
  String type;
  String code;

  set setPhoneNumber(String phone_number) {
    this.phone_number = phone_number;
  }

  set setType(String type) {
    this.type = type;
  }

  set setCode(String code) {
    this.code = code;
  }

  get getPhoneNumber {
    return this.phone_number;
  }

  get getType {
    return this.type;
  }

  get getCode {
    return this.code;
  }
}