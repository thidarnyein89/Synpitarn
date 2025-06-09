import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/loan.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/screens/components/qr_dialog.dart';
import 'package:synpitarn/screens/loan/repayment_list.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/services/route_service.dart';
import 'package:synpitarn/l10n/app_localizations.dart';

class PreviousLoanPage extends StatefulWidget {
  Loan? loan = Loan.defaultLoan();

  PreviousLoanPage({super.key, this.loan});

  @override
  PreviousLoanState createState() => PreviousLoanState();
}

class PreviousLoanState extends State<PreviousLoanPage> {
  User loginUser = User.defaultUser();
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
    setState(() {});

    isLoading = false;
    setState(() {});
  }

  handleViewRepayment() {
    RouteService.goToNavigator(context, RepaymentListPage(loan: widget.loan!));
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }

  Widget createLoanCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomWidget.buildRow(
          AppLocalizations.of(context)!.contractNo,
          widget.loan!.contractNoRef.toString(),
        ),
        CustomWidget.buildRow(
          AppLocalizations.of(context)!.loanStatus,
          CommonService.getLoanStatus(
            widget.loan!.loanApplicationStatus.toString(),
          ),
        ),
        CustomWidget.buildRow(
          AppLocalizations.of(context)!.loanSize,
          CommonService.getLoanSize(context, widget.loan!),
        ),
        CustomWidget.buildRow(
          AppLocalizations.of(context)!.loanTerm,
          "${widget.loan!.termPeriod} ${AppLocalizations.of(context)!.months}",
        ),
        CustomWidget.buildRow(
          AppLocalizations.of(context)!.firstPaymentDate,
          CommonService.formatDate(widget.loan!.firstRepaymentDate.toString()),
        ),
        CustomWidget.buildRow(
          AppLocalizations.of(context)!.lastPaymentDate,
          CommonService.formatDate(widget.loan!.lastRepaymentDate.toString()),
        ),
        CustomWidget.verticalSpacing(),
        if (widget.loan!.qrcode.photo != "")
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  QRDialog.showQRDialog(
                    context,
                    widget.loan!.qrcode.photo,
                    widget.loan!.qrcode.string,
                  );
                },
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/spinner.gif'),
                  image: NetworkImage(widget.loan!.qrcode.photo),
                  fit: BoxFit.contain,
                  width: 200,
                  height: 200,
                  imageErrorBuilder:
                      (context, error, stackTrace) => Icon(Icons.broken_image),
                ),
              ),
              Text(widget.loan!.qrcode.string),
              CustomWidget.verticalSpacing(),
            ],
          ),
        if ((widget.loan?.schedules ?? []).isNotEmpty)
          CustomWidget.elevatedButton(
            context: context,
            text: AppLocalizations.of(context)!.viewRepaymentSchedule,
            onPressed: handleViewRepayment,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: widget.loan!.contractNoRef),
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
                            child: createLoanCard(),
                          ),
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
}
