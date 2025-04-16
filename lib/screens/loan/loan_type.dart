import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/application_response.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/repositories/data_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/profile/information2.dart';
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

  List<Data> loanTypeList = [];
  List<Data> loanTermList = [];
  List<Data> provinceList = [];

  String? selectedLoanType;
  String? selectedLoanTerm;
  String? selectedProvinceWork;
  String? selectedProvinceResidence;

  final Set<String> inValidFields = {};

  String stepName = "choose_loan_type";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    inValidFields.add("loanType");
    inValidFields.add("loanTerm");
    inValidFields.add("provinceWork");
    inValidFields.add("provinceResidence");
    setState(() {});

    getDefaultData();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getDefaultData() async {
    loginUser = await getLoginUser();
    setState(() {});

    DefaultResponse defaultResponse =
        await DefaultRepository().getDefaultData(loginUser);

    if (defaultResponse.response.code == 200) {
      defaultData = defaultResponse.data;
    }

    setState(() {});
  }

  Future<void> getData() async {
    DataResponse dataResponse;

    dataResponse = await DataRepository().getLoanTypes();
    if (dataResponse.response.code == 200) {
      loanTypeList = dataResponse.data;
    }

    dataResponse = await DataRepository().getTimesPerMonth();
    if (dataResponse.response.code == 200) {
      loanTermList = dataResponse.data;
    }

    dataResponse = await DataRepository().getProvinces();
    if (dataResponse.response.code == 200) {
      provinceList = dataResponse.data;
    }

    setState(() {});
  }

  Future<void> handleApplyLoan() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> postBody = {
      'version_id': defaultData.versionId,
      'input_data': jsonEncode(defaultData.inputData),
      'loan_type_id':
          loanTypeList.firstWhere((item) => item.en == selectedLoanType).id,
      'times_per_month':
          loanTermList.firstWhere((item) => item.en == selectedLoanTerm).id,
      'province_work':
          provinceList.firstWhere((item) => item.en == selectedProvinceWork).id,
      'province_resident': provinceList
          .firstWhere((item) => item.en == selectedProvinceResidence)
          .id,
    };

    DataResponse saveResponse =
        await ApplicationRepository().saveLoanApplicationStep(postBody, loginUser, stepName);
    if (saveResponse.response.code != 200) {
      showErrorDialog('Error is occur, please contact admin');
    } else {
      loginUser.loanFormState = "choose_loan_type";
      await setLoginUser(loginUser);
      isLoading = false;
      setState(() {});

      RouteService.checkLoginUserData(context);
    }
  }

  void handlePrevious() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Information2Page()),
    );
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showErrorDialog(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomStyle.primary_color,
        title: Text('Loan Application', style: CustomStyle.appTitle()),
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
                child: Column(
                  spacing: 0,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // RegisterTabBar(activeStep: 3),
                    // Padding(
                    //   padding: CustomStyle.pageWithoutTopPadding(),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       CustomWidget.dropdownButtonFormField(
                    //         label: 'Loan Type',
                    //         selectedValue: selectedLoanType,
                    //         items: loanTypeList
                    //             .map((loanType) => loanType.en)
                    //             .toList(),
                    //         onChanged: (value) {
                    //           setState(() {
                    //             inValidFields.remove('loanType');
                    //             selectedLoanType = value!;
                    //           });
                    //         },
                    //       ),
                    //       CustomWidget.dropdownButtonFormField(
                    //         label: 'Repayment Term',
                    //         selectedValue: selectedLoanTerm,
                    //         items: loanTermList
                    //             .map((loanTerm) => loanTerm.en)
                    //             .toList(),
                    //         onChanged: (value) {
                    //           setState(() {
                    //             inValidFields.remove('loanTerm');
                    //             selectedLoanTerm = value!;
                    //           });
                    //         },
                    //       ),
                    //       CustomWidget.dropdownButtonFormField(
                    //         label: 'Province of work',
                    //         selectedValue: selectedProvinceWork,
                    //         items: provinceList
                    //             .map((province) => province.en)
                    //             .toList(),
                    //         onChanged: (value) {
                    //           setState(() {
                    //             inValidFields.remove('provinceWork');
                    //             selectedProvinceWork = value!;
                    //           });
                    //         },
                    //       ),
                    //       CustomWidget.dropdownButtonFormField(
                    //         label: 'Province of residence',
                    //         selectedValue: selectedProvinceResidence,
                    //         items: provinceList
                    //             .map((province) => province.en)
                    //             .toList(),
                    //         onChanged: (value) {
                    //           setState(() {
                    //             inValidFields.remove('provinceResidence');
                    //             selectedProvinceResidence = value!;
                    //           });
                    //         },
                    //       ),
                    //       Row(
                    //         children: [
                    //           Expanded(
                    //             child: CustomWidget.elevatedButton(
                    //               enabled: true,
                    //               isLoading: false,
                    //               text: 'Previous',
                    //               onPressed: handlePrevious,
                    //             ),
                    //           ),
                    //           CustomWidget.horizontalSpacing(),
                    //           Expanded(
                    //             child: CustomWidget.elevatedButton(
                    //               enabled: inValidFields.isEmpty,
                    //               isLoading: isLoading,
                    //               text: 'Apply Loan',
                    //               onPressed: handleApplyLoan,
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    CustomWidget.elevatedButton(
                      enabled: true,
                      isLoading: false,
                      text: 'Previous',
                      onPressed: handlePrevious,
                    )
                  ],
                )),
          );
        },
      ),
    );
  }
}
