import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/route_service.dart';

class CustomerInformationPage extends StatefulWidget {
  User? client = User.defaultUser();

  CustomerInformationPage({super.key, this.client});

  @override
  CustomerInformationState createState() => CustomerInformationState();
}

class CustomerInformationState extends State<CustomerInformationPage> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  final Map<String, TextEditingController> textControllers = {
    'name': TextEditingController(),
    'residence': TextEditingController(),
    'name_of_employment': TextEditingController(),
    'office_location': TextEditingController(),
    'dob': TextEditingController(),
    'testing': TextEditingController(),
  };

  Map<String, dynamic> dropdownControllers = {
    'martial_status': null,
    'branch': null,
    'education': null,
    'gender': null,
    'nationality': null,
  };

  Map<String, dynamic> itemDataList = {
    'martial_status': [Item.defaultItem()],
    'branch': [Item.defaultItem()],
    'education': [Item.defaultItem()],
    'gender': [Item.defaultItem()],
    'nationality': [Item.defaultItem()],
  };

  final Set<String> inValidFields = {};

  int pageIndex = 0;
  String stepName = "customer_information";
  bool isLoading = false;
  bool isPageLoading = true;

  @override
  void initState() {
    super.initState();
    getDefaultData();
  }

  @override
  void dispose() {
    textControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> getDefaultData() async {
    isPageLoading = true;
    setState(() {});

    defaultData = new DefaultData.defaultDefaultData();
    loginUser = await getLoginUser();

    DefaultResponse defaultResponse =
        await DefaultRepository().getDefaultData(loginUser);

    if (defaultResponse.response.code == 200) {
      defaultData = defaultResponse.data;
      Map<String, dynamic>? inputData = defaultData.inputData;

      var controls = defaultData.pages[pageIndex].formData.controls;

      setItemDataList(controls);
      setSavedData(inputData!);
    }

    inValidFieldsAdd();

    isPageLoading = false;
    setState(() {});
  }

  void setItemDataList(var controls) {
    itemDataList.forEach((key, item) {
      var control = controls.firstWhere((control) => control.name == key);

      if (control.items != null) {
        itemDataList[key] = control.items!
            .where((item) => item.value != "")
            .map<Item>((item) => Item.named(value: item.value, text: item.text))
            .toList();
        setState(() {});
      }
    });
  }

  void inValidFieldsAdd() {
    textControllers.forEach((key, controller) {
      _inValidateField(key);
      controller.addListener(() => _inValidateField(key));
    });

    dropdownControllers.forEach((key, item) {
      inValidFields.remove(key);
      if (dropdownControllers[key] is Item &&
          dropdownControllers[key].value.isEmpty) {
        inValidFields.add(key);
      } else if (dropdownControllers[key] is List<Item> &&
          dropdownControllers[key].isEmpty) {
        inValidFields.add(key);
      }
    });

    setState(() {});
  }

  void _inValidateField(String key) {
    setState(() {
      inValidFields.remove(key);

      if (textControllers[key]!.text.isEmpty) {
        inValidFields.add(key);
      } else {
        inValidFields.remove(key);
      }
    });
  }

  void setSavedData(Map<String, dynamic> inputData) {
    textControllers.forEach((key, TextEditingController) {
      if (inputData.containsKey(key)) {
        textControllers[key]!.text = inputData[key];
      } else if (loginUser.toJson().containsKey(key)) {
        textControllers[key]!.text = loginUser.toJson()[key];
      }
    });

    print("====");
    print(loginUser.toJson()['dob']);
    print(loginUser.toJson()['phone_number']);

    dropdownControllers.forEach((key, dynamic) {
      if (inputData.containsKey(key)) {
        dropdownControllers[key] =
            findMatchData(itemDataList[key]!, inputData[key]);
      }
    });
  }

  Item? findMatchData(List<Item> itemList, String value) {
    Iterable<Item> matchingItems =
        itemList.where((item) => item.value == value);
    return matchingItems.isNotEmpty ? matchingItems.first : null;
  }

  Future<void> handleContinue() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> additionalInformation = {
      ...?defaultData.inputData
    };

    textControllers.forEach((key, controller) {
      additionalInformation[key] = textControllers[key]!.text;
    });

    dropdownControllers.forEach((key, dynamic) {
      additionalInformation[key] = dropdownControllers[key]!.value;
    });

    final Map<String, dynamic> postBody = {
      'version_id': defaultData.versionId,
      'input_data': jsonEncode(additionalInformation),
    };

    DataResponse saveResponse = await LoanRepository()
        .saveLoanApplicationStep(postBody, loginUser, stepName);
    if (saveResponse.response.code != 200) {
      showErrorDialog(saveResponse.response.message);
    } else {
      loginUser.loanFormState = stepName;
      await setLoginUser(loginUser);
      isLoading = false;
      setState(() {});

      RouteService.profile(context);
    }
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
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
      appBar: PageAppBar(title: 'Customer Information'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(children: [
            if (isPageLoading)
              CustomWidget.loading()
            else
              SingleChildScrollView(
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
                                controller: textControllers['name']!,
                                label: 'Name (in English)'),
                            CustomWidget.datePicker(
                                context: context,
                                controller: textControllers['dob']!,
                                label: 'Date of Birth',
                                readOnly: true,
                                maxDate: maxDate,
                                minDate: minDate),
                            CustomWidget.dropdownButtonDiffValue(
                              label: 'Gender',
                              selectedValue: dropdownControllers['gender'],
                              items: itemDataList['gender']!,
                              onChanged: (value) {
                                setState(() {
                                  inValidFields.remove('gender');
                                  dropdownControllers['gender'] = value!;
                                });
                              },
                            ),
                            CustomWidget.dropdownButtonDiffValue(
                              label: 'Marital Status',
                              selectedValue:
                                  dropdownControllers['martial_status'],
                              items: itemDataList['martial_status']!,
                              onChanged: (value) {
                                setState(() {
                                  inValidFields.remove('martial_status');
                                  dropdownControllers['martial_status'] =
                                      value!;
                                });
                              },
                            ),
                            CustomWidget.dropdownButtonDiffValue(
                              label: 'Nationality',
                              selectedValue: dropdownControllers['nationality'],
                              items: itemDataList['nationality']!,
                              onChanged: (value) {
                                setState(() {
                                  inValidFields.remove('nationality');
                                  dropdownControllers['nationality'] = value!;
                                });
                              },
                            ),
                            CustomWidget.dropdownButtonDiffValue(
                              label: 'Education',
                              selectedValue: dropdownControllers['education'],
                              items: itemDataList['education']!,
                              onChanged: (value) {
                                setState(() {
                                  inValidFields.remove('education');
                                  dropdownControllers['education'] = value!;
                                });
                              },
                            ),
                            CustomWidget.textField(
                                controller: textControllers['residence']!,
                                label: 'Residence'),
                            CustomWidget.textField(
                                controller:
                                    textControllers['name_of_employment']!,
                                label: 'Name of Employment'),
                            CustomWidget.textField(
                                controller: textControllers['office_location']!,
                                label: 'Current Work Address'),
                            CustomWidget.dropdownButtonDiffValue(
                              label: 'Branch',
                              selectedValue: dropdownControllers['branch'],
                              items: itemDataList['branch']!,
                              onChanged: (value) {
                                setState(() {
                                  inValidFields.remove('branch');
                                  dropdownControllers['branch'] = value!;
                                });
                              },
                            ),
                            CustomWidget.textField(
                                controller: textControllers['testing']!,
                                label: 'Testing'),
                            CustomWidget.elevatedButton(
                                enabled: inValidFields.isEmpty,
                                isLoading: isLoading,
                                text: 'Continue',
                                onPressed: handleContinue)
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              )
          ]);
        },
      ),
    );
  }
}
