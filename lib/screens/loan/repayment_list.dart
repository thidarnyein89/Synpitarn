import 'package:flutter/material.dart';
import 'package:synpitarn/data/constant.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/loan_schedule.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/common_service.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
    String scheduleStatus = schedule.status.toLowerCase();
    int dayCount = CommonService.getDayCount(schedule.pmtDate);
    bool isPaid = scheduleStatus == 'paid';

    TextStyle lineThroughStyle = const TextStyle();
    TextStyle overdueStyle = const TextStyle();

    if (isPaid) {
      lineThroughStyle = const TextStyle(decoration: TextDecoration.lineThrough);
    } else if (dayCount > 0) {
      scheduleStatus = "Overdue $dayCount Days";
      overdueStyle = const TextStyle(color: Colors.red);
    }
    setState(() {});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "${ConstantData.numberWords[schedule.currentScheduleNo - 1]} Repayment",
          style: CustomStyle.subTitleBold(),
        ),
        CustomWidget.verticalSmallSpacing(),
        CustomWidget.buildRow("Repayment amount", schedule.pmtAmount,
            otherStyle: lineThroughStyle),
        CustomWidget.buildRow(
            "Repayment date", CommonService.formatDate(schedule.pmtDate),
            otherStyle: lineThroughStyle),
        CustomWidget.buildRow("Repayment status", scheduleStatus,
            otherStyle: lineThroughStyle.merge(overdueStyle)),
        CustomWidget.verticalSmallSpacing(),
        if (!isLast) Divider(thickness: 1, color: Colors.grey),
        CustomWidget.verticalSmallSpacing(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: widget.loan.contractNoRef),
      body: Padding(
        padding: CustomStyle.pagePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            createLoanSection(),
            CustomWidget.verticalSpacing(),
            Expanded(
              child: SingleChildScrollView(
                child: createRepaymentSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
