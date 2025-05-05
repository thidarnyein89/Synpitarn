import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/models/User_response.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/repositories/data_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/repositories/profile_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/nrc.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/route_service.dart';

class EditInformationPage extends StatefulWidget {
  User editUser = User.defaultUser();

  EditInformationPage({super.key, required this.editUser});

  @override
  EditInformationState createState() => EditInformationState();
}

class EditInformationState extends State<EditInformationPage> {
  User loginUser = User.defaultUser();

  final Map<String, TextEditingController> textControllers = {
    'name': TextEditingController(),
    'salary': TextEditingController(),
    'identity_number': TextEditingController(),
    'passport': TextEditingController(),
  };

  Map<String, dynamic> dropdownControllers = {
    'income_type': null,
  };

  Map<String, List<Item>> itemDataList = {
    "income_type": [Item.defaultItem()],
  };

  final Set<String> inValidFields = {};

  bool isLoading = false;
  bool isPageLoading = true;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    textControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> getInitData() async {
    isPageLoading = true;
    setState(() {});

    loginUser = await getLoginUser();

    await getIncomeTypes();
    setUserData();
    inValidFieldsAdd();

    isPageLoading = false;
    setState(() {});
  }

  Future<void> getIncomeTypes() async {
    DataResponse dataResponse =
        await DataRepository().getIncomeTypes(loginUser);

    if (dataResponse.response.code == 200) {
      itemDataList['income_type'] = dataResponse.data.map<Item>((data) {
        return Item.named(
          value: data.key.toString(),
          text: data.en,
        );
      }).toList();

      setState(() {});
    } else if (dataResponse.response.code == 403) {
      await showInfoDialog(dataResponse.response.message);
      AuthService().logout(context);
    } else {
      showInfoDialog(dataResponse.response.message);
    }
  }

  void setUserData() {
    textControllers.forEach((key, TextEditingController) {
      if (widget.editUser.toJson().containsKey(key)) {
        textControllers[key]!.text = widget.editUser.toJson()[key].toString();
        setState(() {});
      }
    });

    dropdownControllers.forEach((key, dynamic) {
      dropdownControllers[key] = findMatchData(
          itemDataList[key]!, widget.editUser.toJson()[key].toString());
    });

    setState(() {});
  }

  Item? findMatchData(List<Item> itemList, String value) {
    Iterable<Item> matchingItems =
        itemList.where((item) => item.value == value);
    return matchingItems.isNotEmpty ? matchingItems.first : null;
  }

  void inValidFieldsAdd() {
    textControllers.forEach((key, controller) {
      _inValidateField(key);
      controller.addListener(() => _inValidateField(key));
    });

    dropdownControllers.forEach((key, item) {
      inValidFields.remove(key);
      if (dropdownControllers[key] == null) {
        inValidFields.add(key);
      } else if (dropdownControllers[key] is Item &&
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

  Future<void> handleContinue() async {
    if (await checkMissingFields() == false) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> requestData = {};

      textControllers.forEach((key, controller) {
        requestData[key] = controller.text;
      });

      dropdownControllers.forEach((key, controller) {
        requestData[key] = controller.value;
      });

      final Map<String, dynamic> postBody = {
        ...requestData,
        'phone_number': widget.editUser.phoneNumber,
        'dob': widget.editUser.dob,
        'province_of_work': widget.editUser.provinceOfWork,
        'province_of_resident': widget.editUser.provinceOfResident,
      };

      UserResponse response =
          await ProfileRepository().editProfile(postBody, loginUser);

      if (response.response.code == 200) {
        Navigator.pop(context);
      } else if (response.response.code == 403) {
        await showInfoDialog(response.response.message);
        AuthService().logout(context);
      } else {
        showInfoDialog(response.response.message);
      }
    }
  }

  Future<bool> checkMissingFields() async {
    List<String> missingFields = [];

    if (widget.editUser.phoneNumber == null ||
        widget.editUser.phoneNumber!.trim().isEmpty) {
      missingFields.add("Phone Number");
    }
    if (widget.editUser.dob == null || widget.editUser.dob!.trim().isEmpty) {
      missingFields.add("DOB");
    }
    if (widget.editUser.provinceOfWork == null ||
        widget.editUser.provinceOfWork!.trim().isEmpty) {
      missingFields.add("Province of Work");
    }
    if (widget.editUser.provinceOfResident == null ||
        widget.editUser.provinceOfResident!.trim().isEmpty) {
      missingFields.add("Province of Resident");
    }

    if (missingFields.isNotEmpty) {
      String message =
          "Invalid Input Data (${missingFields.join(', ')}). Please contact admin.";
      await showInfoDialog(message);
      return true;
    } else {
      return false;
    }
  }

  Future<void> showInfoDialog(String message) async {
    await CustomWidget.showDialogWithoutStyle(context: context, msg: message);
    isLoading = false;
    setState(() {});
  }

  Future<void> showNRCDialog() async {
    var result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: NRCPage(nrcValue: textControllers['identity_number']!.text),
        );
      },
    );

    if (result != null) {
      setState(() {
        textControllers['identity_number']!.text = result;
        inValidFields.remove('identity_number');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final maxDate = DateTime(today.year - 18, today.month, today.day);
    final minDate = DateTime(today.year - 56, today.month, today.day);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: 'Edit Information'),
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
                                label: 'Name'),
                            GestureDetector(
                              onTap: () {
                                showNRCDialog();
                              },
                              child: AbsorbPointer(
                                child: CustomWidget.textField(
                                  controller:
                                      textControllers['identity_number']!,
                                  label: 'NRC',
                                ),
                              ),
                            ),
                            CustomWidget.textField(
                                controller: textControllers['passport']!,
                                label: 'Passport'),
                            CustomWidget.dropdownButtonDiffValue(
                              label: 'How often are you paid',
                              selectedValue: dropdownControllers['income_type'],
                              items: itemDataList['income_type']!,
                              onChanged: (value) {
                                setState(() {
                                  inValidFields.remove('income_type');
                                  dropdownControllers['income_type'] = value!;
                                });
                              },
                            ),
                            CustomWidget.numberTextField(
                                controller: textControllers['salary']!,
                                label:
                                    'Total income (Salary + Overtime + Other Income) (Baht) (Baht)'),
                            CustomWidget.elevatedButton(
                                context: context,
                                enabled: inValidFields.isEmpty,
                                isLoading: isLoading,
                                text: 'Continue',
                                onPressed: handleContinue),
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
