import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/loan_status.dart';
import 'package:synpitarn/data/message.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_application_response.dart';
import 'package:synpitarn/models/loan_response.dart';
import 'package:synpitarn/models/loan_schedule.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/qr_dialog.dart';
import 'package:synpitarn/screens/profile/document_home.dart';
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
import 'package:synpitarn/services/route_service.dart';

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

  final List<String> images = [
    'assets/images/slider1.jpeg',
    'assets/images/slider2.jpeg',
    'assets/images/slider3.jpeg',
  ];

  final List<Map<String, dynamic>> features = const [
    {"icon": RemixIcons.hand_coin_line, "label": "Repayment"},
    {"icon": Icons.edit_note, "label": "Loan Apply"},
    {"icon": Icons.description, "label": "Documents"},
    {"icon": Icons.support_agent, "label": "Call Center"},
  ];

  List<Map<String, dynamic>> loanSteps = [
    {'label': 'Apply', 'isActive': true},
    {'label': 'Interview', 'isActive': false},
    {'label': 'Pre-approved', 'isActive': false},
    {'label': 'Disbursed', 'isActive': false},
  ];

  List<Map<String, dynamic>> repaymentList = [];
  int totalLateDate = 0;

  int _currentIndex = 0;
  bool isLoading = false;

  List<AboutUS> aboutList = [];

  @override
  void initState() {
    super.initState();
    readAboutUsData();
    getInitData();
    slideImage();
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
    LoanApplicationResponse applicationResponse = await LoanRepository()
        .getLoanApplication(loginUser);

    if (applicationResponse.response.code == 200) {
      applicationData = applicationResponse.data;

      if (LoanStatus.PENDING_STATUS.contains(applicationData.status)) {
        var lateRepayment = loanSteps.firstWhere(
          (step) => step['isLate'] == true,
          orElse: () => <String, Object>{},
        );

        if (lateRepayment.isNotEmpty) {
          totalLateDate = lateRepayment['dayCount'];
        }
      }

      loanSteps = [
        {'label': 'Apply', 'isActive': true},
        {'label': 'Interview', 'isActive': false},
        {'label': 'Pre-approved', 'isActive': false},
        {'label': 'Disbursed', 'isActive': false},
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

        if (loanResponse.data.isNotEmpty) {
          repaymentList =
              loanResponse.data[0].schedules!.map((LoanSchedule loanSchedule) {
                int dayCount = CommonService.getDayCount(loanSchedule.pmtDate);
                bool isLate = loanSchedule.isPaymentDone == 0 && dayCount > 0;

                return {
                  'dueDate': CommonService.formatDate(loanSchedule.pmtDate),
                  'amount': '${loanSchedule.pmtAmount} Baht',
                  'status': loanSchedule.isPaymentDone == 0 ? 'Unpaid' : 'Paid',
                  'dayCount': dayCount,
                  'isLate': isLate,
                  "qrCodePhotoName": "QR_${loanResponse.data[0].contractNo}",
                  'qrCodePhoto': loanResponse.data[0].qrcode.photo,
                  'qrCodeString': loanResponse.data[0].qrcode.string,
                };
              }).toList();

          var lateRepayment = repaymentList.firstWhere(
            (repayment) => repayment['isLate'] == true,
            orElse: () => <String, Object>{},
          );

          if (lateRepayment.isNotEmpty) {
            totalLateDate = lateRepayment['dayCount'];
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
      body:
          isLoading
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
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (index == 0) {
                    if (repaymentList.isEmpty) {
                      showErrorDialog(Message.NO_CURRENT_REPAYMENT);
                    } else {
                      QRDialog.showQRDialog(
                        context,
                        repaymentList[0]['qrCodePhoto'],
                        repaymentList[0]['qrCodePhotoName'],
                      );
                    }
                  }
                  if (index == 2) {
                    goToDocumentPage(context);
                  }
                  if (index == 3) {
                    goToDocumentPage(context);
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
                        item['label'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
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
              Text('Your Loan Status', style: CustomStyle.subTitleBold()),
              Text('View All', style: CustomStyle.body()),
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
                    child: createLoanStep(
                      label: step['label'],
                      isActive: step['isActive'],
                    ),
                  );
                }),
              ),
            ),
          ),
          CustomWidget.verticalSpacing(),
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
    } else {
      return createRepaymentSection();
    }
  }

  Widget createPendingLoanSection() {
    final int activeIndex = loanSteps.indexWhere((step) => step['isActive']);
    String loanStatus = 'pending';
    if (activeIndex != -1) {
      loanStatus = loanSteps[activeIndex]["label"];
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
                "Contract No",
                applicationData.contractNo.toString(),
              ),
              if (LoanStatus.PRE_APPROVE_STATUS.contains(
                applicationData.status,
              )) ...[
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
              ],
              if (!LoanStatus.PRE_APPROVE_STATUS.contains(
                applicationData.status,
              )) ...[
                CustomWidget.buildRow(
                  "Loan Applied Date",
                  CommonService.formatDate(
                    applicationData.createdAt.toString(),
                  ),
                ),
                CustomWidget.buildRow(
                  "Request Interview Date",
                  CommonService.formatDate(
                    applicationData.appointmentDate.toString(),
                  ),
                ),
                CustomWidget.buildRow(
                  "Request Interview Time",
                  CommonService.formatTime(
                    applicationData.appointmentTime.toString(),
                  ),
                ),
              ],
              CustomWidget.buildRow("Loan Status", loanStatus),
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
              Text('Repayment Schedule', style: CustomStyle.subTitleBold()),
              Text('View All', style: CustomStyle.body()),
            ],
          ),
          if (totalLateDate > 0) ...[
            CustomWidget.verticalSpacing(),
            Text(
              'Your repayment is $totalLateDate days late.',
              style: CustomStyle.bodyRedColor(),
            ),
            Text(
              'Please make a payment to maintain good credit.',
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
      height: 80,
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
                    Text('Due Date', style: CustomStyle.bodyBold()),
                    const SizedBox(height: 8),
                    Text(
                      item['dueDate'],
                      style:
                          item['isLate']
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
                    Text('Amount', style: CustomStyle.bodyBold()),
                    const SizedBox(height: 8),
                    Text(
                      item['amount'],
                      style:
                          item['isLate']
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
                    Text('Status', style: CustomStyle.bodyBold()),
                    const SizedBox(height: 8),
                    Text(
                      item['status'],
                      style:
                          item['isLate']
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
                      isLoading: false,
                      text: item['status'] == 0 ? 'Complete' : 'Pay Now',
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

    double itemWidth = 100;
    double scrollOffset = itemWidth * activeIndex;

    while (!_scrollController.hasClients) {
      await Future.delayed(Duration(milliseconds: 50));
    }

    _scrollController.animateTo(
      scrollOffset,
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
              Text("Get To Know Us", style: CustomStyle.subTitleBold()),
              CustomWidget.verticalSpacing(),
              GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                children:
                    aboutList
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
          Expanded(
            child: Text(
              aboutList[index].titleEN,
              textAlign: TextAlign.center,
              style: CustomStyle.body(),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 5,
            ),
          ),
          CustomWidget.verticalSpacing(),
        ],
      ),
    );
  }

  void handleContinue() {}

  void goToDocumentPage(BuildContext context) {
    if (!loginUser.loanApplicationSubmitted) {
      showErrorDialog(Message.NO_CURRENT_LOAN);
    } else {
      RouteService.goToNavigator(context, CallCenter());
    }
  }
}
