import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/loan_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/loan/loan_status.dart';
import 'package:synpitarn/screens/setting/about_us.dart';
import 'package:synpitarn/screens/setting/guide_header.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/models/aboutUs.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:remixicon/remixicon.dart';

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

  final List<Map<String, dynamic>> loanSteps = [
    {'label': 'Apply', 'isActive': false},
    {'label': 'Interview', 'isActive': false},
    {'label': 'Pre-approved', 'isActive': false},
    {'label': 'Disbursed', 'isActive': true},
  ];

  final List<Map<String, dynamic>> repaymentList = [
    {
      'dueDate': '15 Aug 2024',
      'amount': '1200.00 Baht',
      'status': 'Unpaid',
      'isLate': true
    },
    {
      'dueDate': '30 July 2024',
      'amount': '1200.00 Baht',
      'status': 'Paid',
      'isLate': false
    },
    {
      'dueDate': '15 July 2024',
      'amount': '1200.00 Baht',
      'status': 'Paid',
      'isLate': false
    },
  ];

  int _currentIndex = 0;
  bool isLoading = false;

  List<AboutUS> aboutList = [];
  List<Loan> loanList = [];

  @override
  void initState() {
    super.initState();
    slideImage();
    readAboutUsData();

    getLoanHistory();

    if (loginUser.loanApplicationSubmitted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToActiveStep();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getLoanHistory() async {
    setState(() {
      isLoading = true;
    });

    loginUser = await getLoginUser();

    LoanResponse loanResponse =
        await LoanRepository().getLoanHistory(loginUser);
    if (loanResponse.response.code != 200) {
      showErrorDialog(loanResponse.response.message ??
          'Error is occur, please contact admin');
    } else {
      loanList = loanResponse.data;
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> slideImage() async {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (mounted) {
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

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: (loginUser.loanApplicationSubmitted)
            ? Column(
                children: [
                  createSliderSection(),
                  createFeatureSection(),
                  CustomWidget.verticalSpacing(),
                  if (loanList.isNotEmpty) ...[
                    createLoanSection(),
                    createRepaymentSection(),
                  ]
                  else
                    LoanStatusPage()
                ],
              )
            : Column(
                children: [
                  createSliderSection(),
                  GuideHeaderPage(),
                  createAboutUs(),
                ],
              ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: AppConfig.HOME_INDEX,
        onItemTapped: (index) {
          setState(() {
            AppConfig.CURRENT_INDEX = index;
          });
        },
      ),
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
                  // Handle tap here
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

  Widget createLoanSection() {
    return Padding(
      padding: CustomStyle.pagePaddingSmall(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Loan Status',
                style: CustomStyle.subTitleBold(),
              ),
              Text(
                'View All',
                style: CustomStyle.body(),
              ),
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
          CustomWidget.verticalSpacing()
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

  Widget createRepaymentSection() {
    return Padding(
      padding: CustomStyle.pagePaddingSmall(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repayment Schedule',
                style: CustomStyle.subTitleBold(),
              ),
              Text(
                'View All',
                style: CustomStyle.body(),
              ),
            ],
          ),
          CustomWidget.verticalSpacing(),
          Text(
            'Your repayment is 5 days late.',
            style: CustomStyle.bodyRedColor(),
          ),
          Text(
            'Please make a payment to maintain good credit.',
            style: CustomStyle.bodyRedColor(),
          ),
          CustomWidget.verticalSpacing(),
          ...repaymentList.map((item) => createRepaymentCard(item: item)),
        ],
      ),
    );
  }

  Widget createRepaymentCard({required Map<String, dynamic> item}) {
    final bool isPaid = item['status'].toLowerCase() == 'paid';

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
                      style: isPaid
                          ? CustomStyle.body()
                          : CustomStyle.bodyRedColor(),
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
                      style: isPaid
                          ? CustomStyle.body()
                          : CustomStyle.bodyRedColor(),
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
                      style: isPaid
                          ? CustomStyle.body()
                          : CustomStyle.bodyRedColor(),
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
                        text: isPaid ? 'Complete' : 'Pay Now',
                        isSmall: true,
                        onPressed: handleContinue,
                      )
                    ]),
              ],
            ),
          );
        },
      ),
    );
  }

  void scrollToActiveStep() {
    final int activeIndex = loanSteps.indexWhere((step) => step['isActive']);
    if (activeIndex != -1) {
      double itemWidth = 100;
      double scrollOffset = itemWidth * activeIndex;
      _scrollController.animateTo(
        scrollOffset,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    }
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
            child: Icon(
              aboutList[index].icon,
              color: CustomStyle.icon_color,
            ),
          ),
          Expanded(
              child: Text(
            aboutList[index].titleEN,
            textAlign: TextAlign.center,
            style: CustomStyle.body(),
            softWrap: true,
            overflow: TextOverflow.visible,
            maxLines: 5,
          )),
          CustomWidget.verticalSpacing(),
        ],
      ),
    );
  }

  void handleContinue() {}
}
