import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/auth/register.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/screens/auth/forget_password.dart';
import 'package:synpitarn/data/app_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool _isObscured = true;
  String? phoneError;
  String? pinError;
  bool isPhoneValidate = false;
  bool isPinValidate = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validatePhoneValue);
    pinController.addListener(_validatePinValue);
  }

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
  }

  void _validatePhoneValue() {
    setState(() {
      phoneError = null;
      isPhoneValidate =
          phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  void _validatePinValue() {
    setState(() {
      pinError = null;
      isPinValidate =
          pinController.text.isNotEmpty && pinController.text.length == 6;
    });
  }

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });

    User user = User.defaultUser();
    user.phoneNumber = phoneController.text;
    user.code = pinController.text;
    user.type = "pincode";

    Login loginResponse = await AuthRepository().login(user);

    if (loginResponse.response.code != 200) {
      String msg = loginResponse.response.message.toLowerCase();

      if (msg.contains("phone")) {
        phoneError = loginResponse.response.message;
      } else {
        pinError = loginResponse.response.message;
      }
    } else {
      AppConfig.LOGIN_IN_USER = loginResponse.data;
      setState(() {});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/synpitarn.jpg', height: 180),
                      SizedBox(height: 10),
                      Text(
                        'Welcome from Synpitarn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
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
                      TextField(
                        controller: pinController,
                        obscureText: _isObscured,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          labelText: 'PIN',
                          border: OutlineInputBorder(),
                          errorText: pinError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage(),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot PIN code",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            isPhoneValidate && isPinValidate && !isLoading
                                ? handleLogin
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
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
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account, ",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "click here",
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
