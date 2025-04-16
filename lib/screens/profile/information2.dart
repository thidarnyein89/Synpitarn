import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/data.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/profile/document_file.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';

class Information2Page extends StatefulWidget {
  const Information2Page({super.key});

  @override
  Information2State createState() => Information2State();
}

class Information2State extends State<Information2Page> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  final Map<String, TextEditingController> controllers = {
    'debit': TextEditingController(),
    'monthlyRepaymentForDebit': TextEditingController(),
    'salary': TextEditingController(),
    'loanAmount': TextEditingController(),
    'socialLinks': TextEditingController(),
    'referralCode': TextEditingController(),
    'otherReason': TextEditingController(),
  };

  Map<String, dynamic> selectedFormData = {
    'selectedWorkingYear': Item.defaultItem(),
    'selectedWorkingMonth': Item.defaultItem(),
    'selectedLoanTermMonth': Item.defaultItem(),
    'selectedLoanTermYear': Item.defaultItem(),
    'selectedWorkType': Item.defaultItem(),
    'selectedIndustry': Item.defaultItem(),
    'selectedPurposes': [Item.defaultItem()]
  };

  final Set<String> inValidFields = {};

  final List<Item> yearList = [
    Item.named(value: "0", text: "0"),
    Item.named(value: "1", text: "1"),
    Item.named(value: "2", text: "2"),
    Item.named(value: "3", text: "3"),
    Item.named(value: "4", text: "4"),
    Item.named(value: "5", text: "5"),
    Item.named(value: "6", text: "6"),
    Item.named(value: "7", text: "7"),
    Item.named(value: "8", text: "8"),
    Item.named(value: "9", text: "9"),
    Item.named(value: "10", text: "10"),
    Item.named(value: "10+", text: "10+"),
    Item.named(value: "20+", text: "20+"),
  ];

  final List<Item> monthList = [
    Item.named(value: "0", text: "0"),
    Item.named(value: "1", text: "1"),
    Item.named(value: "2", text: "2"),
    Item.named(value: "3", text: "3"),
    Item.named(value: "4", text: "4"),
    Item.named(value: "5", text: "5"),
    Item.named(value: "6", text: "6"),
    Item.named(value: "7", text: "7"),
    Item.named(value: "8", text: "8"),
    Item.named(value: "9", text: "9"),
    Item.named(value: "10", text: "10"),
  ];

  final List<Item> workTypeList = [
    Item.named(
        value: "factory",
        text: "စက်ရုံဝန်ထမ်း | Factory Worker | พนักงานโรงงาน"),
    Item.named(
        value: "office",
        text: "ကုမ္ပဏီဝန်ထမ်း | Office worker | พนักงานสำนักงานบริษัทเอก"),
    Item.named(
        value: "labourer",
        text: "အလုပ်သမား | Labourer | แรงงาน (ที่ไม่ได้ทำงานในโรง"),
    Item.named(value: "other_2", text: "အခြား | Other | อื่")
  ];

  final List<Item> industryList = [
    Item.named(
        value: "agriculture_&_forestry",
        text:
            "စိုက်ပျိုးရေးနှင့်သစ်တော | Agriculture & forestry | เกษตรกรรม และการป่าไ"),
    Item.named(value: "fishery", text: " ငါးလုပ်ငန်း | Fishery | การประมง "),
    Item.named(
        value: "mining",
        text: "သတ္တုတွင်း | Mining | การทำเหมืองแร่และเหมืองหิน "),
    Item.named(
        value: "manufacturing",
        text: "ကုန်ထုတ်လုပ်မှု | Manufacturing | การผลิต "),
    Item.named(
        value: "construction",
        text: "ဆောက်လုပ်ရေး | Construction | การก่อสร้าง "),
    Item.named(
        value: "retail", text: "အရောင်းအဝယ် | Retail | การขายส่ง การขายปลีก"),
    Item.named(
        value: "transportation & warehousing",
        text:
            "သယ်ယူပို့ဆောင်ရေးနှင့်သိုလှောင်ရုံ | Transportation & warehousing | การขนส่ง สถานที่เก็บสินค้าและการคมนาคม"),
    Item.named(
        value: "automotive services",
        text:
            "မော်တော်ယာဉ် ဝန်ဆောင်မှု | Automotive services | บริการด้าน ยานยนต์ "),
    Item.named(
        value: "health & education",
        text:
            "ကျန်းမာရေးနှင့်ပညာရေး | Health & Education | การบริการด้านสุขภาพและการศึกษา "),
    Item.named(
        value: "community services",
        text:
            "လူမှု၀န်ဆောင်မှု | Community services | บริการชุมชน สังคมและบริการส่วนบุคคลอื่นๆ"),
    Item.named(
        value: "housemaid",
        text: "အိမ်အကူ | Housemaid | ลูกจ้างในครัวเรือนส่วนบุคคล"),
    Item.named(value: "other_4", text: "အခြား | Other | อื่น ๆ")
  ];

  final List<Item> loanPurposes = [
    Item.named(
        value: "send_home", text: "အိမ်ပြန်ပို့ရန် | Send home | ส่งกลับบ้"),
    Item.named(
        value: "repay_loan_shark",
        text: "တခြားချေးငွေ ပြန်ဆပ်ရန် | Repay loan shark | ชำระคืนเงินกู้นอก"),
    Item.named(
        value: "personal_consumption",
        text:
            "ကိုယ်ပိုင်သုံးစွဲရန် (နေထိုင်စရိပ်) | Personal consumption (Living Expense) | ใช้จ่ายส่วนตัว (ใช้จ่ายปร)"),
    Item.named(
        value: "personal_consumption_purchase",
        text:
            "ကိုယ်ပိုင်သုံးစွဲရန် (ပိုင်ဆိုင်မှုပစ္စည်းဝယ်ရန်, ဥပမာ ဖုန်း, TV) | Personal consumption (To purchase capital goods, e.g., mobile phone or TV) | ใช้จ่ายส่วนตัว (ซื้อทรัพย์สิน เช่น โทรศัพท์มือถือ ทีวี)"),
    Item.named(
        value: "personal_medical",
        text: "ကိုယ်ပိုင်ဆေးကုသရန် | Personal medical | ค่ารักษาพยาบาล"),
    Item.named(
        value: "document_extension",
        text:
            "စာရွက်စာတမ်း သက်တမ်းတိုးရန် (‌ဝေါ့ပါမစ်၊ ဗီဇာ.,) | Document Extension ( Work Permit, Visa., ) | เอกสารที่ใช้ในการการต่ออายุวีซ่าและใบอนุญาตทำงาน "),
    Item.named(
        value: "other_reasons",
        text: "အခြားအကြောင်းပြချက် | Other reasons | อื่นๆ "),
  ];

  String stepName = "additional_information";
  bool isLoading = false;
  bool isPageLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    getDefaultData();
  }

  @override
  void dispose() {
    super.dispose();
    controllers.values.forEach((controller) => controller.dispose());
  }

  Item? findMatchData(List<Item> itemList, String data) {
    Iterable<Item> matchingItems = itemList.where((item) => item.value == data);
    return matchingItems.isNotEmpty ? matchingItems.first : null;
  }

  Future<void> getDefaultData() async {
    isPageLoading = true;
    setState(() {});

    defaultData = new DefaultData.defaultDefaultData();
    loginUser = await getLoginUser();

    DefaultResponse defaultResponse =
        await DefaultRepository().getDefaultData(loginUser);

    if (defaultResponse.response.code == 200) {
      defaultData = defaultResponse.data;
      Map<String, dynamic> inputData = defaultData.inputData;

      selectedFormData['selectedWorkingYear'] =
          findMatchData(yearList, inputData['year_working_in_thailand']);
      selectedFormData['selectedWorkingMonth'] =
          findMatchData(monthList, inputData['month_working_in_thailand']);
      selectedFormData['selectedWorkType'] =
          findMatchData(workTypeList, inputData['type_of_work']);
      selectedFormData['selectedIndustry'] =
          findMatchData(industryList, inputData['industry']);

      controllers['debit']!.text =
          inputData.containsKey('debit') ? inputData['debit'] : null;

      controllers['monthlyRepaymentForDebit']!.text =
          inputData.containsKey('monthly_repayment_for_debit')
              ? inputData['monthly_repayment_for_debit']
              : null;

      controllers['salary']!.text =
          inputData.containsKey('salary') ? inputData['salary'] : null;

      controllers['loanAmount']!.text = inputData.containsKey('loan_amount')
          ? inputData['loan_amount']
          : null;

      selectedFormData['selectedLoanTermYear'] =
          findMatchData(yearList, inputData['loan_term_year']);
      selectedFormData['selectedLoanTermMonth'] =
          findMatchData(monthList, inputData['loan_term_month']);

      controllers['socialLinks']!.text = inputData.containsKey('social_links')
          ? inputData['social_links']
          : null;

      controllers['referralCode']!.text = inputData.containsKey('referral_code')
          ? inputData['referral_code']
          : null;

      selectedFormData['selectedPurposes'] = loanPurposes
          .where(
              (item) => inputData['main_purpose_of_loan'].contains(item.value))
          .toList();

      controllers['otherReason']!.text =
          inputData.containsKey('other_reason_for_main_purpose_of_loan')
              ? inputData['other_reason_for_main_purpose_of_loan']
              : null;
    }

    inValidFieldsAdd();

    isPageLoading = false;
    setState(() {});
  }

  void inValidFieldsAdd() {
    controllers.forEach((key, controller) {
      inValidFields.add(key);
      _inValidateField(key, 'controller');
      controller.addListener(() => _inValidateField(key, 'controller'));
    });

    inValidFields.remove("otherReason");

    selectedFormData.forEach((key, item) {
      inValidFields.add(key);
      _inValidateField(key, 'item');
    });
  }

  void _inValidateField(String key, String type) {
    setState(() {
      _error = null;
      inValidFields.remove(key);
      if (type == 'controller' && controllers[key]!.text.isEmpty) {
        inValidFields.add(key);
      } else if (type == 'item') {
        if (selectedFormData[key] is Item &&
            selectedFormData[key].value.isEmpty) {
          inValidFields.add(key);
        } else if (selectedFormData[key] is List<Item> &&
            selectedFormData[key].isEmpty) {
          inValidFields.add(key);
        }
      }
    });
  }

  Future<void> handleContinue() async {
    isLoading = true;
    setState(() {});

    final Map<String, dynamic> additionalInformation = {
      ...defaultData.inputData,
      'year_working_in_thailand':
          selectedFormData['selectedWorkingYear']?.value,
      'month_working_in_thailand':
          selectedFormData['selectedWorkingMonth']?.value,
      'type_of_work': selectedFormData['selectedWorkType']?.value,
      'industry': selectedFormData['selectedIndustry']?.value,
      'debit': controllers['debit']!.text,
      'monthly_repayment_for_debit':
          controllers['monthlyRepaymentForDebit']!.text,
      'salary': controllers['salary']!.text,
      'loan_amount': controllers['loanAmount']!.text,
      'loan_term_year': selectedFormData['selectedLoanTermYear']?.value,
      'loan_term_month': selectedFormData['selectedLoanTermMonth']?.value,
      'social_links': controllers['socialLinks']!.text,
      'referral_code': controllers['referralCode']!.text,
      'main_purpose_of_loan': selectedFormData['selectedPurposes']
          .map((item) => item.value)
          .toList(),
      'other_reason_for_main_purpose_of_loan': controllers['otherReason']!.text
    };

    final Map<String, dynamic> postBody = {
      'version_id': defaultData.versionId,
      'input_data': jsonEncode(additionalInformation),
    };

    DataResponse saveResponse = await ApplicationRepository()
        .saveLoanApplicationStep(postBody, loginUser, stepName);
    if (saveResponse.response.code != 200) {
      showErrorDialog('Error is occur, please contact admin');
    } else {
      loginUser.loanFormState = stepName;
      await setLoginUser(loginUser);
      isLoading = false;
      setState(() {});

      RouteService.checkLoginUserData(context);
    }
  }

  void handlePrevious() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DocumentFilePage()),
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
        title: Text('Additional Information', style: CustomStyle.appTitle()),
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
          return Stack(children: [
            if (isPageLoading)
              CustomWidget.loading()
            else
              SingleChildScrollView(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      spacing: 0,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegisterTabBar(activeStep: 2),
                        Padding(
                          padding: CustomStyle.pageWithoutTopPadding(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Length of time at current employer",
                                style: CustomStyle.subTitleBold(),
                              ),
                              CustomWidget.verticalSpacing(),
                              CustomWidget.dropdownButtonFormField(
                                label: 'Year',
                                selectedValue:
                                    selectedFormData['selectedWorkingYear'],
                                items: yearList,
                                onChanged: (value) {
                                  setState(() {
                                    controllers['workingYear']?.text =
                                        value!.value;
                                    selectedFormData['selectedWorkingYear'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonFormField(
                                label: 'Month',
                                selectedValue:
                                    selectedFormData['selectedWorkingMonth'],
                                items: monthList,
                                onChanged: (value) {
                                  setState(() {
                                    controllers['workingMonth']?.text =
                                        value!.value;
                                    selectedFormData['selectedWorkingMonth'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonFormField(
                                label: 'Type of Work',
                                selectedValue:
                                    selectedFormData['selectedWorkType'],
                                items: workTypeList,
                                onChanged: (Item? value) {
                                  setState(() {
                                    controllers['workType']?.text =
                                        value!.value;
                                    selectedFormData['selectedWorkType'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonFormField(
                                label: 'Industry',
                                selectedValue:
                                    selectedFormData['selectedIndustry'],
                                items: industryList,
                                onChanged: (value) {
                                  setState(() {
                                    controllers['industry']?.text =
                                        value!.value;
                                    selectedFormData['selectedIndustry'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.textField(
                                  controller: controllers['debit']!,
                                  label:
                                      'How much debit do you owe currently?'),
                              CustomWidget.numberTextField(
                                  controller:
                                      controllers['monthlyRepaymentForDebit']!,
                                  label: 'Monthly repayment for debit'),
                              CustomWidget.numberTextField(
                                  controller: controllers['salary']!,
                                  label: 'Salary'),
                              CustomWidget.numberTextField(
                                  controller: controllers['loanAmount']!,
                                  label: 'Loan amount'),
                              Text(
                                "Loan Term",
                                style: CustomStyle.subTitleBold(),
                              ),
                              CustomWidget.verticalSpacing(),
                              CustomWidget.dropdownButtonFormField(
                                label: 'Year',
                                selectedValue:
                                    selectedFormData['selectedLoanTermYear'],
                                items: yearList,
                                onChanged: (value) {
                                  setState(() {
                                    controllers['loanTermYear']?.text =
                                        value!.value;
                                    selectedFormData['selectedLoanTermYear'] =
                                        value!;
                                  });
                                },
                              ),
                              CustomWidget.dropdownButtonFormField(
                                label: 'Month',
                                selectedValue:
                                    selectedFormData['selectedLoanTermMonth'],
                                items: monthList,
                                onChanged: (value) {
                                  setState(() {
                                    controllers['loanTermMonth']?.text =
                                        value!.value;
                                    selectedFormData['selectedLoanTermMonth'] =
                                        value!;
                                  });
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Main purpose of loan",
                                    style: CustomStyle.subTitleBold(),
                                  ),
                                  CustomWidget.verticalSpacing(),
                                  ...loanPurposes.map((purpose) =>
                                      CustomWidget.checkbox(
                                          selectedFormData['selectedPurposes'],
                                          purpose, () {
                                        setState(() {
                                          if (selectedFormData[
                                                  'selectedPurposes']
                                              .any((item) =>
                                                  item.value ==
                                                  purpose.value)) {
                                            selectedFormData['selectedPurposes']
                                                .removeWhere((item) =>
                                                    item.value ==
                                                    purpose.value);
                                          } else {
                                            selectedFormData['selectedPurposes']
                                                .add(purpose);
                                          }

                                          if (selectedFormData[
                                                  'selectedPurposes']
                                              .isNotEmpty) {
                                            inValidFields.remove("mainPurpose");
                                          } else {
                                            inValidFields.add("mainPurpose");
                                          }

                                          if (purpose.value ==
                                              'other_reasons') {
                                            controllers['otherReason']?.text =
                                                "";

                                            bool isOtherSelected =
                                                selectedFormData[
                                                        'selectedPurposes']
                                                    .any((item) =>
                                                        item.value ==
                                                        'other_reasons');

                                            if (isOtherSelected) {
                                              inValidFields.add("otherReason");
                                            } else {
                                              inValidFields
                                                  .remove("otherReason");
                                            }
                                          }
                                        });
                                      })),
                                ],
                              ),
                              if (selectedFormData['selectedPurposes']
                                  .any((item) => item.value == 'other_reasons'))
                                CustomWidget.textField(
                                    controller: controllers['otherReason']!,
                                    label: 'Other reasons'),
                              CustomWidget.verticalSpacing(),
                              CustomWidget.textField(
                                  controller: controllers['socialLinks']!,
                                  label: 'Facebook account profile link'),
                              CustomWidget.textField(
                                  controller: controllers['referralCode']!,
                                  label: 'Referral Code'),
                              Text(inValidFields.join(', ')),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomWidget.elevatedButton(
                                      enabled: true,
                                      isLoading: false,
                                      text: 'Previous',
                                      onPressed: handlePrevious,
                                    ),
                                  ),
                                  CustomWidget.horizontalSpacing(),
                                  Expanded(
                                    child: CustomWidget.elevatedButton(
                                      enabled: inValidFields.isEmpty,
                                      isLoading: isLoading,
                                      text: 'Continue',
                                      onPressed: handleContinue,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
          ]);
        },
      ),
    );
  }
}
