import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/loan_status.dart';
import 'package:synpitarn/data/message.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/models/loan_response.dart';
import 'package:synpitarn/models/loan_schedule.dart';
import 'package:synpitarn/models/qrcode.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/qr_dialog.dart';
import 'package:synpitarn/screens/loan/branch_appointment.dart';
import 'package:synpitarn/screens/loan/interview_appointment.dart';
import 'package:synpitarn/screens/loan/repayment_list.dart';
import 'package:synpitarn/screens/profile/document_file.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:url_launcher/url_launcher.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class CurrentLoanPage extends StatefulWidget {
  bool isToDisplayPage = true;

  CurrentLoanPage({super.key, required this.isToDisplayPage});

  @override
  CurrentLoanState createState() => CurrentLoanState();
}

class CurrentLoanState extends State<CurrentLoanPage> with RouteAware {
  User loginUser = User.defaultUser();
  Loan applicationData = Loan.defaultLoan();
  bool isLoading = false;
  int totalLateDay = 0;
  String repaymentAmount = "";
  QrCode qrcode = QrCode.defaultQrCode();

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
      getInitData();
    }
  }

  Future<void> getInitData() async {
    loginUser = await getLoginUser();
    if (mounted) {
      setState(() {});
    }

    getApplicationData();
    getTotalLateDay();
  }

  Future<void> getApplicationData() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }

    LoanApplicationResponse applicationResponse =
        await LoanRepository().getLoanApplication(loginUser);

    if (applicationResponse.response.code == 200) {
      applicationData = applicationResponse.data;
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    } else if (applicationResponse.response.code == 403) {
      await showErrorDialog(applicationResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(applicationResponse.response.message);
    }
  }

  Future<void> getTotalLateDay() async {
    if (loginUser.loanApplicationSubmitted) {
      LoanResponse loanResponse = await LoanRepository().getLoanHistory(
        loginUser,
        1,
      );

      if (loanResponse.response.code == 200) {
        if (loanResponse.data.isNotEmpty) {
          LoanSchedule? lateSchedule =
              loanResponse.data[0].schedules!.cast<LoanSchedule>().firstWhere(
                    (loanSchedule) =>
                        loanSchedule.isPaymentDone == 0 &&
                        CommonService.getDayCount(loanSchedule.pmtDate) > 0,
                    orElse: () => LoanSchedule.defaultLoanSchedule(),
                  );

          if (lateSchedule.loanId != 0) {
            totalLateDay = CommonService.getDayCount(lateSchedule.pmtDate);
            repaymentAmount = lateSchedule.pmtAmount;
          }

          if (loanResponse.data[0].qrcode != null) {
            qrcode.photo = loanResponse.data[0].qrcode.photo;
            qrcode.string = loanResponse.data[0].qrcode.string;
          }

          if (mounted) {
            setState(() {});
          }
        }
      } else if (loanResponse.response.code == 403) {
        await showErrorDialog(loanResponse.response.message);
        AuthService().logout(context);
      } else {
        showErrorDialog(loanResponse.response.message);
      }
    }
  }

  void handleReSubmit() {
    RouteService.goToNavigator(
      context,
      InterviewAppointmentPage(applicationData: applicationData),
    );
  }

  void handleReUpload() {
    RouteService.goToNavigator(
      context,
      DocumentFilePage(
          applicationData: applicationData,
          documentList: applicationData.documentsRequest
              ?.where((doc) => doc.status == "true")
              .toList()),
    );
  }

  void handleBranchAppointment() {
    RouteService.goToNavigator(
      context,
      BranchAppointmentPage(applicationData: applicationData),
    );
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(
      context: context,
      msg: errorMessage,
    );
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
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
      appBar: PageAppBar(title: 'Current Apply Loan'),
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
                          if (qrcode.photo != "") qrCodeSection()
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

  Widget qrCodeSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              QRDialog.showQRDialog(context, qrcode.photo, qrcode.string);
            },
            child: FadeInImage(
              placeholder: AssetImage('assets/images/spinner.gif'),
              image: NetworkImage(qrcode.photo),
              fit: BoxFit.contain,
              width: 200,
              height: 200,
              imageErrorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image),
            ),
          ),
          Text(qrcode.string),
          CustomWidget.verticalSpacing(),
        ],
      ),
    );
  }

  Widget createLoanStatusSection() {
    if (applicationData.id <= 0) {
      return noApplyLoanSection();
    }

    if (LoanStatus.PENDING_STATUS.contains(applicationData.status)) {
      return pendingSection();
    }

    if (LoanStatus.PRE_APPROVE_STATUS.contains(applicationData.status)) {
      return preApproveSection();
    }

    if (LoanStatus.DISBURSE_STATUS.contains(applicationData.status)) {
      return disburseSection();
    }

    if (LoanStatus.REJECT_STATUS.contains(applicationData.status)) {
      return rejectSection();
    }

    if (LoanStatus.POSTPONE_STATUS.contains(applicationData.status)) {
      return postponeSection();
    }

    return Container();
  }

  Widget documentRequestSection() {
    if (applicationData.documentsRequest?.isNotEmpty != true) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "We are sorry to inform you that your loan information needs updated information. Please update your information.",
          style: CustomStyle.bodyRedColor(),
        ),
        CustomWidget.verticalSpacing(),
        CustomWidget.elevatedButton(
          context: context,
          text: 'Reupload Request',
          onPressed: handleReUpload,
        ),
      ],
    );
  }

  Widget noApplyLoanSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Message.NO_CURRENT_LOAN, style: CustomStyle.titleBold()),
        CustomWidget.elevatedButton(
          context: context,
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
          "Contract No",
          applicationData.contractNoRef != ""
              ? applicationData.contractNoRef.toString()
              : applicationData.contractNo.toString(),
        ),
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
            context: context,
            text: 'Resubmit Interview Appointment',
            onPressed: handleReSubmit,
          ),
        ],
        documentRequestSection()
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
          "Contract No",
          applicationData.contractNoRef ??
              applicationData.contractNo.toString(),
        ),
        CustomWidget.buildRow(
          "Loan Size",
          CommonService.getLoanSize(applicationData),
        ),
        CustomWidget.buildRow(
          "Loan Term",
          "${applicationData.loanTerm.toString()} Months",
        ),
        CustomWidget.buildRow(
          "Branch Appointment Date",
          CommonService.formatDate(
            applicationData.appointmentBranchDate.toString(),
          ),
        ),
        CustomWidget.buildRow(
          "Branch Appointment Time",
          applicationData.appointmentBranchTime.toString(),
        ),
        CustomWidget.verticalSpacing(),
        if (applicationData.status == 'pre-approved' ||
            applicationData.appointmentResubmit) ...[
          CustomWidget.verticalSpacing(),
          CustomWidget.elevatedButton(
            context: context,
            text: 'Resubmit Interview Appointment',
            onPressed: handleBranchAppointment,
          ),
        ],
        documentRequestSection()
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
          "Contract No",
          applicationData.contractNoRef ??
              applicationData.contractNo.toString(),
        ),
        CustomWidget.buildRow(
          "Repayment date",
          CommonService.formatDate(
            applicationData.firstRepaymentDate.toString(),
          ),
        ),
        CustomWidget.buildRow(
          "Repayment amount",
          CommonService.formatWithThousandSeparator(
              applicationData.repaymentAmountPerPeriod),
        ),
        CustomWidget.buildRow(
          "Loan Size",
          CommonService.getLoanSize(applicationData),
        ),
        CustomWidget.buildRow(
          "Loan Term",
          "${applicationData.loanTerm.toString()} Months",
        ),
        CustomWidget.verticalSpacing(),
        if (totalLateDay > 0) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "Your repayment is now $totalLateDay days late. Please make a payment of ${CommonService.formatWithThousandSeparator(repaymentAmount)} immediately or click ",
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
          context: context,
          text: 'Repay at a branch',
          onPressed: () {},
        ),
        CustomWidget.elevatedButtonOutline(
          context: context,
          text: 'Repayment at ATM',
          onPressed: () {},
        ),
        CustomWidget.elevatedButtonOutline(
          context: context,
          text: 'Repayment via mobile banking',
          onPressed: () {},
        ),
        CustomWidget.elevatedButton(
          context: context,
          text: 'View Repayment Schedule',
          onPressed: () {
            goToRepaymentList();
          },
        ),
      ],
    );
  }

  Future<void> _openMessenger() async {
    try {
      final messengerUri =
          Uri.parse("fb-messenger://user-thread/${ConstantData.MESSENGER_ID}");

      await launchUrl(messengerUri, mode: LaunchMode.platformDefault);
    } catch (e) {
      await CustomWidget.showDialogWithoutStyle(
          context: context, msg: "Could not launch Messenger");
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
          "Contract No",
          applicationData.contractNoRef ??
              applicationData.contractNo.toString(),
        ),
        CustomWidget.buildRow(
          "Loan Size",
          CommonService.getLoanSize(applicationData),
        ),
        CustomWidget.buildRow(
          "Loan Term",
          "${applicationData.loanTerm.toString()} Months",
        ),
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
            context: context,
            text: 'Resubmit Interview Appointment',
            onPressed: handleReSubmit,
          ),
        ],
      ],
    );
  }

  Future<void> goToRepaymentList() async {
    LoanApplicationResponse response =
        await LoanRepository().getLoanInformation(loginUser);
    if (response.response.code == 200) {
      Loan currentLoan = response.data;
      RouteService.goToNavigator(context, RepaymentListPage(loan: currentLoan));
    } else if (response.response.code == 403) {
      await showErrorDialog(response.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(response.response.message);
    }
  }
}
