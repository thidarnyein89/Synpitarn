import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/data/app_config.dart';

import '../../data/shared_value.dart';

class SetPasswordPage extends StatefulWidget {
  User loginUser;

  SetPasswordPage({super.key, required this.loginUser});

  @override
  SetPasswordState createState() => SetPasswordState();
}

class SetPasswordState extends State<SetPasswordPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pin1Controller = TextEditingController();
  final TextEditingController pin2Controller = TextEditingController();

  bool _isObscured1 = true;
  bool _isObscured2 = true;
  String? pin1Error;
  String? pin2Error;
  bool isPin1Validate = false;
  bool isPin2Validate = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.loginUser.phoneNumber;
    pin1Controller.addListener(_validatePin1Value);
    pin2Controller.addListener(_validatePin2Value);
  }

  @override
  void dispose() {
    phoneController.dispose();
    pin1Controller.dispose();
    pin2Controller.dispose();
    super.dispose();
  }

  void _validatePin1Value() {
    setState(() {
      pin1Error = null;
      isPin1Validate =
          pin1Controller.text.isNotEmpty && pin1Controller.text.length == 6;
    });
  }

  void _validatePin2Value() {
    setState(() {
      pin2Error = null;
      isPin2Validate =
          pin2Controller.text.isNotEmpty && pin2Controller.text.length == 6;
    });
  }

  Future<void> handleSetPassowrd() async {
    if (pin1Controller.text != pin2Controller.text) {
      pin2Error = "PIN code must be identical";
      isPin2Validate = false;
      setState(() {});
    } else {
      setState(() {
        isLoading = true;
      });

      User user = User.defaultUser();
      user.token = widget.loginUser.token;
      user.forgetPassword = widget.loginUser.forgetPassword;
      user.phoneNumber = phoneController.text;
      user.code = pin1Controller.text;

      Login loginResponse = await AuthRepository().setPassword(user);

      if (loginResponse.response.code != 200) {
        pin1Error = loginResponse.response.message;
      } else {
        await setLoginUser(loginResponse.data);
        await setLoginStatus(true);

        setState(() {});

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }

      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
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
                        'Set Your Pin Code',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(height: 40),
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
                        controller: pin1Controller,
                        obscureText: _isObscured1,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // Allow only digits
                          LengthLimitingTextInputFormatter(6),
                          // Limit to 10 digits
                        ],
                        decoration: InputDecoration(
                          labelText: 'PIN',
                          border: OutlineInputBorder(),
                          errorText: pin1Error,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured1 = !_isObscured1;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: pin2Controller,
                        obscureText: _isObscured2,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // Allow only digits
                          LengthLimitingTextInputFormatter(6),
                          // Limit to 10 digits
                        ],
                        decoration: InputDecoration(
                          labelText: 'Confirm PIN',
                          border: OutlineInputBorder(),
                          errorText: pin2Error,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured2 = !_isObscured2;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            isPin1Validate && isPin2Validate && !isLoading
                                ? handleSetPassowrd
                                : null, // Disable when fields are empty
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
                                  'Set New Password',
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
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: AppConfig.PROFILE_INDEX,
        onItemTapped: (index) {
          setState(() {
            AppConfig.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }
}
