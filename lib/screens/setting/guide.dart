import 'package:flutter/material.dart';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:synpitarn/models/guide.dart';
import 'package:synpitarn/my_theme.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:synpitarn/screens/components/dashed_circle_painter.dart';
import 'package:synpitarn/services/common_service.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  GuideState createState() => GuideState();
}

class GuideState extends State<GuidePage> {
  final CommonService _commonService = CommonService();
  List<Guide> guideList = [];

  int activeStep = 0;

  List<double> _htmlHeight = [];

  ScrollController _scrollController = ScrollController();

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int numberOfSteps = 5;
    double padding = 100;
    double lineLength = (screenWidth - padding) / numberOfSteps;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Step-by-Step Guide",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          EasyStepper(
            activeStep: activeStep,
            maxReachedStep: 3,
            stepShape: StepShape.circle,
            stepBorderRadius: 15,
            borderThickness: 2,
            stepRadius: 28,
            finishedStepBorderColor: MyTheme.secondary_color,
            finishedStepTextColor: Colors.black,
            finishedStepBackgroundColor: Colors.white,
            activeStepIconColor: MyTheme.secondary_color,
            activeStepBorderColor: MyTheme.secondary_color,
            unreachedStepBackgroundColor: Colors.white,
            unreachedStepBorderColor: MyTheme.secondary_color,
            showLoadingAnimation: false,
            lineStyle: LineStyle(
              lineType: LineType.dashed,
              defaultLineColor: MyTheme.secondary_color,
              lineLength: lineLength,
              lineThickness: 1.2,
              lineSpace: 0.5,
            ),
            steps:
                guideList.map((guide) {
                  return EasyStep(
                    customStep: Icon(
                      guide.icon,
                      color: MyTheme.secondary_color,
                    ),
                    customTitle: Text(
                      guide.titleEN,
                      style: const TextStyle(fontSize: 12),
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
          SizedBox(height: 20),
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
                painter: DashedCirclePainter(color: Colors.yellow),
                child: Center(
                  child: Icon(guideList[index].icon, color: Colors.yellow),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                "${guideList[index].stepEN} ${guideList[index].titleEN}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                child: _htmlHeight.isNotEmpty && _htmlHeight[index] > 0
                    ? DottedLine(
                  direction: Axis.vertical,
                  lineLength: _htmlHeight[index],
                  dashLength: 4,
                  dashColor: Colors.yellow,
                  lineThickness: 1,
                )
                    : SizedBox.shrink(),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Html(
                key: htmlKey,
                data: guideList[index].descriptionEN,
                style: {
                  "ul": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                  "li": Style(margin: Margins.zero, padding: HtmlPaddings.only(left: 0)),
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _scrollToStep(int index) {
    double position = 0.0;

    for(var i = 0; i < index; i++) {
      position += _htmlHeight[i];
    }

    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
