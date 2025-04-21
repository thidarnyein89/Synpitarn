import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/services/route_service.dart';

class LoanStatusPage extends StatefulWidget {
  bool isHome = false;

  LoanStatusPage({super.key, required this.isHome});

  @override
  LoanStatusState createState() => LoanStatusState();
}

class LoanStatusState extends State<LoanStatusPage> {
  Loan applicationData = Loan.defaultLoan();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getApplicationData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getApplicationData() async {
    isLoading = true;
    setState(() {});

    User loginUser = await getLoginUser();

    LoanApplicationResponse applicationResponse = await LoanRepository()
        .getApplication(loginUser);

    if (applicationResponse.response.code != 200) {
      showErrorDialog(
        applicationResponse.response.message ?? AppConfig.ERR_MESSAGE,
      );
    } else {
      applicationData = applicationResponse.data;

      isLoading = false;
      setState(() {});
    }
  }

  void handleReSubmit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                InterviewAppointmentPage(applicationData: applicationData),
      ),
    );
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isHome) {
      return createLoanStatusWidget();
    } else {
      return createLoanStatusPage();
    }
  }

  Widget createLoanStatusPage() {
    return Scaffold(
      appBar: CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                          Padding(
                            padding: CustomStyle.pagePadding(),
                            child: createLoanStatusWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: AppConfig.LOAN_INDEX,
        onItemTapped: (index) {
          setState(() {
            AppConfig.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label, style: CustomStyle.body())),
            Text(" : "),
            SizedBox(width: 120, child: Text(value, style: CustomStyle.body())),
          ],
        ),
        CustomWidget.verticalSpacing(),
      ],
    );
  }

  Widget createLoanStatusWidget() {
    if (applicationData.id <= 0) {
      return noApplyLoanWidget();
    }

    if (AppConfig.PENDING_STATUS.contains(applicationData.status)) {
      return pendingWidget();
    }

    if (AppConfig.PRE_APPROVE_STATUS.contains(applicationData.status)) {
      return preApproveWidget();
    }

    if (AppConfig.APPROVE_STATUS.contains(applicationData.status)) {
      return approveWidget();
    }

    if (AppConfig.REJECT_STATUS.contains(applicationData.status)) {
      return rejectWidget();
    }

    if (AppConfig.POSTPONE_STATUS.contains(applicationData.status)) {
      return postponeWidget();
    }

    return Container();
  }

  Widget noApplyLoanWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppConfig.NO_CURRENT_LOAN, style: CustomStyle.titleBold()),
        CustomWidget.elevatedButton(
          text: 'Apply Loan',
          onPressed: () {
            RouteService.goToNavigator(context, ProfileHomePage());
          },
        ),
      ],
    );
  }

  Widget pendingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pending Loan Application', style: CustomStyle.titleBold()),
        CustomWidget.verticalSpacing(),
        CustomWidget.verticalSpacing(),
        _buildRow("Contract No", applicationData.contractNo.toString()),
        _buildRow(
          "Loan Applied Date",
          CommonService.formatDate(applicationData.createdAt.toString()),
        ),
        _buildRow(
          "Request Interview Date",
          CommonService.formatDate(applicationData.appointmentDate.toString()),
        ),
        _buildRow(
          "Request Interview Time",
          CommonService.formatTime(applicationData.appointmentTime.toString()),
        ),
        _buildRow("Loan Status", 'pending'),
        CustomWidget.verticalSpacing(),
        if (applicationData.appointmentResubmit) ...[
          Text(
            "You need to take interview appointment again",
            style: CustomStyle.bodyRedColor(),
          ),
          CustomWidget.verticalSpacing(),
          CustomWidget.elevatedButton(
            text: 'Resubmit Interview Appointment',
            onPressed: handleReSubmit,
          ),
        ],
      ],
    );
  }

  Widget preApproveWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pre Approved Loan', style: CustomStyle.titleBold()),
        CustomWidget.verticalSpacing(),
        CustomWidget.verticalSpacing(),
        _buildRow("Contract No", applicationData.contractNo.toString()),
        _buildRow(
          "Loan Size",
          "${applicationData.approvedAmount.toString()} Baht",
        ),
        _buildRow("Loan Term", "${applicationData.loanTerm.toString()} Months"),
        _buildRow(
          "Branch Appointment Date",
          CommonService.formatDate(
            applicationData.appointmentBranchDate.toString(),
          ),
        ),
        _buildRow(
          "Branch Appointment Time",
          applicationData.appointmentBranchTime.toString(),
        ),
        CustomWidget.verticalSpacing(),
        if (applicationData.status == 'pre-approved' ||
            applicationData.appointmentResubmit) ...[
          CustomWidget.verticalSpacing(),
          CustomWidget.elevatedButton(
            text: 'Resubmit Interview Appointment',
            onPressed: handleReSubmit,
          ),
        ],
      ],
    );
  }

  Widget approveWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Approved Loan', style: CustomStyle.titleBold()),
        CustomWidget.verticalSpacing(),
        CustomWidget.verticalSpacing(),
        _buildRow("Contract No", applicationData.contractNo.toString()),
        _buildRow(
          "Loan Size",
          "${applicationData.approvedAmount.toString()} Baht",
        ),
        _buildRow("Loan Term", "${applicationData.loanTerm.toString()} Months"),
        _buildRow(
          "Branch Appointment Date",
          CommonService.formatDate(
            applicationData.appointmentBranchDate.toString(),
          ),
        ),
        _buildRow(
          "Branch Appointment Time",
          applicationData.appointmentBranchTime.toString(),
        ),
        CustomWidget.verticalSpacing(),
        CustomWidget.elevatedButtonOutline(
          text: 'Repay at a branch',
          onPressed: () {},
        ),
        CustomWidget.elevatedButtonOutline(
          text: 'Repayment at ATM',
          onPressed: () {},
        ),
        CustomWidget.elevatedButtonOutline(
          text: 'Repayment via mobile banking',
          onPressed: () {},
        ),
        CustomWidget.elevatedButton(
          text: 'View Repayment Schedule',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget rejectWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Color(0xFFF0E291),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            children: [
              Text(
                'We are sorry to say that your loan application is rejected',
                style: CustomStyle.body(),
                textAlign: TextAlign.center,
              ),
              CustomWidget.verticalSpacing(),
              Text(
                'Your Application has expired please login and resubmit again',
                style: CustomStyle.body(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        CustomWidget.verticalSpacing(),
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Sorry, you can’t request another loan currently. But don’t worry, you can request again on ',

                      style: CustomStyle.body(),
                    ),
                    TextSpan(
                      text: '20 October 2025',

                      style: CustomStyle.bodyBold(),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget postponeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' Your loan has been postponed', style: CustomStyle.titleBold()),
        CustomWidget.verticalSpacing(),
        CustomWidget.verticalSpacing(),
        _buildRow("Contract No", applicationData.contractNo.toString()),
        _buildRow(
          "Loan Size",
          "${applicationData.approvedAmount.toString()} Baht",
        ),
        _buildRow("Loan Term", "${applicationData.loanTerm.toString()} Months"),
        if (applicationData.appointmentBranchDate != '') ...[
          _buildRow(
            "Branch Appointment Date",
            CommonService.formatDate(
              applicationData.appointmentBranchDate.toString(),
            ),
          ),
        ],
        if (applicationData.appointmentBranchTime != '') ...[
          _buildRow(
            "Branch Appointment Time",
            applicationData.appointmentBranchTime.toString(),
          ),
        ],
        CustomWidget.verticalSpacing(),
        if (applicationData.appointmentResubmit) ...[
          CustomWidget.elevatedButton(
            text: 'Resubmit Interview Appointment',
            onPressed: handleReSubmit,
          ),
        ],
      ],
    );
  }
}
