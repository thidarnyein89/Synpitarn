import 'package:flutter/material.dart';
import 'package:synpitarn/models/language.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/application_response.dart';
import 'package:synpitarn/models/loan_application.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';

class Information1Page extends StatefulWidget {
  const Information1Page({super.key});

  @override
  Information1State createState() => Information1State();
}

class Information1State extends State<Information1Page> {
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'dob': TextEditingController(),
    'gender': TextEditingController(),
    'maritalStatus': TextEditingController(),
    'nationality': TextEditingController(),
    'education': TextEditingController(),
    'residence': TextEditingController(),
    'employmentName': TextEditingController(),
    'officeLocation': TextEditingController(),
    'branch': TextEditingController(),
    'testing': TextEditingController(),
  };

  final List<Language> genderList = [
    Language(en: "Male", mm: "ကျား", th: "ชาย"),
    Language(en: "Female", mm: "မ", th: "หญิง"),
  ];

  final List<String> maritalStatusList = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Other',
  ];

  final List<String> nationalityList = [
    'Thai',
    'Myanmar',
    'Khmer',
    'Laotian',
    'Other'
  ];

  final List<String> educationList = [
    'Basic',
    'Middle',
    'High',
    'Graduated',
    'No formal Education'
  ];

  final List<String> branchList = [
    'Pathumthani',
    'Lad Lum Kaeo Temporary service Center',
    'Bang Bon',
    'Lat Krabang'
  ];

  final Set<String> inValidFields = {};

  String? _error;

  String? selectedGender;
  String? selectedMaritalStatus;
  String? selectedNationality;
  String? selectedEduction;
  String? selectedBranch;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controllers.forEach((key, controller) {
      inValidFields.add(key);
      controller.addListener(() => _inValidateField(key));
    });
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _inValidateField(String key) {
    setState(() {
      _error = null;
      if (controllers[key]!.text.isEmpty) {
        inValidFields.add(key);
      } else {
        inValidFields.remove(key);
      }
    });
  }

  Future<void> handleContinue() async {
    setState(() {
      isLoading = true;
    });

    User loginUser = await getLoginUser();

    LoanApplication loanApplication = LoanApplication.defaultLoanApplication();
    loanApplication.name = controllers['name']!.text;
    loanApplication.martialStatus = controllers['maritalStatus']!.text;
    loanApplication.residence = controllers['residence']!.text;
    loanApplication.nameOfEmployment = controllers['employmentName']!.text;
    loanApplication.officeLocation = controllers['officeLocation']!.text;
    loanApplication.dob = controllers['dob']!.text;
    loanApplication.branch = controllers['branch']!.text;
    loanApplication.education = controllers['education']!.text;
    loanApplication.gender = controllers['gender']!.text;
    loanApplication.nationality = controllers['nationality']!.text;
    loanApplication.testing = controllers['testing']!.text;

    ApplicationResponse loanApplicationResponse = await ApplicationRepository()
        .saveCustomerInformation(loanApplication, loginUser);
    if (loanApplicationResponse.response.code != 200) {
      showErrorDialog('Error is occur, please contact admin');
    } else {
      loginUser.loanFormState = "customer_information";
      await setLoginUser(loginUser);
      isLoading = false;
      setState(() {});

      RouteService.checkLoginUserData(context);
    }
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showErrorDialog(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final maxDate = DateTime(today.year - 18, today.month, today.day);
    final minDate = DateTime(today.year - 56, today.month, today.day);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomStyle.primary_color,
        title: Text('Customer Information', style: CustomStyle.appTitle()),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            RouteService.goToHome(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                  child: Column(
                spacing: 0,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterTabBar(activeStep: 0),
                  Padding(
                    padding: CustomStyle.pageWithoutTopPadding(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidget.textField(
                            controller: controllers['name']!,
                            label: 'Name (in English)'),
                        CustomWidget.datePicker(
                            context: context,
                            controller: controllers['dob']!,
                            label: 'Date of Birth',
                            readOnly: true,
                            maxDate: maxDate,
                            minDate: minDate),
                        CustomWidget.dropdownButtonFormField(
                          label: 'Gender',
                          selectedValue: selectedGender,
                          items: genderList.map((gender) => gender.en).toList(),
                          onChanged: (value) {
                            setState(() {
                              inValidFields.remove('gender');
                              selectedGender = value!;
                            });
                          },
                        ),
                        CustomWidget.dropdownButtonFormField(
                          label: 'Marital Status',
                          selectedValue: selectedMaritalStatus,
                          items: maritalStatusList,
                          onChanged: (value) {
                            setState(() {
                              inValidFields.remove('maritalStatus');
                              selectedMaritalStatus = value!;
                            });
                          },
                        ),
                        CustomWidget.dropdownButtonFormField(
                          label: 'Nationality',
                          selectedValue: selectedNationality,
                          items: nationalityList,
                          onChanged: (value) {
                            setState(() {
                              inValidFields.remove('nationality');
                              selectedNationality = value!;
                            });
                          },
                        ),
                        CustomWidget.dropdownButtonFormField(
                          label: 'Education',
                          selectedValue: selectedEduction,
                          items: educationList,
                          onChanged: (value) {
                            setState(() {
                              inValidFields.remove('education');
                              selectedEduction = value!;
                            });
                          },
                        ),
                        CustomWidget.textField(
                            controller: controllers['residence']!,
                            label: 'Residence'),
                        CustomWidget.textField(
                            controller: controllers['employmentName']!,
                            label: 'Name of Employment'),
                        CustomWidget.textField(
                            controller: controllers['officeLocation']!,
                            label: 'Current Work Address'),
                        CustomWidget.dropdownButtonFormField(
                          label: 'Branch',
                          selectedValue: selectedBranch,
                          items: branchList,
                          onChanged: (value) {
                            setState(() {
                              inValidFields.remove('branch');
                              selectedBranch = value!;
                            });
                          },
                        ),
                        CustomWidget.textField(
                            controller: controllers['testing']!,
                            label: 'Testing'),
                        CustomWidget.elevatedButton(
                            disabled: inValidFields.isEmpty,
                            isLoading: isLoading,
                            text: 'Continue',
                            onPressed: handleContinue)
                      ],
                    ),
                  ),
                ],
              )),
            ),
          );
        },
      ),
    );
  }
}
