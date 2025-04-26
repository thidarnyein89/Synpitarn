import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_schedule.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/components/main_app_bar.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/services/route_service.dart';

class RepaymentListPage extends StatefulWidget {
  Loan loan = Loan.defaultLoan();

  RepaymentListPage({super.key, required this.loan});

  @override
  RepaymentListState createState() => RepaymentListState();
}

class RepaymentListState extends State<RepaymentListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget createLoanSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget.buildRow(
            "Contract No", widget.loan.contractNoRef.toString()),
        CustomWidget.buildRow(
            "Loan Size", CommonService.getLoanSize(widget.loan)),
        CustomWidget.buildRow("Loan Term", "${widget.loan.termPeriod} Months"),
      ],
    );
  }

  Widget createRepaymentSection() {
    return Column(
      children: [
        CustomWidget.verticalSpacing(),
        CustomWidget.verticalSpacing(),
        ...List.generate(
          widget.loan.schedules!.length,
          (index) {
            final isLast = index == widget.loan.schedules!.length - 1;
            return repaymentStep(
              widget.loan.schedules![index],
              isLast: isLast,
            );
          },
        ),
      ],
    );
  }

  Widget repaymentStep(LoanSchedule schedule, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: schedule.status == 'paid'
                    ? Colors.green
                    : CustomStyle.secondary_color,
                shape: BoxShape.circle,
              ),
              child: (schedule.status == "paid")
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : Container(
                      height: 16,
                    ),
            ),
            if (!isLast)
              Container(
                height: 80,
                width: 2,
                color: CustomStyle.secondary_color,
              ),
          ],
        ),
        CustomWidget.horizontalSpacing(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                "${ConstantData.numberWords[schedule.currentScheduleNo - 1]} Repayment",
                style: CustomStyle.subTitle(),
              ),
              Text(
                'Repayment amount : ${schedule.pmtAmount}',
                style: CustomStyle.body(),
              ),
              Text(
                'Repayment date: ${CommonService.formatDate(schedule.pmtDate)}',
                style: CustomStyle.bodyGreyColor(),
              ),
              CustomWidget.verticalSpacing(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: widget.loan.contractNoRef),
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
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
                        child: Column(
                          children: [
                            createLoanSection(),
                            createRepaymentSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
