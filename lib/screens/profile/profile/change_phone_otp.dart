import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/profile_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/route_service.dart';

class ChangePhoneOTPPage extends StatefulWidget {
  User loginUser;

  ChangePhoneOTPPage({super.key, required this.loginUser});

  @override
  ChangePhoneOTPState createState() => ChangePhoneOTPState();
}

class ChangePhoneOTPState extends State<ChangePhoneOTPPage> {
  User loginUser = User.defaultUser();

  final TextEditingController otpController = TextEditingController();
  String code = "";

  String? otpError = "";
  bool isOTPValidate = false;

  int _minuteRemaining = 3;
  int _secondsRemaining = 0; // Countdown Timer
  late Timer _timer;
  bool _canResendOtp = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    otpController.addListener(_validateOTPValue);
    startTimer();

    setInitData();
    setState(() {});
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> setInitData() async {
    loginUser = await getLoginUser();
    code = widget.loginUser.code;
    setState(() {});
  }

  void _validateOTPValue() {
    setState(() {
      otpError = "";
      isOTPValidate =
          otpController.text.isNotEmpty && otpController.text.length == 6;
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
            _minuteRemaining--; // Decrease minutes
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

  Future<void> getOTP() async {
    otpError = "";
    code = "";
    otpController.text = "";

    var postBody = {
      "forget_password": false,
      "phone_number": widget.loginUser.phoneNumber
    };

    UserResponse userResponse =
        await ProfileRepository().getOTP(postBody, loginUser);

    if (userResponse.response.code == 200) {
      code = userResponse.data.code;
      _minuteRemaining = 3;
      _secondsRemaining = 0;
      _canResendOtp = false;
    } else if (userResponse.response.code == 403) {
      await showErrorDialog(userResponse.response.message);
      AuthService().logout(context);
    } else {
      otpError = userResponse.response.message;
    }

    setState(() {});

    startTimer();
  }

  Future<void> handleVerifyOTP() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> postBody = {
      'phone_number': widget.loginUser.phoneNumber,
      'code': otpController.text,
    };

    UserResponse profileResponse =
        await ProfileRepository().changePhoneNumber(postBody, loginUser);
    if (profileResponse.response.code == 200) {
      await setLoginUser(widget.loginUser);
      _timer.cancel();
      RouteService.goToReplaceNavigator(context, ProfileHomePage());
    } else if (profileResponse.response.code == 403) {
      await showErrorDialog(profileResponse.response.message);
      AuthService().logout(context);
    } else {
      otpError = profileResponse.response.message;
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Verify OTP Code'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Please enter the 6 digits number that we have sent to you here then click \"Verify OTP Code\" below.",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 20),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        autoFocus: true,
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
                          selectedColor: CustomStyle.primary_color,
                          errorBorderColor:
                              otpError == null ? Colors.grey : Colors.red,
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
                      if (!_canResendOtp)
                        Text(
                          "OTP Code will expire in ${_minuteRemaining.toString().padLeft(2, '0')}:${_secondsRemaining.toString().padLeft(2, '0')}",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      if (_canResendOtp)
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
                                    getOTP();
                                  },
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 20),
                      CustomWidget.elevatedButton(
                          context: context,
                          enabled: isOTPValidate,
                          isLoading: isLoading,
                          text: 'Verify OTP Code',
                          onPressed: handleVerifyOTP),
                      Text("OTP Code $code"),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
