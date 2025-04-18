import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/models/data_response.dart';
import 'package:synpitarn/models/default/default_data.dart';
import 'package:synpitarn/models/default/default_response.dart';
import 'package:synpitarn/repositories/default_repository.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/scanner_error_widget.dart';
import 'package:synpitarn/screens/components/toggle_flashlight_button.dart';
import 'package:synpitarn/screens/components/scan_window_overlay.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/models/workpermit_response.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/screens/components/switch_camera_button.dart';
import 'package:synpitarn/services/route_service.dart';

class WorkPermitPage extends StatefulWidget {
  const WorkPermitPage({super.key});

  @override
  WorkPermitState createState() => WorkPermitState();
}

class WorkPermitState extends State<WorkPermitPage> {
  User loginUser = User.defaultUser();
  DefaultData defaultData = new DefaultData.defaultDefaultData();

  static const useScanWindow = true;

  late MobileScannerController controller = initController();

  //For EasyStepper
  int activeStep = 0;

  Size desiredCameraResolution = const Size(1920, 1080);
  DetectionSpeed detectionSpeed = DetectionSpeed.unrestricted;
  int detectionTimeoutMs = 1000;

  bool useBarcodeOverlay = true;
  BoxFit boxFit = BoxFit.cover;
  bool enableLifecycle = false;

  List<BarcodeFormat> selectedFormats = [BarcodeFormat.all];

  MobileScannerController initController() => MobileScannerController(
        autoStart: false,
        cameraResolution: desiredCameraResolution,
        detectionSpeed: detectionSpeed,
        detectionTimeoutMs: detectionTimeoutMs,
        formats: selectedFormats,
      );

  String stepName = "qr_scan";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    unawaited(controller.start());
    getDefaultData();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  Future<void> getDefaultData() async {
    defaultData = new DefaultData.defaultDefaultData();
    loginUser = await getLoginUser();

    DefaultResponse defaultResponse =
        await DefaultRepository().getDefaultData(loginUser);

    if (defaultResponse.response.code == 200) {
      defaultData = defaultResponse.data;
    }

    setState(() {});
  }

  void _onDetect(BarcodeCapture barCode) {
    isLoading = true;
    setState(() {});

    final scannedBarcodes = barCode.barcodes ?? [];

    final values = scannedBarcodes.map((e) => e.displayValue).join('\n');

    if (scannedBarcodes.isEmpty) {
      print("'Scan something!'");
    } else if (values.isEmpty) {
      print("No display value");
    } else {
      checkWorkpermit(values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Expanded(child: qrScannerWidget())],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: AppConfig.PROFILE_INDEX,
        onItemTapped: (index) {
          setState(() {
            AppConfig.CURRENT_INDEX = index;
          });
        },
      ),
    );
  }

  Widget qrScannerWidget() {
    late final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -100)),
      width: 250,
      height: 250,
    );

    return Stack(
      children: [
        MobileScanner(
          scanWindow: useScanWindow ? scanWindow : null,
          controller: controller,
          errorBuilder: (context, error, child) {
            return ScannerErrorWidget(error: error);
          },
          fit: boxFit,
          onDetect: _onDetect,
        ),
        if (!kIsWeb && useScanWindow)
          ScanWindowOverlay(
            scanWindow: scanWindow,
            controller: controller,
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 200,
            color: const Color.fromRGBO(0, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ToggleFlashlightButton(controller: controller),
                    SwitchCameraButton(controller: controller),
                    AnalyzeImageButton(),
                  ],
                ),
                CustomWidget.verticalSpacing(),
                ElevatedButton(
                    onPressed: isLoading ? null : saveWorkPermitStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text('Manual Fill',
                        style: CustomStyle.bodyWhiteColor())),
              ],
            ),
          ),
        ),
        if (isLoading) loadingScreen()
      ],
    );
  }

  Widget loadingScreen() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget AnalyzeImageButton() {
    return IconButton(
      color: Colors.white,
      icon: const Icon(Icons.image),
      iconSize: 32,
      onPressed: () => _onPressedImageButton(),
    );
  }

  Future<void> _onPressedImageButton() async {
    isLoading = true;
    setState(() {});

    if (kIsWeb) {
      showErrorDialog('Analyze image is not supported on web');
      return;
    }
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      isLoading = false;
      setState(() {});
      return;
    }

    final barcodes = await controller.analyzeImage(
      image.path,
    );

    if (!context.mounted) {
      return;
    }

    barcodes != null &&
            barcodes.barcodes.isNotEmpty &&
            barcodes.barcodes.firstOrNull != null &&
            barcodes.barcodes.firstOrNull?.displayValue != null
        ? checkWorkpermit(barcodes.barcodes.firstOrNull!.displayValue)
        : showErrorDialog('Your QR code is wrong. Please make clear QR.');
  }

  Future<void> checkWorkpermit(String? barcodeValue) async {
    loginUser.workPermitUrl = barcodeValue;

    await ApplicationRepository().saveWorkpermit(loginUser);

    WorkPermitResponse workpermitResponse = await ApplicationRepository()
        .checkWorkpermit(defaultData.versionId, loginUser);

    if (workpermitResponse.message != "" &&
        !workpermitResponse.message.contains("successfully")) {
      showErrorDialog(workpermitResponse.message);
    } else {
      loginUser.loanFormState = "qr_scan";
      await setLoginUser(loginUser);

      isLoading = false;
      setState(() {});

      RouteService.checkLoginUserData(context);
    }
  }

  void saveWorkPermitStep() async {
    isLoading = true;
    setState(() {});

    final Map<String, dynamic> postBody = {
      'version_id': defaultData.versionId,
      'input_data': "",
    };

    DataResponse saveResponse = await ApplicationRepository()
        .saveLoanApplicationStep(postBody, loginUser, stepName);
    if (saveResponse.response.code != 200) {
      showErrorDialog('Error is occur, please contact admin');
    } else {
      loginUser.loanFormState = stepName;
      await setLoginUser(loginUser);
      isLoading = false;
      setState(() {});

      RouteService.checkLoginUserData(context);
    }
  }

  void showErrorDialog(String errorMessage) {
    CustomWidget.showDialogWithoutStyle(context: context, msg: errorMessage);
    isLoading = false;
    setState(() {});
  }
}
