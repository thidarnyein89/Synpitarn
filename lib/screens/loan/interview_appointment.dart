import 'package:flutter/material.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/repositories/data_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/loan/appointment-success.dart';
import 'package:synpitarn/services/route_service.dart';

class InterviewAppointmentPage extends StatefulWidget {
  const InterviewAppointmentPage({super.key});

  @override
  InterviewAppointmentState createState() => InterviewAppointmentState();
}

class InterviewAppointmentState extends State<InterviewAppointmentPage> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  final Map<String, TextEditingController> textControllers = {
    'date': TextEditingController(),
    'url': TextEditingController()
  };

  Map<String, dynamic> dropdownControllers = {
    'time': null,
    'channel': null,
  };

  Map<String, dynamic> itemDataList = {
    'time': [],
    'channel': ['FB Messenger', 'Viber', 'Line'],
  };

  final Set<String> inValidFields = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDefaultData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getDefaultData() async {
    getDefaultTimeList();
    loginUser = await getLoginUser();
    setState(() {});

    inValidFieldsAdd();
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

    if(key == "date") {
      inValidFields.add('time');
      dropdownControllers['time'] = null;
      setState(() {});

      getApiTimeList();
    }
  }

  void getDefaultTimeList() {
    itemDataList["time"] = <String>[];

    DateTime start = DateTime(0, 1, 1, 7, 0);
    DateTime end = DateTime(0, 1, 1, 20, 0);

    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      final hour = start.hour > 12 ? start.hour - 12 : start.hour;
      final minute = start.minute.toString().padLeft(2, '0');
      final period = start.hour >= 12 ? 'PM' : 'AM';

      itemDataList["time"]
          .add('${hour.toString().padLeft(2, '0')}:$minute $period');
      start = start.add(Duration(minutes: 30));
    }

    setState(() {});
  }

  Future<void> getApiTimeList() async {
    itemDataList["time"] = <String>[];

    final Map<String, dynamic> postBody = {
      'date': textControllers['date']?.text,
    };

    DataResponse dataResponse =
        await DataRepository().getAvailableTime(postBody, loginUser);
    if (dataResponse.response.code != 200) {
      showErrorDialog(dataResponse.response.message ?? AppConfig.ERR_MESSAGE);
    } else {
      itemDataList["time"] = dataResponse.data.map((d) => d.toString()).toList();
    }

    setState(() {});
  }

  Future<void> handleAppointment() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> postBody = {
      'date': textControllers['date']?.text,
      'time': dropdownControllers['time'],
      'channel': dropdownControllers['channel'],
      'url': textControllers['url']?.text,
    };

    DataResponse saveResponse = await ApplicationRepository()
        .saveInterviewAppointment(postBody, loginUser);
    if (saveResponse.response.code != 200) {
      showErrorDialog(saveResponse.response.message ?? AppConfig.ERR_MESSAGE);
    } else {
      loginUser.loanApplicationSubmitted = true;
      setLoginUser(loginUser);

      isLoading = false;
      setState(() {});

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppointmentSuccessPage()),
      );
    }
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showErrorDialog(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final maxDate = DateTime(today.year, today.month, today.day + 14);
    final minDate = DateTime(today.year, today.month, today.day);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomStyle.primary_color,
        title: Text(
          'Interview Appointment',
          style: CustomStyle.appTitle(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: CustomStyle.pagePadding(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                              dropdownControllers['time'] = value.toString();
                            });
                          },
                        ),
                        CustomWidget.dropdownButtonSameValue(
                          label: 'Social Media Channel',
                          selectedValue: dropdownControllers['channel'],
                          items: itemDataList['channel'],
                          onChanged: (value) {
                            setState(() {
                              inValidFields.remove('channel');
                              dropdownControllers['channel'] = value.toString();
                            });
                          },
                        ),
                        CustomWidget.textField(
                            controller: textControllers['url']!,
                            label: 'Social Media Url'),
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
          );
        },
      ),
    );
  }
}
