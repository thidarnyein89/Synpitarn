import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/json_data/common.dart';
import 'package:synpitarn/data/json_data/guide/en.dart';
import 'package:synpitarn/data/json_data/guide/mm.dart';
import 'package:synpitarn/data/json_data/guide/th.dart';
import 'package:synpitarn/data/language.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/models/guide.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:synpitarn/screens/components/dashed_circle_painter.dart';
import 'package:synpitarn/screens/components/page_app_bar.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class GuidePage extends StatefulWidget {
  int activeStep;

  GuidePage({super.key, required this.activeStep});

  @override
  GuideState createState() => GuideState();
}

class GuideState extends State<GuidePage> {
  final CommonService _commonService = CommonService();

  ScrollController _scrollController = ScrollController();
  bool hasScrolledToInitialStep = false;

  List<Guide> guideList = [];
  List<double> contentHeight = [];
  List<List<ContentBlock>> allContent = [];

  int activeStep = 0;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getInitData() async {

    if (Language.currentLanguage == LanguageType.en) {
      allContent = GuideEnglish.allContent;
    }
    else if(Language.currentLanguage == LanguageType.my) {
      allContent = GuideMyanmar.allContent;
    }
    else if(Language.currentLanguage == LanguageType.th) {
      allContent = GuideThai.allContent;
    }

    guideList = await _commonService.readGuideData();

    contentHeight = List.generate(guideList.length, (index) => 0);
    activeStep = widget.activeStep;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int numberOfSteps = 3;
    double borderThickness = 3;

    double lineLength = (screenWidth -
        (CustomStyle.pagePadding().horizontal * 6) -
        (borderThickness * 3)) /
        numberOfSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageAppBar(title: AppLocalizations.of(context)!.howToApplyLoan),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: CustomStyle.pagePadding(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.howToApplyLoan,
                        style: CustomStyle.titleBold()),
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
                      steps: guideList.map((guide) {
                        return EasyStep(
                          customStep: Icon(
                            guide.icon,
                            color: CustomStyle.icon_color,
                          ),
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
                        widget.activeStep = 0;
                        activeStep = index;

                        setState(() { });

                        _scrollToStep(index);
                      },
                    ),
                    CustomWidget.verticalSpacing(),
                    CustomWidget.verticalSpacing(),
                    CustomWidget.verticalSpacing(),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: guideList.length,
                        itemBuilder: (context, index) {
                          return stepWidget(index: index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget stepWidget({required int index}) {
    GlobalKey contentKey = GlobalKey();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = contentKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final newHeight = box.size.height;

          if (contentHeight[index] != newHeight) {
            setState(() {
              contentHeight[index] = newHeight;
            });
          }
        }
      }

      if(widget.activeStep > 0) {
        _scrollToStep(widget.activeStep);
      }

    });

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              color: Colors.white,
              child: CustomPaint(
                painter: DashedCirclePainter(
                  color: CustomStyle.secondary_color,
                  strokeWidth: 2,
                ),
                child: Center(
                  child: Icon(
                    guideList[index].icon,
                    color: CustomStyle.icon_color,
                  ),
                ),
              ),
            ),
            CustomWidget.horizontalSpacing(),
            Expanded(
              child: Text(
                "${guideList[index].getStep()} ${guideList[index].getTitle()}",
                style: CustomStyle.bodyBold(),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Align(
                alignment: Alignment.topCenter,
                child: contentHeight.length > index && contentHeight[index] > 0
                    ? DottedLine(
                  direction: Axis.vertical,
                  lineLength: contentHeight[index],
                  dashLength: 3,
                  dashColor: Colors.yellow,
                  lineThickness: 2,
                )
                    : SizedBox.shrink(),
              ),
            ),
            CustomWidget.horizontalSpacing(),
            Expanded(
              child: Column(
                key: contentKey,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget.verticalSpacing(),
                  ...allContent[index].map((block) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: block.paddingLeft!.toDouble(),
                        bottom: 20,
                      ),
                      child: buildTextSpan(context, block.textData!),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _scrollToStep(int index) {
    double position = 0.0;

    for (var i = 0; i < index; i++) {
      position += contentHeight[i] + 50;
    }

    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  RichText buildTextSpan(BuildContext context, List<Data> dataList) {
    return RichText(
      text: TextSpan(
        children: dataList.map((data) {
          if (data.url != null) {
            return TextSpan(
              style: data.style,
              text: data.text,
              recognizer: TapGestureRecognizer()..onTap = () async {
                final Uri uri = Uri.parse(data.url!);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            );
          } else {
            return TextSpan(
              style: data.style ?? CustomStyle.body(),
              text: data.text,
            );
          }
        }).toList(),
      ),
    );
  }
}