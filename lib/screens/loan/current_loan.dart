import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/models/loan_response.dart';
import 'package:synpitarn/models/loan_schedule.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentLoanPage extends StatefulWidget {
  bool isToDisplayPage = true;

  CurrentLoanPage({super.key, required this.isToDisplayPage});

  @override
  CurrentLoanState createState() => CurrentLoanState();
}

class CurrentLoanState extends State<CurrentLoanPage> {
  User loginUser = User.defaultUser();
  Loan applicationData = Loan.defaultLoan();
  bool isLoading = false;
  int totalLateDay = 0;
  String repaymentAmount = "";

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
    loginUser = await getLoginUser();
    setState(() {});

    getApplicationData();
    getTotalLateDay();
  }

  Future<void> getApplicationData() async {
    isLoading = true;
    setState(() {});

    LoanApplicationResponse applicationResponse =
        await LoanRepository().getApplication(loginUser);

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

  Future<void> getTotalLateDay() async {
    if (loginUser.loanApplicationSubmitted) {
      LoanResponse loanResponse =
          await LoanRepository().getLoanHistory(loginUser, 1);

      if (loanResponse.response.code != 200) {
        showErrorDialog(loanResponse.response.message);
      } else {
        if (loanResponse.data.isNotEmpty) {
          loanResponse.data[0].schedules!.forEach((LoanSchedule loanSchedule) {
            int dayCount = CommonService.getDayCount(loanSchedule.pmtDate);
            if (loanSchedule.isPaymentDone == 0 && dayCount > 0) {
              totalLateDay = dayCount;
              repaymentAmount = loanSchedule.pmtAmount;

              if (mounted) {
                setState(() {});
              }
            }
          });
        }
      }
    }
  }

  void handleReSubmit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
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
    if (widget.isToDisplayPage) {
      return createLoanStatusPage();
    } else {
      return createLoanStatusSection();
    }
  }

  Widget createLoanStatusPage() {
    return Scaffold(
      appBar: PageAppBar(
        title: 'Current Apply Loan',
      ),
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
                            child: createLoanStatusSection(),
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
    );
  }

  Widget createLoanStatusSection() {
    if (applicationData.id <= 0) {
      return noApplyLoanSection();
    }

    if (AppConfig.PENDING_STATUS.contains(applicationData.status)) {
      return pendingSection();
    }

    if (AppConfig.PRE_APPROVE_STATUS.contains(applicationData.status)) {
      return preApproveSection();
    }

    if (AppConfig.DISBURSE_STATUS.contains(applicationData.status)) {
      return disburseSection();
    }

    if (AppConfig.REJECT_STATUS.contains(applicationData.status)) {
      return rejectSection();
    }

    if (AppConfig.POSTPONE_STATUS.contains(applicationData.status)) {
      return postponeSection();
    }

    return Container();
  }

  Widget noApplyLoanSection() {
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

  Widget pendingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pending Loan Application', style: CustomStyle.titleBold()),
        CustomWidget.verticalSpacing(),
        CustomWidget.buildRow(
            "Contract No", applicationData.contractNo.toString()),
        CustomWidget.buildRow(
          "Loan Applied Date",
          CommonService.formatDate(applicationData.createdAt.toString()),
        ),
        CustomWidget.buildRow(
          "Request Interview Date",
          CommonService.formatDate(applicationData.appointmentDate.toString()),
        ),
        CustomWidget.buildRow(
          "Request Interview Time",
          CommonService.formatTime(applicationData.appointmentTime.toString()),
        ),
        CustomWidget.buildRow("Loan Status", 'pending'),
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

  Widget preApproveSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pre Approved Loan', style: CustomStyle.titleBold()),
        CustomWidget.verticalSpacing(),
        CustomWidget.buildRow(
            "Contract No", applicationData.contractNo.toString()),
        CustomWidget.buildRow(
          "Loan Size", CommonService.getLoanSize(applicationData),
        ),
        CustomWidget.buildRow(
            "Loan Term", "${applicationData.loanTerm.toString()} Months"),
        CustomWidget.buildRow(
          "Branch Appointment Date",
          CommonService.formatDate(
            applicationData.appointmentBranchDate.toString(),
          ),
        ),
        CustomWidget.buildRow("Branch Appointment Time",
            applicationData.appointmentBranchTime.toString()),
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

  Widget disburseSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Approved Loan', style: CustomStyle.titleBold()),
        CustomWidget.verticalSpacing(),
        CustomWidget.buildRow(
            "Contract No", applicationData.contractNo.toString()),
        CustomWidget.buildRow(
          "Repayment date",
          CommonService.formatDate(
            applicationData.firstRepaymentDate.toString(),
          ),
        ),
        CustomWidget.buildRow(
          "Repayment amount",
          "${applicationData.repaymentAmountPerPeriod.toString()} Baht",
        ),
        CustomWidget.buildRow(
          "Loan Size", CommonService.getLoanSize(applicationData),
        ),
        CustomWidget.buildRow(
            "Loan Term", "${applicationData.loanTerm.toString()} Months"),
        CustomWidget.verticalSpacing(),
        if (totalLateDay > 0) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "Your repayment is now $totalLateDay days late. Please make a payment of $repaymentAmount Baht immediately or click ",
                  style: CustomStyle.bodyRedColor(),
                ),
                TextSpan(
                  text: "here (messenger link)",
                  style: CustomStyle.bodyBold(),
                  recognizer: TapGestureRecognizer()..onTap = _openMessenger,
                  // recognizer:
                  //     TapGestureRecognizer()
                  //       ..onTap = () {
                  //         // Replace this with your actual messenger link
                  //         print('Messenger link tapped');
                  //       },
                ),
                TextSpan(
                  text: " to contact your loan officer",
                  style: CustomStyle.bodyRedColor(),
                ),
              ],
            ),
          ),
          CustomWidget.verticalSpacing(),
        ],
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

  void _openMessenger() async {
    const messengerUrl = 'https://m.me/sakt'; // Replace with your page username
    final Uri uri = Uri.parse(messengerUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $messengerUrl';
    }
  }

  Widget rejectSection() {
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

  Widget postponeSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' Your loan has been postponed', style: CustomStyle.titleBold()),
        CustomWidget.verticalSpacing(),
        CustomWidget.buildRow(
            "Contract No", applicationData.contractNo.toString()),
        CustomWidget.buildRow(
          "Loan Size", CommonService.getLoanSize(applicationData),
        ),
        CustomWidget.buildRow(
            "Loan Term", "${applicationData.loanTerm.toString()} Months"),
        if (applicationData.appointmentBranchDate != '') ...[
          CustomWidget.buildRow(
            "Branch Appointment Date",
            CommonService.formatDate(
              applicationData.appointmentBranchDate.toString(),
            ),
          ),
        ],
        if (applicationData.appointmentBranchTime != '') ...[
          CustomWidget.buildRow(
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
