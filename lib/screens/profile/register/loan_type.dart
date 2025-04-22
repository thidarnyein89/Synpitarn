import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/repositories/data_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/profile/register/additional_information.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';

class LoanTypePage extends StatefulWidget {
  const LoanTypePage({super.key});

  @override
  LoanTypeState createState() => LoanTypeState();
}

class LoanTypeState extends State<LoanTypePage> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  Map<String, dynamic> selectedFormData = {
    'loan_type_id': null,
    'times_per_month': null,
    'province_work': null,
    'province_resident': null
  };

  Map<String, List<Item>> itemDataList = {
    "loan_type": [Item.defaultItem()],
    "times_per_month": [Item.defaultItem()],
    "province": [Item.defaultItem()],
  };

  final Set<String> inValidFields = {};

  String stepName = "choose_loan_type";
  bool isLoading = false;
  bool isPageLoading = true;

  @override
  void initState() {
    super.initState();
    inValidFieldsAdd();
    getDefaultData();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void inValidFieldsAdd() {
    selectedFormData.forEach((key, item) {
      inValidFields.add(key);
    });
    setState(() {});
  }

  Future<void> getDefaultData() async {
    isPageLoading = true;
    loginUser = await getLoginUser();
    setState(() {});

    DefaultResponse defaultResponse =
        await DefaultRepository().getDefaultData(loginUser);

    if (defaultResponse.response.code == 200) {
      defaultData = defaultResponse.data;
    }

    isPageLoading = false;
    setState(() {});
  }

  Future<void> getData() async {
    isPageLoading = true;
    setState(() {});

    DataResponse dataResponse;

    dataResponse = await DataRepository().getLoanTypes();
    if (dataResponse.response.code == 200) {
      final loanTypeItems = dataResponse.data.map<Item>((data) {
        return Item.named(
          value: data.id.toString(),
          text: data.en,
        );
      }).toList();

      itemDataList["loan_type"] = loanTypeItems;
    }

    dataResponse = await DataRepository().getTimesPerMonth();
    if (dataResponse.response.code == 200) {
      final timesPerMonth = dataResponse.data.map<Item>((data) {
        return Item.named(
          value: data.id.toString(),
          text: data.en,
        );
      }).toList();

      itemDataList["times_per_month"] = timesPerMonth;
    }

    dataResponse = await DataRepository().getProvinces();
    if (dataResponse.response.code == 200) {
      final province = dataResponse.data.map<Item>((data) {
        return Item.named(
          value: data.id.toString(),
          text: data.en,
        );
      }).toList();

      itemDataList["province"] = province;
    }

    isPageLoading = false;
    setState(() {});
  }

  Future<void> handleApplyLoan() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> postBody = {
      'version_id': defaultData.versionId,
      'input_data': jsonEncode(defaultData.inputData),
      'loan_type_id': selectedFormData['loan_type_id']!.value,
      'times_per_month': selectedFormData['times_per_month']!.value,
      'province_work': selectedFormData['province_work']!.value,
      'province_resident': selectedFormData['province_resident']!.value,
    };

    DataResponse saveResponse = await LoanRepository()
        .saveLoanApplicationStep(postBody, loginUser, stepName);
    if (saveResponse.response.code != 200) {
      showErrorDialog(saveResponse.response.message ?? 'Error is occur, please contact admin');
    } else {
      loginUser.loanFormState = "choose_loan_type";
      await setLoginUser(loginUser);
      isLoading = false;
      setState(() {});

      RouteService.profile(context);
    }
  }

  void handlePrevious() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Information2Page()),
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
          'Loan Application',
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
                        RegisterTabBar(activeStep: 3),
                        Padding(
                          padding: CustomStyle.pageWithoutTopPadding(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Loan Type',
                                selectedValue: selectedFormData['loan_type_id'],
                                items: itemDataList['loan_type']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('loan_type_id');
                                    selectedFormData['loan_type_id'] = value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Repayment Term',
                                selectedValue:
                                    selectedFormData['times_per_month'],
                                items: itemDataList['times_per_month']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('times_per_month');
                                    selectedFormData['times_per_month'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Province of work',
                                selectedValue:
                                    selectedFormData['province_work'],
                                items: itemDataList['province']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('province_work');
                                    selectedFormData['province_work'] = value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label: 'Province of residence',
                                selectedValue:
                                    selectedFormData['province_resident'],
                                items: itemDataList['province']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('province_resident');
                                    selectedFormData['province_resident'] =
                                        value!;
                                  });
                                },
                              ),
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
                                      text: 'Apply Loan',
                                      onPressed: handleApplyLoan,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              )
          ]);
        },
      ),
    );
  }
}
