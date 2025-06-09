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
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/profile/register/additional_information.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/l10n/app_localizations.dart';

class LoanTypePage extends StatefulWidget {
  const LoanTypePage({super.key});

  @override
  LoanTypeState createState() => LoanTypeState();
}

class LoanTypeState extends State<LoanTypePage> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  Map<String, dynamic> dropdownControllers = {
    'loan_type_id': null,
    'times_per_month': null,
    'province_work': null,
    'province_resident': null,
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
    getInitData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getInitData() async {
    isPageLoading = true;
    loginUser = await getLoginUser();
    setState(() {});

    await getDefaultData();
    getData();
    inValidFieldsAdd();

    isPageLoading = false;
    setState(() {});
  }

  void inValidFieldsAdd() {
    dropdownControllers.forEach((key, item) {
      inValidFields.add(key);
    });
    setState(() {});
  }

  Future<void> getDefaultData() async {
    isPageLoading = true;
    loginUser = await getLoginUser();
    setState(() {});

    DefaultResponse defaultResponse = await DefaultRepository().getDefaultData(
      loginUser,
    );

    if (defaultResponse.response.code == 200) {
      defaultData = defaultResponse.data;
    } else if (defaultResponse.response.code == 403) {
      await showErrorDialog(defaultResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(defaultResponse.response.message);
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
      final loanTypeItems =
          dataResponse.data.map<Item>((data) {
            return Item.named(value: data.id.toString(), text: data.getText());
          }).toList();

      itemDataList["loan_type"] = loanTypeItems;
    } else if (dataResponse.response.code == 403) {
      await showErrorDialog(dataResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(dataResponse.response.message);
    }

    dataResponse = await DataRepository().getTimesPerMonth();
    if (dataResponse.response.code == 200) {
      final timesPerMonth =
          dataResponse.data.map<Item>((data) {
            return Item.named(value: data.id.toString(), text: data.getText());
          }).toList();

      itemDataList["times_per_month"] = timesPerMonth;
    } else if (dataResponse.response.code == 403) {
      await showErrorDialog(dataResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(dataResponse.response.message);
    }

    dataResponse = await DataRepository().getProvinces();
    if (dataResponse.response.code == 200) {
      final province =
          dataResponse.data.map<Item>((data) {
            return Item.named(value: data.id.toString(), text: data.getText());
          }).toList();

      itemDataList["province"] = province;
    } else if (dataResponse.response.code == 403) {
      await showErrorDialog(dataResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(dataResponse.response.message);
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
      'loan_type_id': dropdownControllers['loan_type_id']!.value,
      'times_per_month': dropdownControllers['times_per_month']!.value,
      'province_work': dropdownControllers['province_work']!.value,
      'province_resident': dropdownControllers['province_resident']!.value,
    };

    DataResponse saveResponse = await LoanRepository().saveLoanApplicationStep(
      postBody,
      loginUser,
      stepName,
    );
    if (saveResponse.response.code == 200) {
      loginUser.loanFormState = "choose_loan_type";
      await setLoginUser(loginUser);
      isLoading = false;
      setState(() {});

      RouteService.profile(context);
    } else if (saveResponse.response.code == 403) {
      await showErrorDialog(saveResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(saveResponse.response.message);
    }
  }

  void handlePrevious() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Information2Page()),
    );
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(
      context: context,
      msg: errorMessage,
    );
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: AppLocalizations.of(context)!.loanApplication),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              if (isPageLoading)
                CustomWidget.loading()
              else
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                                label: AppLocalizations.of(context)!.loanType,
                                selectedValue:
                                    dropdownControllers['loan_type_id'],
                                items: itemDataList['loan_type']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('loan_type_id');
                                    dropdownControllers['loan_type_id'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label:
                                    AppLocalizations.of(context)!.repaymentTerm,
                                selectedValue:
                                    dropdownControllers['times_per_month'],
                                items: itemDataList['times_per_month']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('times_per_month');
                                    dropdownControllers['times_per_month'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label:
                                    AppLocalizations.of(context)!.provinceWork,
                                selectedValue:
                                    dropdownControllers['province_work'],
                                items: itemDataList['province']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('province_work');
                                    dropdownControllers['province_work'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonDiffValue(
                                label:
                                    AppLocalizations.of(
                                      context,
                                    )!.provinceResidence,
                                selectedValue:
                                    dropdownControllers['province_resident'],
                                items: itemDataList['province']!,
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('province_resident');
                                    dropdownControllers['province_resident'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.elevatedButton(
                                context: context,
                                enabled: true,
                                isLoading: false,
                                text: AppLocalizations.of(context)!.previous,
                                onPressed: handlePrevious,
                              ),

                              CustomWidget.elevatedButton(
                                context: context,
                                enabled: inValidFields.isEmpty,
                                isLoading: isLoading,
                                text:
                                    AppLocalizations.of(
                                      context,
                                    )!.applyLoanButton,
                                onPressed: handleApplyLoan,
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child:
                              //     ),
                              //     CustomWidget.horizontalSpacing(),
                              //     Expanded(
                              //       child:
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
