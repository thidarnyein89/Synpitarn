import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/models/nrc.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/home.dart';

import 'package:synpitarn/services/common_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CommonService _commonService = CommonService();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController nrcController = TextEditingController();

  List<NRC> nrcList = [];
  List<Township> townshipList = [];
  List<String> citizenList = ["N", "P", "E", "C"];

  String selectedState = "1";
  String selectedTownship = "";
  String selectedCitizen = "N";

  bool _isObscured = true;
  bool isChecked = false;

  String? phoneError;
  String? pinError;

  bool isPhoneValidate = false;
  bool isPinValidate = false;

  @override
  void initState() {
    super.initState();
    readNRCData();
    phoneController.addListener(_validatePhoneValue);
    pinController.addListener(_validatePinValue);
  }

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
  }

  Future<void> readNRCData() async {
    nrcList = await _commonService.readNRCData();
    townshipList = nrcList.where((nrc) => nrc.state == selectedState).expand((nrc) => nrc.townshipList).toList();
    selectedTownship = townshipList.first.name;

    setState(() {});
  }

  void _validatePhoneValue() {
    setState(() {
      phoneError = null;
      isPhoneValidate = phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  void _validatePinValue() {
    setState(() {
      pinError = null;
      isPinValidate = pinController.text.isNotEmpty && pinController.text.length == 6;
    });
  }

  Future<void> handleLogin() async {
    User user = User.defaultUser();
    user.phoneNumber = phoneController.text;
    user.code = pinController.text;

    Login loginResponse = await AuthRepository().login(user);

    if (loginResponse.response.code != 200) {
      String msg = loginResponse.response.message.toLowerCase();

      if (msg.contains("phone")) {
        phoneError = loginResponse.response.message;
      } else {
        pinError = loginResponse.response.message;
      }
    } else {
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
                      ' SynPitarn will use this phone number as the primary authentication method. Please fill in the phone number that you always use and is with you. '
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
                  SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: DropdownButtonFormField<String>(
                            value: selectedState,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedState = newValue!;
                              });
                            },
                            items: nrcList.map<DropdownMenuItem<String>>((NRC nrc) {
                              return DropdownMenuItem<String>(
                                value: nrc.state,
                                child: Text(nrc.state),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: '',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedTownship,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTownship = newValue!;
                              });
                            },
                            items: townshipList.map<DropdownMenuItem<String>>((Township township) {
                              return DropdownMenuItem<String>(
                                value: township.name,
                                child: Text(township.name, overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: '',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Flexible(
                          child: DropdownButtonFormField<String>(
                            value: selectedCitizen,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCitizen = newValue!;
                              });
                            },
                            items: citizenList.map<DropdownMenuItem<String>>((String citizen) {
                              return DropdownMenuItem<String>(
                                value: citizen,
                                child: Text(citizen),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: '',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Flexible(
                          child: TextField(
                            controller: nrcController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: InputDecoration(
                              labelText: '',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
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
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked = newValue!;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        child: Text("Accept Terms & Conditions"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isPhoneValidate && isPinValidate ? handleLogin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Navigate to signup or relevant page
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account, ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
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
      ),
    );
  }
}
