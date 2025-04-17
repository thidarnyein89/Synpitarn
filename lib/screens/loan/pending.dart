import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:intl/intl.dart';

class PendingPage extends StatefulWidget {
  Loan applicationData;

  PendingPage({super.key, required this.applicationData});

  @override
  PendingState createState() => PendingState();
}

class PendingState extends State<PendingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleReSubmit() {}

  String formatDate(String rawDate) {
    DateTime parsedDate = DateTime.parse(rawDate);
    return DateFormat("dd MMM yyyy").format(parsedDate);
  }

  String formatTime(String rawTime) {
    DateTime parsedTime = DateFormat("HH:mm:ss").parse(rawTime);
    return DateFormat("hh:mm a").format(parsedTime); // 12-hour with AM/PM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
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
                      Text(
                        'Pending Loan Application',
                        style: CustomStyle.titleBold(),
                      ),
                      CustomWidget.verticalSpacing(),
                      CustomWidget.verticalSpacing(),
                      _buildRow("Contract No",
                          widget.applicationData.contractNo.toString()),
                      _buildRow(
                          "Loan Applied Date",
                          formatDate(
                              widget.applicationData.createdAt.toString())),
                      _buildRow(
                          "Request Interview Date",
                          formatDate(widget.applicationData.appointmentDate
                              .toString())),
                      _buildRow(
                          "Request Interview Time",
                          formatTime(widget.applicationData.appointmentTime
                              .toString())),
                      _buildRow("Loan Status",
                          widget.applicationData.appointmentStatus.toString()),
                      CustomWidget.verticalSpacing(),
                      Text(
                        "Your need to take interview appointment again",
                        style: CustomStyle.bodyRedColor(),
                      ),
                      CustomWidget.verticalSpacing(),
                      ElevatedButton(
                        onPressed: handleReSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomStyle.primary_color,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Resubmit Interview Appointment',
                          style: CustomStyle.bodyWhiteColor(),
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
            SizedBox(width: 200, child: Text(label, style: CustomStyle.body())),
            Text(" : "),
            Expanded(child: Text(value, style: CustomStyle.body())),
          ],
        ),
        CustomWidget.verticalSpacing(),
      ],
    );
  }
}
