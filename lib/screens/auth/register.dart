import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/models/login.dart';
import 'package:synpitarn/models/nrc.dart';
import 'package:synpitarn/repositories/auth_repository.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/auth/otp.dart';
import 'package:synpitarn/screens/home.dart';

import 'package:synpitarn/services/common_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CommonService _commonService = CommonService();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nrcController = TextEditingController();
  final TextEditingController passportController = TextEditingController();

  List<NRC> nrcList = [];
  List<Township> townshipList = [];
  List<String> citizenList = ["N", "P", "E", "C"];

  String selectedState = "1";
  String selectedTownship = "";
  String selectedCitizen = "N";

  bool isChecked = false;

  String? phoneError;
  String? nrcError;
  String? passportError;

  bool isPhoneValidate = false;
  bool isNRCValidate = false;
  bool isPassportValidate = false;

  @override
  void initState() {
    super.initState();
    readNRCData();
    phoneController.addListener(_validatePhoneValue);
    nrcController.addListener(_validateNRCValue);
    passportController.addListener(_validatePassportValue);
  }

  @override
  void dispose() {
    phoneController.dispose();
    nrcController.dispose();
    passportController.dispose();
    super.dispose();
  }

  Future<void> readNRCData() async {
    setState(() async {
      nrcList = await _commonService.readNRCData();
      setTownshipData();
    });
  }

  void setTownshipData() {
    townshipList = nrcList.where((nrc) => nrc.state == selectedState).expand((nrc) => nrc.townshipList).toList();
    townshipList.sort((a, b) => a.name.compareTo(b.name));

    selectedTownship = townshipList.first.name;

    setState(() {});
  }

  void _validatePhoneValue() {
    setState(() {
      phoneError = null;
      isPhoneValidate = phoneController.text.isNotEmpty && phoneController.text.length == 10;
    });
  }

  void _validateNRCValue() {
    setState(() {
      nrcError = null;
      isNRCValidate = nrcController.text.isNotEmpty && nrcController.text.length == 6;
    });
  }

  void _validatePassportValue() {
    setState(() {
      passportError = null;
      isPassportValidate = passportController.text.isNotEmpty && passportController.text.length == 6;
    });
  }

  Future<void> handleRegister() async {
    User user = User.defaultUser();
    user.phoneNumber = phoneController.text;
    user.identityNumber = "$selectedState/$selectedTownship($selectedCitizen)${nrcController.text}";
    user.passport = passportController.text;
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
                borderRadius: BorderRadius.circular(5), // Reduce the border radius
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
      user.forgetPassword = false;
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
                                setTownshipData();
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
                        SizedBox(width: 1),
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
                        SizedBox(width: 1),
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
                        SizedBox(width: 1),
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
                          setState(() {
                            isChecked = newValue!;
                          });
                        },
                      ),
                      Expanded(child:
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                          child: Text(" I agree to SynPitarn Co. Ltd's terms and conditions",
                            softWrap: true, maxLines: 2,),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(" When you click continue you will be asked to agree to our terms. After that you will be sent an OTP to the phone number that you gave us. "),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isPhoneValidate && isPassportValidate && isNRCValidate && isChecked ? handleRegister : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
