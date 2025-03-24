import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/models/otp.dart';
import 'package:synpitarn/screens/auth/otp.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/auth_repository.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPasswordPage> {

  final TextEditingController phoneController = TextEditingController();
  String? phoneError;
  bool isPhoneValidate = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validatePhoneValue);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _validatePhoneValue() {
    setState(() {
      phoneError = null;
      isPhoneValidate = phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  Future<void> handleResetPin() async {
    User user = User.defaultUser();
    user.phoneNumber = phoneController.text;
    user.forgetPassword = true;

    OTP otpResponse = await AuthRepository().getOTP(user);

    if(otpResponse.response.code != 200) {
      phoneError = otpResponse.response.message;
    }
    else {
      user.code = otpResponse.data;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OTPPage(loginUser: user)),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot PIN code',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 100),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                ],
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    prefixText: '+66 ',
                    border: OutlineInputBorder(),
                    errorText: phoneError,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isPhoneValidate && isPhoneValidate ? handleResetPin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reset PIN code',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
