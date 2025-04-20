import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/admin.dart';
import 'package:synpitarn/models/application_response.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:intl/intl.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/services/route_service.dart';

class LoanStatusPage extends StatefulWidget {
  LoanStatusPage({super.key});

  @override
  LoanStatusState createState() => LoanStatusState();
}

class LoanStatusState extends State<LoanStatusPage> {
  Loan applicationData =
      Loan.defaultLoan(User.defaultUser(), Admin.defaultAdmin());
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

    ApplicationResponse applicationResponse =
        await ApplicationRepository().getApplication(loginUser);

    if (applicationResponse.response.code != 200) {
      showErrorDialog(
          applicationResponse.response.message ?? AppConfig.ERR_MESSAGE);
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
          builder: (context) =>
              InterviewAppointmentPage(applicationData: applicationData)),
    );
  }

  String formatDate(String rawDate) {
    if (rawDate != "") {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy").format(parsedDate);
    }
    return "";
  }

  String formatTime(String rawTime) {
    if (rawTime != "") {
      DateTime parsedTime = DateFormat("HH:mm:ss").parse(rawTime);
      return DateFormat("hh:mm a").format(parsedTime);
    }
    return "";
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        spacing: 0,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: CustomStyle.pagePadding(),
                              child: createLoanStatusWidget()),
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

    if (AppConfig.PRE_APPROVE_STATUS
        .contains(applicationData.status)) {
      return preApproveWidget();
    }

    return Container();
  }

  Widget noApplyLoanWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConfig.NO_CURRENT_LOAN,
          style: CustomStyle.titleBold(),
        ),
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
        Text(
          'Pending Loan Application',
          style: CustomStyle.titleBold(),
        ),
        CustomWidget.verticalSpacing(),
        CustomWidget.verticalSpacing(),
        _buildRow("Contract No", applicationData.contractNo.toString()),
        _buildRow("Loan Applied Date",
            formatDate(applicationData.createdAt.toString())),
        _buildRow("Request Interview Date",
            formatDate(applicationData.appointmentDate.toString())),
        _buildRow("Request Interview Time",
            formatTime(applicationData.appointmentTime.toString())),
        _buildRow("Loan Status", applicationData.appointmentStatus.toString()),
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
        ]
      ],
    );
  }

  Widget preApproveWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pre Approved Loan',
          style: CustomStyle.titleBold(),
        ),
        CustomWidget.verticalSpacing(),
        CustomWidget.verticalSpacing(),
        _buildRow("Contract No", applicationData.contractNo.toString()),
        _buildRow(
            "Loan Size", "${applicationData.approvedAmount.toString()} Baht"),
        _buildRow("Loan Term", "${applicationData.loanTerm.toString()} Months"),
        _buildRow("Request Interview Time",
            applicationData.appointmentBranchTime.toString()),
        _buildRow("Branch Appointment Date",
            formatTime(applicationData.appointmentBranchDate.toString())),
        _buildRow("Branch Appointment Time",
            applicationData.appointmentBranchTime.toString()),
      ],
    );
  }
}
