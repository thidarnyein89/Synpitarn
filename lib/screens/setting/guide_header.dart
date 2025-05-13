import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/language.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/models/guide.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/screens/setting/guide.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuideHeaderPage extends StatefulWidget {

  const GuideHeaderPage({super.key});

  @override
  GuideHeaderState createState() => GuideHeaderState();
}

class GuideHeaderState extends State<GuideHeaderPage> {
  final CommonService _commonService = CommonService();

  List<Guide> guideList = [];
  int activeStep = 0;

  @override
  void initState() {
    super.initState();
    readGuideData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> readGuideData() async {
    guideList = await _commonService.readGuideData();

    if(mounted) {
      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int numberOfSteps = 3;
    double borderThickness = 3;

    double lineLength =
        (screenWidth -
            (CustomStyle.pagePadding().horizontal * 6) -
            (borderThickness * 3)) /
        numberOfSteps;

    return Padding(
      padding: CustomStyle.pagePadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.howToApplyLoan, style: CustomStyle.titleBold()),
          EasyStepper(
            activeStep: activeStep,
            maxReachedStep: 3,
            stepShape: StepShape.circle,
            stepBorderRadius: 15,
            borderThickness: 3,
            stepRadius: 28,
            finishedStepBorderColor: CustomStyle.secondary_color,
            finishedStepTextColor: Colors.black,
            finishedStepBackgroundColor: Colors.white,
            activeStepIconColor: CustomStyle.secondary_color,
            activeStepBorderColor: CustomStyle.secondary_color,
            unreachedStepBackgroundColor: Colors.white,
            unreachedStepBorderColor: CustomStyle.secondary_color,
            showLoadingAnimation: false,
            lineStyle: LineStyle(
              lineType: LineType.dashed,
              defaultLineColor: CustomStyle.secondary_color,
              lineLength: lineLength,
              lineThickness: 2,
              lineSpace: 0.5,
            ),
            steps:
                guideList.map((guide) {
                  return EasyStep(
                    customStep: Icon(guide.icon, color: CustomStyle.icon_color),
                    customTitle: Text(
                      guide.getTitle(),
                      style: CustomStyle.body(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  );
                }).toList(),
            onStepReached: (index) {
              activeStep = index;

              if(mounted) {
                setState(() { });
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuidePage(activeStep: activeStep),
                ),
              );
            },
          ),
          CustomWidget.verticalSpacing(),
        ],
      ),
    );
  }
}
