import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/models/loan_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/main_app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/loan/current_loan.dart';
import 'package:synpitarn/screens/loan/previous_loan.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/services/route_service.dart';

class LoanHistoryPage extends StatefulWidget {
  const LoanHistoryPage({super.key});

  @override
  LoanHistoryState createState() => LoanHistoryState();
}

class LoanHistoryState extends State<LoanHistoryPage> {
  final ScrollController scrollController = ScrollController();
  User loginUser = User.defaultUser();
  Loan applicationData = Loan.defaultLoan();
  List<Loan> loanList = [];

  bool isLoading = false;
  int currentPage = 1;
  bool hasNextPage = true;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasNextPage) {
        getLoanHistory();
      }
    });

    getInitData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> getInitData() async {
    isLoading = true;
    loginUser = await getLoginUser();
    setState(() {});

    await getApplicationData();
    await getLoanHistory();

    isLoading = false;
    setState(() {});
  }

  Future<void> getApplicationData() async {
    LoanApplicationResponse applicationResponse =
        await LoanRepository().getLoanApplication(loginUser);

    if (applicationResponse.response.code == 200) {
      applicationData = applicationResponse.data;
      setState(() {});
    } else if (applicationResponse.response.code == 403) {
      await showErrorDialog(applicationResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(applicationResponse.response.message);
    }
  }

  Future<void> getLoanHistory() async {
    isLoading = true;
    setState(() {});

    LoanResponse loanResponse =
        await LoanRepository().getLoanHistory(loginUser, currentPage);

    if (loanResponse.response.code == 200) {
      loanList.addAll(loanResponse.data);
      hasNextPage = loanResponse.meta.hasNextPage;
      currentPage++;

      setState(() {});
    } else if (loanResponse.response.code == 403) {
      await showErrorDialog(loanResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(loanResponse.response.message);
    }
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(
        context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  Widget createCurrentApplyLoanCard() {
    return Padding(
      padding: CustomStyle.pagePaddingSmall(),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: CustomStyle.pagePaddingSmall(),
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomStyle.primary_color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Text(
                "Current Apply Loan",
                style: CustomStyle.bodyWhiteColor(),
              ),
            ),
            Container(
              padding: CustomStyle.pagePaddingSmall(),
              child: Column(
                children: [
                  CustomWidget.buildRow(
                      "Contract No", applicationData.contractNoRef != "" ? applicationData.contractNoRef.toString() : applicationData.contractNo.toString()),
                  CustomWidget.buildRow(
                      "Loan Status",
                      CommonService.getLoanStatus(
                          applicationData.status.toString())),
                  CustomWidget.buildRow(
                      "Loan Size", CommonService.getLoanSize(applicationData)),
                  CustomWidget.buildRow(
                      "Loan Term", "${applicationData.loanTerm} Months"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget createLoanCard(Loan loanData, String loanPlace) {
    return Padding(
      padding: CustomStyle.pagePaddingSmall(),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: CustomStyle.pagePaddingSmall(),
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomStyle.primary_color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Text(
                loanPlace,
                style: CustomStyle.bodyWhiteColor(),
              ),
            ),
            Container(
              padding: CustomStyle.pagePaddingSmall(),
              child: Column(
                children: [
                  CustomWidget.buildRow(
                      "Contract No", loanData.contractNoRef.toString()),
                  CustomWidget.buildRow(
                      "Loan Status",
                      CommonService.getLoanStatus(
                          loanData.loanApplicationStatus.toString())),
                  CustomWidget.buildRow(
                      "Loan Size", CommonService.getLoanSize(loanData)),
                  CustomWidget.buildRow(
                      "Loan Term", "${loanData.termPeriod} Months"),
                  CustomWidget.buildRow(
                      "First Payment Date",
                      CommonService.formatDate(
                          loanData.firstRepaymentDate.toString())),
                  CustomWidget.buildRow(
                      "Last Payment Date",
                      CommonService.formatDate(
                          loanData.lastRepaymentDate.toString())),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getLoopText(int n) {
    if (n == 1) return '1st Loan';
    if (n == 2) return '2nd Loan';
    if (n == 3) return '3rd Loan';
    return '${n}th Loan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            if (isLoading)
              CustomWidget.loading()
            else
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      spacing: 0,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            RouteService.goToNavigator(context,
                                CurrentLoanPage(isToDisplayPage: true));
                          },
                          child: createCurrentApplyLoanCard(),
                        ),
                        ...loanList.asMap().entries.map<Widget>((entry) {
                          final index = entry.key;
                          final loan = entry.value;

                          final loanPlace =
                              getLoopText(loanList.length - index);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  RouteService.goToNavigator(
                                      context, PreviousLoanPage(loan: loan));
                                },
                                child: createLoanCard(loan, loanPlace),
                              )
                            ],
                          );
                        }),
                        if (isLoading && hasNextPage)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: ConstantData.LOAN_INDEX,
        onItemTapped: (index) {
          setState(() {
            ConstantData.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }
}
