import 'package:flutter/material.dart';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/models/guide.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:synpitarn/screens/components/dashed_circle_painter.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:synpitarn/data/app_config.dart';

class GuidePage extends StatefulWidget {
  int activeStep;

  GuidePage({super.key, required this.activeStep});

  @override
  GuideState createState() => GuideState();
}

class GuideState extends State<GuidePage> {
  final CommonService _commonService = CommonService();
  ScrollController _scrollController = ScrollController();

  List<Guide> guideList = [];
  List<double> _htmlHeight = [];

  int activeStep = 0;

  @override
  void initState() {
    super.initState();
    readGuideData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> readGuideData() async {
    guideList = await _commonService.readGuideData();

    _htmlHeight = List.generate(guideList.length, (index) => 0);
    activeStep = widget.activeStep;

    setState(() {});
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
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
                    Text("Step-by-Step Guide", style: CustomStyle.titleBold()),
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
                              customStep: Icon(
                                guide.icon,
                                color: CustomStyle.icon_color,
                              ),
                              customTitle: Text(
                                guide.titleEN,
                                style: CustomStyle.body(),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                      onStepReached: (index) {
                        setState(() {
                          activeStep = index;
                        });
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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: AppConfig.SETTING_INDEX,
        onItemTapped: (index) {
          setState(() {
            AppConfig.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget stepWidget({required int index}) {
    GlobalKey htmlKey = GlobalKey();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = htmlKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final newHeight = box.size.height;

          if (_htmlHeight[index] != newHeight) {
            _htmlHeight[index] = newHeight;
            setState(() {});
          }
        }
      }

      if (widget.activeStep == activeStep) {
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
                "${guideList[index].stepEN} ${guideList[index].titleEN}",
                style: CustomStyle.titleBold(),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Align(
                alignment: Alignment.topCenter,
                child:
                    _htmlHeight.isNotEmpty && _htmlHeight[index] > 0
                        ? DottedLine(
                          direction: Axis.vertical,
                          lineLength: _htmlHeight[index],
                          dashLength: 3,
                          dashColor: Colors.yellow,
                          lineThickness: 2,
                        )
                        : SizedBox.shrink(),
              ),
            ),
            CustomWidget.horizontalSpacing(),
            Expanded(
              child: Html(
                key: htmlKey,
                data: guideList[index].descriptionEN,
                style: {
                  "ul": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                  "li": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.only(left: 0),
                  ),
                },
              ),
            ),
            CustomWidget.verticalSpacing(),
          ],
        ),
      ],
    );
  }

  void _scrollToStep(int index) {
    double position = 0.0;

    for (var i = 0; i < index; i++) {
      position += _htmlHeight[i] + 50;
    }

    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
