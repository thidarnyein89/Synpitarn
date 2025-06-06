import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/register_step.dart';
import 'package:synpitarn/data/custom_style.dart';

class RegisterTabBar extends StatefulWidget {
  int activeStep = 0;

  RegisterTabBar({super.key, required this.activeStep});

  @override
  RegisterTabBarState createState() => RegisterTabBarState();
}

class RegisterTabBarState extends State<RegisterTabBar> {
  List<StepData> registerSteps = [];

  @override
  void initState() {
    super.initState();
    getRegisterSteps();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getRegisterSteps() async {
    registerSteps = StepData.getRegisterSteps()
        .where((step) => step.isForCard == false)
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      showScrollbar: false,
      padding: EdgeInsets.zero,
      activeStep: widget.activeStep,
      maxReachedStep: registerSteps.length - 1,
      stepShape: StepShape.circle,
      stepBorderRadius: 15,
      borderThickness: 3,
      stepRadius: 28,
      finishedStepBorderColor: CustomStyle.secondary_color,
      finishedStepBackgroundColor: Colors.white,
      finishedStepIconColor: CustomStyle.icon_color,
      activeStepBorderColor: CustomStyle.primary_color,
      activeStepBackgroundColor: Colors.white,
      unreachedStepBorderColor: CustomStyle.icon_color,
      showLoadingAnimation: false,
      lineStyle: LineStyle(
        lineType: LineType.dashed,
        defaultLineColor: CustomStyle.secondary_color,
        lineLength: 30,
        lineThickness: 2,
        lineSpace: 0.5,
      ),
      steps: registerSteps.map((step) {
        return EasyStep(
          icon: Icon(step.icon, color: CustomStyle.icon_color),
        );
      }).toList(),
    );
  }
}
