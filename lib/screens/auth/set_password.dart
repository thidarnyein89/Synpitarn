import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/home.dart';
import 'forget_password.dart';

class SetPasswordPage extends StatefulWidget {
  User loginUser;

  SetPasswordPage({super.key, required this.loginUser});

  @override
  SetPasswordState createState() => SetPasswordState();
}

class SetPasswordState extends State<SetPasswordPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool _isObscured = true;
  String? pinError;
  bool isPinValidate = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.loginUser.phoneNumber;
    pinController.addListener(_validatePinValue);
  }

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
  }

  void _validatePinValue() {
    setState(() {
      pinError = null;
      isPinValidate = pinController.text.isNotEmpty && pinController.text.length == 6;
    });
  }

  Future<void> handleSetPassowrd() async {

    User user = User.defaultUser();
    user.token = widget.loginUser.token;
    user.forgetPassword = widget.loginUser.forgetPassword;
    user.phoneNumber = phoneController.text;
    user.code = pinController.text;

    Login loginResponse = await AuthRepository().setPassword(user);

    if(loginResponse.response.code != 200) {
      pinError = loginResponse.response.message;
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
                  'Set Your Pin Code',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 100),
                TextField(
                  controller: phoneController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    prefixText: '+66 ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: pinController,
                  obscureText: _isObscured,
                  keyboardType: TextInputType.phone,inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  LengthLimitingTextInputFormatter(6), // Limit to 10 digits
                ],
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    border: OutlineInputBorder(),
                    errorText: pinError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isPinValidate ? handleSetPassowrd : null, // Disable when fields are empty
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Set New Password',
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
