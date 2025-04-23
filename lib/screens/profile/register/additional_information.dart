import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/profile/document_file.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';

class Information2Page extends StatefulWidget {
  const Information2Page({super.key});

  @override
  Information2State createState() => Information2State();
}

class Information2State extends State<Information2Page> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  final Map<String, TextEditingController> textControllers = {
    'debit': TextEditingController(),
    'monthly_repayment_for_debit': TextEditingController(),
    'salary': TextEditingController(),
    'loan_amount': TextEditingController(),
    'social_links': TextEditingController(),
    'referral_code': TextEditingController(),
    'other_reason_for_main_purpose_of_loan': TextEditingController(),
  };

  Map<String, dynamic> dropdownControllers = {
    'year_working_in_thailand': null,
    'month_working_in_thailand': null,
    'loan_term_month': null,
    'loan_term_year': null,
    'type_of_work': null,
    'industry': null,
    'main_purpose_of_loan': [Item.defaultItem()]
  };

  Map<String, List<Item>> itemDataList = {
    "year_working_in_thailand": [Item.defaultItem()],
    "month_working_in_thailand": [Item.defaultItem()],
    "type_of_work": [Item.defaultItem()],
    "industry": [Item.defaultItem()],
    "loan_term_year": [Item.defaultItem()],
    "loan_term_month": [Item.defaultItem()],
    "main_purpose_of_loan": [Item.defaultItem()]
  };

  final Set<String> inValidFields = {};

  int pageIndex = 2;
  String stepName = "additional_information";
  bool isLoading = false;
  bool isPageLoading = true;

  @override
  void initState() {
    super.initState();
    getDefaultData();
  }

  @override
  void dispose() {
    super.dispose();
    textControllers.values.forEach((controller) => controller.dispose());
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

  void setSavedData(Map<String, dynamic> inputData) {
    textControllers.forEach((key, TextEditingController) {
      if(inputData.containsKey(key)) {
        textControllers[key]!.text = inputData[key];
      }
    });

    dropdownControllers.forEach((key, dynamic) {
      if(inputData.containsKey(key)) {
        if (key == 'main_purpose_of_loan') {
          List<String> values = (inputData[key] as List).cast<String>();
          dropdownControllers[key] =
              findMultipleMatchData(itemDataList[key]!, values);
        } else {
          dropdownControllers[key] =
              findMatchData(itemDataList[key]!, inputData[key]);
        }
      }
    });
  }

  Item? findMatchData(List<Item> itemList, String value) {
    Iterable<Item> matchingItems =
        itemList.where((item) => item.value == value);
    return matchingItems.isNotEmpty ? matchingItems.first : null;
  }

  List<Item> findMultipleMatchData(List<Item> itemList, List<String> values) {
    return itemList.where((item) => values.contains(item.value)).toList();
  }

  void inValidFieldsAdd() {
    textControllers.forEach((key, controller) {
      _inValidateField(key);
      controller.addListener(() => _inValidateField(key));
    });

    inValidFields.remove("other_reason_for_main_purpose_of_loan");

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

  Future<void> handleContinue() async {
    isLoading = true;
    setState(() {});

    final Map<String, dynamic> additionalInformation = {
      ...?defaultData.inputData
    };

    textControllers.forEach((key, controller) {
      additionalInformation[key] = textControllers[key]!.text;
    });

    dropdownControllers.forEach((key, dynamic) {
      if (key == 'main_purpose_of_loan') {
        additionalInformation[key] =
            dropdownControllers[key]!.map((item) => item.value).toList();
      } else {
        additionalInformation[key] = dropdownControllers[key]!.value;
      }
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

  void handlePrevious() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DocumentFilePage()),
    );
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomStyle.primary_color,
        title: Text(
          'Additional Information',
          style: CustomStyle.appTitle(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(children: [
            if (isPageLoading)
              CustomWidget.loading()
            else
              SingleChildScrollView(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      spacing: 0,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegisterTabBar(activeStep: 2),
                        Padding(
                          padding: CustomStyle.pageWithoutTopPadding(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Length of time at current employer",
                                style: CustomStyle.subTitleBold(),
                              ),
                              CustomWidget.verticalSpacing(),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Year',
                                selectedValue: dropdownControllers[
                                    'year_working_in_thailand'],
                                items:
                                    itemDataList['year_working_in_thailand']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields
                                        .remove('year_working_in_thailand');
                                    dropdownControllers[
                                        'year_working_in_thailand'] = value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Month',
                                selectedValue: dropdownControllers[
                                    'month_working_in_thailand'],
                                items:
                                    itemDataList['month_working_in_thailand']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields
                                        .remove('month_working_in_thailand');
                                    dropdownControllers[
                                        'month_working_in_thailand'] = value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Type of Work',
                                selectedValue: dropdownControllers['type_of_work'],
                                items: itemDataList['type_of_work']!,
                                onChanged: (Item? value) {
                                  setState(() {
                                    inValidFields.remove('type_of_work');
                                    dropdownControllers['type_of_work'] = value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Industry',
                                selectedValue: dropdownControllers['industry'],
                                items: itemDataList['industry']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('industry');
                                    dropdownControllers['industry'] = value!;
                                  });
                                },
                              ),
                              CustomWidget.textField(
                                  controller: textControllers['debit']!,
                                  label:
                                      'How much debit do you owe currently?'),
                              CustomWidget.numberTextField(
                                  controller: textControllers[
                                      'monthly_repayment_for_debit']!,
                                  label: 'Monthly repayment for debit'),
                              CustomWidget.numberTextField(
                                  controller: textControllers['salary']!,
                                  label: 'Salary'),
                              CustomWidget.numberTextField(
                                  controller: textControllers['loan_amount']!,
                                  label: 'Loan amount'),
                              Text(
                                "Loan Term",
                                style: CustomStyle.subTitleBold(),
                              ),
                              CustomWidget.verticalSpacing(),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Year',
                                selectedValue:
                                    dropdownControllers['loan_term_year'],
                                items: itemDataList['loan_term_year']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('loan_term_year');
                                    dropdownControllers['loan_term_year'] = value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Month',
                                selectedValue:
                                    dropdownControllers['loan_term_month'],
                                items: itemDataList['loan_term_month']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('loan_term_month');
                                    dropdownControllers['loan_term_month'] =
                                        value!;
                                  });
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Main purpose of loan",
                                    style: CustomStyle.subTitleBold(),
                                  ),
                                  CustomWidget.verticalSpacing(),
                                  ...itemDataList['main_purpose_of_loan']!.map(
                                      (purpose) => CustomWidget.checkbox(
                                              dropdownControllers[
                                                  'main_purpose_of_loan'],
                                              purpose, () {
                                            setState(() {
                                              if (dropdownControllers[
                                                      'main_purpose_of_loan']
                                                  .any((item) =>
                                                      item.value ==
                                                      purpose.value)) {
                                                dropdownControllers[
                                                        'main_purpose_of_loan']
                                                    .removeWhere((item) =>
                                                        item.value ==
                                                        purpose.value);
                                              } else {
                                                dropdownControllers[
                                                        'main_purpose_of_loan']
                                                    .add(purpose);
                                              }

                                              if (dropdownControllers[
                                                      'main_purpose_of_loan']
                                                  .isNotEmpty) {
                                                inValidFields.remove(
                                                    "main_purpose_of_loan");
                                              } else {
                                                inValidFields.add(
                                                    "main_purpose_of_loan");
                                              }

                                              if (purpose.value ==
                                                  'other_reasons') {
                                                textControllers[
                                                        'other_reason_for_main_purpose_of_loan']
                                                    ?.text = "";

                                                bool isOtherSelected =
                                                    dropdownControllers[
                                                            'main_purpose_of_loan']
                                                        .any((item) =>
                                                            item.value ==
                                                            'other_reasons');

                                                if (isOtherSelected) {
                                                  inValidFields.add(
                                                      "other_reason_for_main_purpose_of_loan");
                                                } else {
                                                  inValidFields.remove(
                                                      "other_reason_for_main_purpose_of_loan");
                                                }
                                              }
                                            });
                                          })),
                                ],
                              ),
                              if (dropdownControllers['main_purpose_of_loan']
                                  .any((item) => item.value == 'other_reasons'))
                                CustomWidget.textField(
                                    controller: textControllers[
                                        'other_reason_for_main_purpose_of_loan']!,
                                    label: 'Other reasons'),
                              CustomWidget.verticalSpacing(),
                              CustomWidget.textField(
                                  controller: textControllers['social_links']!,
                                  label: 'Facebook account profile link'),
                              CustomWidget.textField(
                                  controller: textControllers['referral_code']!,
                                  label: 'Referral Code'),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomWidget.elevatedButton(
                                      enabled: true,
                                      isLoading: false,
                                      text: 'Previous',
                                      onPressed: handlePrevious,
                                    ),
                                  ),
                                  CustomWidget.horizontalSpacing(),
                                  Expanded(
                                    child: CustomWidget.elevatedButton(
                                      enabled: inValidFields.isEmpty,
                                      isLoading: isLoading,
                                      text: 'Continue',
                                      onPressed: handleContinue,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
          ]);
        },
      ),
    );
  }
}
