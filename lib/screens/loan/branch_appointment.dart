import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/branch.dart';
import 'package:synpitarn/models/branch_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/branch_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/auth_service.dart';

class BranchAppointmentPage extends StatefulWidget {
  Loan? applicationData;

  BranchAppointmentPage({super.key, required this.applicationData});

  @override
  BranchAppointmentState createState() => BranchAppointmentState();
}

class BranchAppointmentState extends State<BranchAppointmentPage> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();
  List<Branch>? branchList;

  final Map<String, TextEditingController> textControllers = {
    'branch_name': TextEditingController(),
    'date': TextEditingController(),
    'applied_amount': TextEditingController(),
    'loan_term': TextEditingController(),
    'status': TextEditingController(),
  };

  Map<String, dynamic> dropdownControllers = {
    'time': null,
  };

  Map<String, dynamic> itemDataList = {
    'time': <String>[],
  };

  final Set<String> inValidFields = {};

  bool isLoading = false;

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
    isLoading = true;
    loginUser = await getLoginUser();
    await getBranches();

    itemDataList["time"] =
        List<String>.from(widget.applicationData?.branchSectionTimeSlot ?? []);
    textControllers['applied_amount']?.text =
        widget.applicationData?.approvedAmount.toString() ?? "";
    textControllers['loan_term']?.text =
        "${widget.applicationData?.loanTerm.toString()} Months" ?? "";
    textControllers['status']?.text = "Pending branch visit";

    textControllers['branch_name']?.text = branchList!
            .firstWhere(
                (branch) => branch.id == widget.applicationData?.branchId)
            .nameEn ??
        "";

    isLoading = false;
    setState(() {});

    inValidFieldsAdd();
  }

  Future<void> getBranches() async {
    BranchResponse branchResponse = await BranchRepository().getBranches();

    if (branchResponse.response.code == 200) {
      branchList = branchResponse.data;
      setState(() {});
    } else if (branchResponse.response.code == 403) {
      await showErrorDialog(branchResponse.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(branchResponse.response.message);
    }
  }

  void inValidFieldsAdd() {
    textControllers.forEach((key, controller) {
      _inValidateField(key);
      controller.addListener(() => _inValidateField(key));
    });

    dropdownControllers.forEach((key, item) {
      inValidFields.add(key);
    });

    setState(() {});
  }

  void _inValidateField(String key) {
    setState(() {
      inValidFields.remove(key);

      if (textControllers[key]!.text.isEmpty) {
        inValidFields.add(key);
      } else {
        inValidFields.remove(key);
      }
    });
  }

  DateTime parseTime(String timeStr, DateTime baseDate) {
    final time = TimeOfDay.fromDateTime(DateFormat.jm().parse(timeStr));
    return DateTime(
        baseDate.year, baseDate.month, baseDate.day, time.hour, time.minute);
  }

  Future<void> handleAppointment() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> postBody = {
      'date': textControllers['date']?.text,
      'time': dropdownControllers['time'],
    };

    BranchResponse response =
        await BranchRepository().saveAppointment(postBody, loginUser);

    if (response.response.code == 200) {
      isLoading = false;
      setState(() {});

      Navigator.pop(context);
    } else if (response.response.code == 403) {
      await showErrorDialog(response.response.message);
      AuthService().logout(context);
    } else {
      showErrorDialog(response.response.message);
    }
  }

  Future<void> showErrorDialog(String errorMessage) async {
    await CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final maxDate = DateTime(today.year, today.month, today.day + 14);
    final minDate = DateTime(today.year, today.month, today.day + 1);

    return Scaffold(
      appBar: PageAppBar(title: "Branch Appointment"),
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
                      child: Padding(
                        padding: CustomStyle.pagePadding(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Loan Information",
                                  style: CustomStyle.subTitleBold()),
                              CustomWidget.verticalSpacing(),
                              CustomWidget.textField(
                                  readOnly: true,
                                  controller:
                                      textControllers['applied_amount']!,
                                  label: 'Loan Size'),
                              CustomWidget.textField(
                                  readOnly: true,
                                  controller: textControllers['loan_term']!,
                                  label: 'Loan Term'),
                              CustomWidget.textField(
                                  readOnly: true,
                                  controller: textControllers['status']!,
                                  label: 'Status'),
                              CustomWidget.verticalSpacing(),
                              Text(" Appointment Information ",
                                  style: CustomStyle.subTitleBold()),
                              CustomWidget.verticalSpacing(),
                              CustomWidget.textField(
                                  readOnly: true,
                                  controller: textControllers['branch_name']!,
                                  label: 'Appointment Branch'),
                              CustomWidget.datePicker(
                                  context: context,
                                  controller: textControllers['date']!,
                                  label: 'Appointment Date',
                                  readOnly: true,
                                  maxDate: maxDate,
                                  minDate: minDate),
                              CustomWidget.dropdownButtonSameValue(
                                label: 'Available Time',
                                selectedValue: dropdownControllers['time'],
                                items: itemDataList['time'],
                                onChanged: (value) {
                                  setState(() {
                                    inValidFields.remove('time');
                                    dropdownControllers['time'] =
                                        value.toString();
                                  });
                                },
                              ),
                              CustomWidget.elevatedButton(
                                enabled: inValidFields.isEmpty,
                                isLoading: isLoading,
                                text: 'Make Appointment',
                                onPressed: handleAppointment,
                              ),
                            ]),
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
}
