import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/my_theme.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/screens/auth/set_password.dart';

import 'package:synpitarn/models/otp.dart';

class OTPPage extends StatefulWidget {
  User loginUser;

  OTPPage({super.key, required this.loginUser});

  @override
  OTPState createState() => OTPState();
}

class OTPState extends State<OTPPage> {

  final TextEditingController otpController  = TextEditingController();
  String code = "";

  String? otpError = "";
  bool isOTPValidate = false;

  int _minuteRemaining = 3;
  int _secondsRemaining = 0; // Countdown Timer
  late Timer _timer;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    otpController.addListener(_validateOTPValue);
    code = widget.loginUser.code;
    setState(() {});
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _validateOTPValue() {
    setState(() {
      otpError = "";
      isOTPValidate = otpController.text.isNotEmpty && otpController.text.length == 6;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--; // Decrease seconds
        });
      } else {
        if (_minuteRemaining > 0) {
          setState(() {
            _minuteRemaining--;  // Decrease minutes
            _secondsRemaining = 59; // Reset seconds to 59
          });
        } else {
          setState(() {
            _canResendOtp = true; // Allow OTP resend after countdown finishes
            _timer.cancel(); // Cancel the timer
          });
        }
      }
    });
  }

  Future<void> resendOtp() async {
    otpError = "";
    code = "";
    otpController.text = "";

    User user = User.defaultUser();
    user.phoneNumber = widget.loginUser.phoneNumber;
    user.forgetPassword = widget.loginUser.forgetPassword;

    OTP otpResponse = await AuthRepository().getOTP(user);

    if(otpResponse.response.code != 200) {
      otpError = otpResponse.response.message;
    }
    else {
      user.code = otpResponse.data;
      code = otpResponse.data;

      _minuteRemaining = 3;
      _secondsRemaining = 0;
      _canResendOtp = false;
    }

    setState(() {});

    startTimer();
  }

  Future<void> handleVerifyOTP() async {
    User user = User.defaultUser();
    user.code = otpController.text;
    user.forgetPassword = widget.loginUser.forgetPassword;
    user.phoneNumber = widget.loginUser.phoneNumber;

    Login loginResponse = await AuthRepository().checkOTP(user);

    if(loginResponse.response.code != 200) {
      otpError = loginResponse.response.message;
    }
    else {
      user.token = loginResponse.data.token;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SetPasswordPage(loginUser: user)),
      );
    }

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify OTP code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 100),
                  Text(
                    "Please enter the 6 digits number that we have sent to you here then click \"Verify OTP Code\" below.",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    obscuringCharacter: '●',
                    keyboardType: TextInputType.number,
                    controller: otpController,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.grey,
                      selectedFillColor: Colors.white,
                      activeColor: Colors.grey,
                      selectedColor: MyTheme.primary_color,
                      errorBorderColor: otpError == null ? Colors.grey : Colors.red,
                      borderWidth: 2,
                    ),
                    onChanged: (value) {},
                  ),
                  if (otpError != null)
                    Text(
                      otpError!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  SizedBox(height: 20),
                  if(!_canResendOtp)
                    Text(
                      "OTP Code will expire in ${_minuteRemaining.toString().padLeft(2, '0')}:${_secondsRemaining.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  if(_canResendOtp)
                    RichText(
                      text: TextSpan(
                        text: "OTP not received? ",
                        style: TextStyle(
                          color: Colors.black, // Normal text color
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Resend OTP Code",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                resendOtp();
                              },
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isOTPValidate ? handleVerifyOTP : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Verify OTP Code',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                      "OTP Code ${code}"
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
