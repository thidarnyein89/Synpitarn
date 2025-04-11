import 'dart:async';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/custom_widget.dart';
import 'package:synpitarn/screens/components/app_bar.dart';
import 'package:synpitarn/screens/components/register_tab_bar.dart';
import 'package:synpitarn/screens/components/scanner_error_widget.dart';
import 'package:synpitarn/screens/components/toggle_flashlight_button.dart';
import 'package:synpitarn/screens/components/scan_window_overlay.dart';
import 'package:synpitarn/data/app_config.dart';
import 'package:synpitarn/screens/components/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:synpitarn/models/user.dart';
import 'package:synpitarn/models/workpermit.dart';
import 'package:synpitarn/repositories/application_repository.dart';
import 'package:synpitarn/screens/profile/information1.dart';
import 'package:synpitarn/screens/components/switch_camera_button.dart';

class WorkPermitPage extends StatefulWidget {
  const WorkPermitPage({super.key});

  @override
  WorkPermitState createState() => WorkPermitState();
}

class WorkPermitState extends State<WorkPermitPage> {
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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
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
        children: [
          Expanded(child: qrScannerWidget())
        ],
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

  void handleNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Information1Page()),
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
                  onPressed: isLoading ? null : handleNext,
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
                  child: Text('Manual Fill', style: CustomStyle.bodyWhiteColor())
                ),
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
    bool isLoggedIn = await getLoginStatus();
    if (isLoggedIn) {
      User loginUser = await getLoginUser();
      loginUser.workPermitUrl = barcodeValue;

      await ApplicationRepository().saveWorkpermit(loginUser);

      Workpermit workpermitResponse =
          await ApplicationRepository().checkWorkpermit(loginUser);

      if (workpermitResponse.message != "" &&
          !workpermitResponse.message.contains("successfully")) {
        showErrorDialog(workpermitResponse.message);
      } else {
        isLoading = false;
        setState(() {});

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Information1Page()),
        );
      }
    }
  }

  void showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Reduce the border radius
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );

    isLoading = false;
    setState(() {});
  }
}
