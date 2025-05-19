import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/loan_status.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/models/loan_response.dart';
import 'package:synpitarn/models/loan_schedule.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/qr_dialog.dart';
import 'package:synpitarn/screens/loan/loan_history.dart';
import 'package:synpitarn/screens/loan/repayment_list.dart';
import 'package:synpitarn/screens/profile/document_home.dart';
import 'package:synpitarn/screens/profile/profile_home.dart';
import 'package:synpitarn/screens/setting/about_us.dart';
import 'package:synpitarn/screens/setting/call_center.dart';
import 'package:synpitarn/screens/setting/guide_header.dart';
import 'package:synpitarn/services/auth_service.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/models/aboutUs.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/main_app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:remixicon/remixicon.dart';
import 'package:synpitarn/services/language_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/models/qrcode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final CommonService _commonService = CommonService();
  final PageController _pageController = PageController();

  User loginUser = User.defaultUser();
  Loan applicationData = Loan.defaultLoan();
  QrCode qrcode = QrCode.defaultQrCode();

  final List<String> images = [
    'assets/images/slider1.jpeg',
    'assets/images/slider2.jpeg',
    'assets/images/slider3.jpeg',
  ];

  final List<Map<String, dynamic>> features = const [
    {"icon": RemixIcons.hand_coin_line, "label": "repayment"},
    {"icon": Icons.edit_note, "label": "applyLoan"},
    {"icon": Icons.description, "label": "documents"},
    {"icon": Icons.support_agent, "label": "callCenter"},
  ];

  List<GlobalKey> loanStepKeys = [];
  List<Map<String, dynamic>> loanSteps = [
    {'label': 'apply', 'isActive': true},
    {'label': 'interview', 'isActive': false},
    {'label': 'preApproved', 'isActive': false},
    {'label': 'disbursed', 'isActive': false},
  ];

  List<Loan> loanList = [];
  List<Map<String, dynamic>> repaymentList = [];
  int totalLateDay = 0;

  int _currentIndex = 0;
  bool isLoading = false;

  List<AboutUS> aboutList = [];

  @override
  void initState() {
    super.initState();
    readAboutUsData();
    getInitData();
    slideImage();

    loanStepKeys = List.generate(loanSteps.length, (_) => GlobalKey());
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getInitData() async {
    isLoading = true;
    setState(() {});

    loginUser = await getLoginUser();
    setState(() {});

    getApplicationData();
    getLoanHistory();
  }

  Future<void> getApplicationData() async {
    LoanApplicationResponse applicationResponse =
        await LoanRepository().getLoanApplication(loginUser);

    if (applicationResponse.response.code == 200) {
      applicationData = applicationResponse.data;

      if (LoanStatus.PENDING_STATUS.contains(applicationData.status)) {
        var lateRepayment = loanSteps.firstWhere(
          (step) => step['isLate'] == true,
          orElse: () => <String, Object>{},
        );

        if (lateRepayment.isNotEmpty) {
          totalLateDay = lateRepayment['dayCount'];
        }
      }

      loanSteps = [
        {'label': 'apply', 'isActive': true},
        {'label': 'interview', 'isActive': false},
        {'label': 'preApproved', 'isActive': false},
        {'label': 'disbursed', 'isActive': false},
      ];

      if (LoanStatus.PENDING_STATUS.contains(applicationData.status)) {
        if (LoanStatus.APPOINTMENT_PENDING_STATUS.contains(
          applicationData.appointmentStatus,
        )) {
          loanSteps[0]['isActive'] = true;
        }
        if (LoanStatus.APPOINTMENT_DONE_STATUS.contains(
          applicationData.appointmentStatus,
        )) {
          loanSteps[0]['isActive'] = false;
          loanSteps[1]['isActive'] = true;
        }
      }

      if (LoanStatus.PRE_APPROVE_STATUS.contains(applicationData.status)) {
        loanSteps[0]['isActive'] = false;
        loanSteps[2]['isActive'] = true;
      }

      if (LoanStatus.DISBURSE_STATUS.contains(applicationData.status)) {
        loanSteps[0]['isActive'] = false;
        loanSteps[3]['isActive'] = true;
      }

      if (mounted) {
        setState(() {});
      }

      if (loginUser.loanApplicationSubmitted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToActiveStep();
        });
      }
    } else if (applicationResponse.response.code == 403) {
      await showErrorDialog(applicationResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(applicationResponse.response.message);
    }
  }

  Future<void> getLoanHistory() async {
    if (loginUser.loanApplicationSubmitted) {
      LoanResponse loanResponse = await LoanRepository().getLoanHistory(
        loginUser,
        1,
      );

      if (loanResponse.response.code == 200) {
        repaymentList = [];
        loanList = loanResponse.data;

        if (loanResponse.data.isNotEmpty) {
          repaymentList =
              loanResponse.data[0].schedules!.map((LoanSchedule loanSchedule) {
            int dayCount = CommonService.getDayCount(loanSchedule.pmtDate);
            bool isLate = loanSchedule.isPaymentDone == 0 && dayCount > 0;

            return {
              'dueDate': CommonService.formatDate(loanSchedule.pmtDate),
              'amount': CommonService.formatWithThousandSeparator(
                  context, loanSchedule.pmtAmount),
              'status': loanSchedule.isPaymentDone == 0 ? 'Unpaid' : 'Paid',
              'dayCount': dayCount,
              'isLate': isLate
            };
          }).toList();

          if (loanResponse.data[0].qrcode != null) {
            qrcode.photo = loanResponse.data[0].qrcode.photo;
            qrcode.string = loanResponse.data[0].qrcode.string;
          }

          var lateRepayment = repaymentList.firstWhere(
            (repayment) => repayment['isLate'] == true,
            orElse: () => <String, Object>{},
          );

          if (lateRepayment.isNotEmpty) {
            totalLateDay = lateRepayment['dayCount'];
          }
        }
      } else if (loanResponse.response.code == 403) {
        await showErrorDialog(loanResponse.response.message);
        AuthService().logout(context);
      } else {
        showErrorDialog(loanResponse.response.message);
      }
      isLoading = false;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> slideImage() async {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (mounted && !isLoading && _pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> readAboutUsData() async {
    aboutList = await _commonService.readAboutUsData();
    setState(() {});
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
      appBar: MainAppBar(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: CustomStyle.primary_color,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  createSliderSection(),
                  createFeatureSection(),
                  createLoanStatusSection(),
                  createLoanSection(),
                  if (!loginUser.loanApplicationSubmitted) ...[
                    GuideHeaderPage(),
                    createAboutUs(),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: ConstantData.HOME_INDEX,
        onItemTapped: (index) {
          setState(() {
            ConstantData.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget createSliderSection() {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: CustomStyle.pagePaddingSmall(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    images[index],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget createFeatureSection() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: features.length,
        padding: CustomStyle.pagePaddingSmall(),
        itemBuilder: (context, index) {
          final item = features[index];
          return SizedBox(
            width: 110,
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (index == 0) {
                    if (qrcode.photo == "") {
                      showErrorDialog(
                          AppLocalizations.of(context)!.noApplyLoan);
                    } else {
                      QRDialog.showQRDialog(
                        context,
                        qrcode.photo,
                        qrcode.string,
                      );
                    }
                  }
                  if (index == 1) {
                    goToLoanApply(context);
                  }
                  if (index == 2) {
                    goToDocumentPage(context);
                  }
                  if (index == 3) {
                    RouteService.goToNavigator(context, CallCenterPage());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        size: 30,
                        color: CustomStyle.primary_color,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LanguageService.translateKey(context, item['label']),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget createLoanStatusSection() {
    if (!loginUser.loanApplicationSubmitted) {
      return Container();
    }

    return Padding(
      padding: CustomStyle.pagePaddingSmall(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.loanStatus,
                  style: CustomStyle.subTitleBold()),
            ],
          ),
          CustomWidget.verticalSpacing(),
          Container(
            padding: CustomStyle.pagePaddingMedium(),
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                spacing: 10,
                children: List.generate(loanSteps.length * 2 - 1, (i) {
                  if (i.isOdd) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.arrow_forward_rounded, size: 16),
                    );
                  }
                  int stepIndex = i ~/ 2;
                  final step = loanSteps[stepIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      key: loanStepKeys[stepIndex],
                      child: createLoanStep(
                        label: LanguageService.translateKey(
                            context, step['label']),
                        isActive: step['isActive'],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createLoanStep({required String label, required bool isActive}) {
    return Text(
      label,
      style:
          isActive ? CustomStyle.bodyGreenColor() : CustomStyle.bodyOpacity(),
    );
  }

  Widget createLoanSection() {
    if (!loginUser.loanApplicationSubmitted) {
      return Container();
    }

    if (repaymentList.isEmpty) {
      return createPendingLoanSection();
    } else if (repaymentList.isEmpty ||
        LoanStatus.REJECT_STATUS.contains(applicationData.status)) {
      return createRejectLoanSection();
    } else {
      return createRepaymentSection();
    }
  }

  Widget createPendingLoanSection() {
    final int activeIndex = loanSteps.indexWhere((step) => step['isActive']);
    String loanStatus =
        CommonService.getLoanStatus(applicationData.status.toString());
    if (activeIndex == 1) {
      loanStatus = LanguageService.translateKey(
          context, loanSteps[activeIndex]["label"]);
    }

    return Padding(
      padding: CustomStyle.pagePaddingSmall(),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: CustomStyle.pagePaddingSmall(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget.buildRow(
                AppLocalizations.of(context)!.contractNo,
                applicationData.contractNo.toString(),
              ),
              if (LoanStatus.PRE_APPROVE_STATUS.contains(
                applicationData.status,
              )) ...[
                CustomWidget.buildRow(
                  AppLocalizations.of(context)!.loanSize,
                  CommonService.getLoanSize(context, applicationData),
                ),
                CustomWidget.buildRow(
                  AppLocalizations.of(context)!.loanTerm,
                  "${applicationData.loanTerm.toString()} ${AppLocalizations.of(context)!.months}",
                ),
                CustomWidget.buildRow(
                  AppLocalizations.of(context)!.branchAppointmentDate,
                  CommonService.formatDate(
                    applicationData.appointmentBranchDate.toString(),
                  ),
                ),
                CustomWidget.buildRow(
                  AppLocalizations.of(context)!.branchAppointmentTime,
                  applicationData.appointmentBranchTime.toString(),
                ),
              ],
              if (!LoanStatus.PRE_APPROVE_STATUS.contains(
                applicationData.status,
              )) ...[
                CustomWidget.buildRow(
                  AppLocalizations.of(context)!.loanAppliedDate,
                  CommonService.formatDate(
                    applicationData.createdAt.toString(),
                  ),
                ),
                CustomWidget.buildRow(
                  AppLocalizations.of(context)!.requestInterviewDate,
                  CommonService.formatDate(
                    applicationData.appointmentDate.toString(),
                  ),
                ),
                CustomWidget.buildRow(
                  AppLocalizations.of(context)!.requestInterviewTime,
                  CommonService.formatTime(
                    applicationData.appointmentTime.toString(),
                  ),
                ),
              ],
              CustomWidget.buildRow(
                  AppLocalizations.of(context)!.loanStatus, loanStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget createRejectLoanSection() {
    return Padding(
      padding: CustomStyle.pagePaddingSmall(),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: CustomStyle.pagePaddingSmall(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget.buildRow(
                  AppLocalizations.of(context)!.contractNo,
                  applicationData.contractNoRef != ""
                      ? applicationData.contractNoRef.toString()
                      : applicationData.contractNo.toString()),
              CustomWidget.buildRow(
                  AppLocalizations.of(context)!.loanStatus,
                  CommonService.getLoanStatus(
                      applicationData.status.toString())),
              CustomWidget.buildRow(AppLocalizations.of(context)!.loanSize,
                  CommonService.getLoanSize(context, applicationData)),
              CustomWidget.buildRow(AppLocalizations.of(context)!.loanTerm,
                  "${applicationData.loanTerm} ${AppLocalizations.of(context)!.months}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget createRepaymentSection() {
    return Padding(
      padding: CustomStyle.pagePaddingSmall(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.repaymentSchedule,
                  style: CustomStyle.subTitleBold()),
            ],
          ),
          if (totalLateDay > 0) ...[
            CustomWidget.verticalSpacing(),
            Text(
              AppLocalizations.of(context)!.repaymentLateDay(totalLateDay),
              style: CustomStyle.bodyRedColor(),
            ),
            Text(
              AppLocalizations.of(context)!.repaymentLateMessage,
              style: CustomStyle.bodyRedColor(),
            ),
          ],
          CustomWidget.verticalSpacing(),
          ...repaymentList.map((item) => createRepaymentCard(item: item)),
        ],
      ),
    );
  }

  Widget createRepaymentCard({required Map<String, dynamic> item}) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: CustomStyle.pagePaddingSmall(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.dueDate,
                        style: CustomStyle.bodyBold()),
                    const SizedBox(height: 8),
                    Text(
                      item['dueDate'],
                      style: item['isLate']
                          ? CustomStyle.bodyRedColor()
                          : CustomStyle.body(),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.amount,
                        style: CustomStyle.bodyBold()),
                    const SizedBox(height: 8),
                    Text(
                      item['amount'],
                      style: item['isLate']
                          ? CustomStyle.bodyRedColor()
                          : CustomStyle.body(),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.status,
                        style: CustomStyle.bodyBold()),
                    const SizedBox(height: 8),
                    Text(
                      item['status'],
                      style: item['isLate']
                          ? CustomStyle.bodyRedColor()
                          : CustomStyle.body(),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget.elevatedButton(
                      context: context,
                      isLoading: false,
                      text: item['status'] == 0
                          ? AppLocalizations.of(context)!.complete
                          : AppLocalizations.of(context)!.payNow,
                      isSmall: true,
                      onPressed: handleContinue,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void scrollToActiveStep() async {
    final int activeIndex = loanSteps.indexWhere((step) => step['isActive']);
    if (activeIndex == -1) return;

    while (!_scrollController.hasClients ||
        loanStepKeys[activeIndex].currentContext == null) {
      await Future.delayed(Duration(milliseconds: 50));
    }

    double offset = 0;

    for (int i = 0; i < activeIndex; i++) {
      final context = loanStepKeys[i].currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        offset += box.size.width + 20;
      }

      if (i < activeIndex) {
        offset += 8 + 8;
      }
    }

    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Widget createAboutUs() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        double width = constraints.maxWidth;

        if (width >= 1200) {
          crossAxisCount = 6;
        } else if (width >= 900) {
          crossAxisCount = 5;
        } else if (width >= 600) {
          crossAxisCount = 4;
        }

        return Padding(
          padding: CustomStyle.pagePadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.getToKnowUs,
                  style: CustomStyle.subTitleBold()),
              CustomWidget.verticalSpacing(),
              GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                children: aboutList
                    .asMap()
                    .map((index, aboutData) {
                      return MapEntry(index, gridItem(index));
                    })
                    .values
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget gridItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutUsPage(activeIndex: index),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: CustomStyle.secondary_color,
            child: Icon(aboutList[index].icon, color: CustomStyle.icon_color),
          ),
          SizedBox(height: 5),
          Expanded(
            child: Text(
              aboutList[index].getTitle(),
              textAlign: TextAlign.center,
              style: CustomStyle.body(),
              overflow: TextOverflow.visible,
              maxLines: 5,
            ),
          ),
          CustomWidget.verticalSpacing(),
          CustomWidget.verticalSpacing(),
        ],
      ),
    );
  }

  void handleContinue() {}

  void goToDocumentPage(BuildContext context) {
    if (!loginUser.loanApplicationSubmitted) {
      showErrorDialog(AppLocalizations.of(context)!.noApplyLoan);
    } else {
      RouteService.goToNavigator(context, DocumentHomePage());
    }
  }

  void goToLoanApply(BuildContext context) {
    if(!loginUser.loanApplicationSubmitted) {
      RouteService.goToReplaceNavigator(context, ProfileHomePage());
    }
    else {
      RouteService.goToReplaceNavigator(context, LoanHistoryPage());
    }
  }
}
