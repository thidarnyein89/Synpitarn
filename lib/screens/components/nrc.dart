import 'package:flutter/material.dart';
import 'package:synpitarn/screens/components/custom_widget.dart';
import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/models/nrc.dart';
import 'package:synpitarn/l10n/app_localizations.dart';

class NRCPage extends StatefulWidget {
  String nrcValue;

  NRCPage({super.key, required this.nrcValue});

  @override
  NRCState createState() => NRCState();
}

class NRCState extends State<NRCPage> {
  final CommonService _commonService = CommonService();

  final TextEditingController nrcController = TextEditingController();
  final FocusNode _nrcFocusNode = FocusNode();

  List<NRC> nrcList = [];
  List<Township> townshipList = [];
  List<String> citizenList = ["N", "P", "E", "C"];

  String? selectedState;
  String? selectedTownship;
  String? selectedCitizen;

  bool isNRCValidate = false;

  @override
  void initState() {
    super.initState();
    setOldNRCValue();
    readNRCData();
    nrcController.addListener(_validateNRCValue);
    setState(() {});
  }

  @override
  void dispose() {
    _nrcFocusNode.dispose();
    nrcController.dispose();
    super.dispose();
  }

  Future<void> readNRCData() async {
    nrcList = await _commonService.readNRCData();
    setState(() {});
    setTownshipData();
  }

  void setTownshipData() {
    if (selectedState != "") {
      selectedTownship =
          widget.nrcValue != "" && widget.nrcValue.startsWith("$selectedState/")
              ? selectedTownship
              : null;
      setState(() {});

      townshipList =
          nrcList
              .where((nrc) => nrc.state == selectedState)
              .expand((nrc) => nrc.townshipList)
              .toList();
      townshipList.sort((a, b) => a.name.compareTo(b.name));

      setState(() {});
    }
  }

  void setOldNRCValue() {
    RegExp regExp = RegExp(r'(\d+)/(.*)\((\w)\)(\d+)');
    Match? match = regExp.firstMatch(widget.nrcValue);

    if (match != null) {
      selectedState = match.group(1)!;
      selectedTownship = match.group(2)!;
      selectedCitizen = match.group(3)!;
      nrcController.text = match.group(4)!;

      _validateNRCValue();
    }

    setState(() {});
  }

  void _validateNRCValue() {
    setState(() {
      isNRCValidate =
          nrcController.text.isNotEmpty && nrcController.text.length == 6;
    });
  }

  void handleNRC() {
    String nrcValue =
        "$selectedState/$selectedTownship($selectedCitizen)${nrcController.text}";
    Navigator.of(context).pop(nrcValue);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomWidget.dropdownButtonSameValue(
                label: AppLocalizations.of(context)!.state,
                selectedValue: selectedState,
                items: nrcList.map((nrc) => nrc.state).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedState = value.toString();
                    setTownshipData();
                  });
                },
              ),
              CustomWidget.dropdownButtonSameValue(
                label: AppLocalizations.of(context)!.township,
                selectedValue: selectedTownship,
                items: townshipList.map((township) => township.name).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTownship = value.toString();
                  });
                },
              ),
              CustomWidget.dropdownButtonSameValue(
                label: AppLocalizations.of(context)!.citizen,
                selectedValue: selectedCitizen,
                items: citizenList,
                onChanged: (value) {
                  setState(() {
                    selectedCitizen = value.toString();
                  });
                },
              ),
              CustomWidget.numberTextField(
                controller: nrcController,
                label: AppLocalizations.of(context)!.nrcNumber,
                focusNode: _nrcFocusNode,
              ),
              CustomWidget.elevatedButton(
                context: context,
                enabled:
                    selectedState != null &&
                    selectedTownship != null &&
                    selectedCitizen != null &&
                    (isNRCValidate),
                isLoading: false,
                text: AppLocalizations.of(context)!.continueText,
                onPressed: handleNRC,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
