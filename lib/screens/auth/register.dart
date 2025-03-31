import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/auth/nrc.dart';
import 'package:synpitarn/screens/auth/otp.dart';
import 'package:synpitarn/screens/auth/term_conditions.dart';
import 'package:synpitarn/models/otp.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nrcController = TextEditingController();
  final TextEditingController passportController = TextEditingController();

  bool isChecked = false;

  String? phoneError;
  String? nrcError;
  String? passportError;

  bool isPhoneValidate = false;
  bool isNRCValidate = false;
  bool isPassportValidate = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validatePhoneValue);
    nrcController.addListener(_validateNRCValue);
    passportController.addListener(_validatePassportValue);

    setState(() {});
  }

  @override
  void dispose() {
    phoneController.dispose();
    nrcController.dispose();
    passportController.dispose();
    super.dispose();
  }

  void _validatePhoneValue() {
    setState(() {
      phoneError = null;
      isPhoneValidate =
          phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  void _validateNRCValue() {
    setState(() {
      nrcError = null;
      isNRCValidate = nrcController.text.isNotEmpty;
    });
  }

  void _validatePassportValue() {
    setState(() {
      passportError = null;
      isPassportValidate =
          passportController.text.isNotEmpty &&
          passportController.text.length == 6;
    });
  }

  Future<void> showTermAndConditions() async {
    bool isShowDialog = true;

    if (isChecked) {
      setState(() {
        isChecked = false;
        isShowDialog = false;
      });
    }

    if (isShowDialog) {
      var result = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              child: TermAndConditionsPage(),
            ),
          );
        },
      );

      if (result != null) {
        setState(() {
          isChecked = true;
        });
      }
    }
  }

  Future<void> showNRCDialog() async {
    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            height: 365,
            width: MediaQuery.of(context).size.width,
            child: NRCPage(key: UniqueKey(), nrcValue: nrcController.text),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        nrcController.text = result;
      });
    }
  }

  Future<void> handleRegister() async {
    setState(() {
      isLoading = true;
    });

    User user = User.defaultUser();
    user.phoneNumber = phoneController.text;
    user.identityNumber = nrcController.text;
    user.passport = passportController.text;
    user.forgetPassword = false;
    user.status = "active";

    Login registerResponse = await AuthRepository().register(user);

    if (registerResponse.response.code != 200) {
      String msg = registerResponse.response.message.toLowerCase();

      if (msg.contains("phone")) {
        phoneError = registerResponse.response.message;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  5,
                ), // Reduce the border radius
              ),
              content: Text(registerResponse.response.message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Got it"),
                ),
              ],
            );
          },
        );
      }
    } else {
      OTP otpResponse = await AuthRepository().getOTP(user);

      if (otpResponse.response.code != 200) {
        phoneError = otpResponse.response.message;
      } else {
        user.code = otpResponse.data;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OTPPage(loginUser: user)),
        );
      }
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to SynPitarn',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'SynPitarn will use this phone number as the primary authentication method. Please fill in the phone number that you always use and is with you. ',
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      prefixText: '+66 ',
                      border: OutlineInputBorder(),
                      errorText: phoneError,
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      showNRCDialog();
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: nrcController,
                        decoration: InputDecoration(
                          labelText: 'NRC',
                          border: OutlineInputBorder(),
                          errorText: nrcError,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passportController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Passport',
                      border: OutlineInputBorder(),
                      errorText: passportError,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          showTermAndConditions();
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showTermAndConditions();
                          },
                          child: Text(
                            " I agree to SynPitarn Co. Ltd's terms and conditions",
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    " When you click continue you will be asked to agree to our terms. After that you will be sent an OTP to the phone number that you gave us. ",
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        isPhoneValidate && isPassportValidate && isNRCValidate && isChecked && !isLoading
                            ? handleRegister
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        isLoading
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 16, // Match text height
                                  width: 16, // Keep it proportional
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2, // Adjust thickness
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Please Wait...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
