import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../my_theme.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  OTPState createState() => OTPState();
}

class OTPState extends State<OTPPage> {

  final TextEditingController otpController  = TextEditingController();

  String? otpError;
  bool isOTPValidate = false;

  int _secondsRemaining = 60; // Countdown Timer
  late Timer _timer;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    otpController.addListener(_validateOTPValue);
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _validateOTPValue() {
    setState(() {
      otpError = null;
      isOTPValidate = otpController.text.isNotEmpty && otpController.text.length == 6;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResendOtp = true;
          _timer.cancel();
        });
      }
    });
  }

  void resendOtp() {
    setState(() {
      _secondsRemaining = 60;
      _canResendOtp = false;
    });
    startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP Resend")),
    );
  }

  void handleVerifyOTP() {
    String otp = otpController.text;
    // Add authentication logic here
    print("Phone: $otp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                ),
                onChanged: (value) {},
              ),
              SizedBox(height: 10),
              if(_secondsRemaining > 0)
                Text(
                  "OTP Code will expire in 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              if(_secondsRemaining <= 0)
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
            ],
          ),
        ),
      ),
    );
  }
}
