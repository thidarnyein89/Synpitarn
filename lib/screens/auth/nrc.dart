import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/custom_widget.dart';

import 'package:synpitarn/services/common_service.dart';
import 'package:synpitarn/models/nrc.dart';

class NRCPage extends StatefulWidget {
  String nrcValue;

  NRCPage({super.key, required this.nrcValue});

  @override
  NRCState createState() => NRCState();
}

class NRCState extends State<NRCPage> {
  final CommonService _commonService = CommonService();

  final TextEditingController nrcController = TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedState,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedState = newValue!;
                      setTownshipData();
                    });
                  },
                  items:
                      nrcList.map<DropdownMenuItem<String>>((NRC nrc) {
                        return DropdownMenuItem<String>(
                          value: nrc.state,
                          child: Text(nrc.state),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: '',
                    border: OutlineInputBorder(),
                  ),
                  hint: Text('State', style: TextStyle(color: Colors.black87)),
                ),
                CustomWidget.verticalSpacing(),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedTownship,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTownship = newValue!;
                    });
                  },
                  items:
                      townshipList.map<DropdownMenuItem<String>>((
                        Township township,
                      ) {
                        return DropdownMenuItem<String>(
                          value: township.name,
                          child: Text(
                            township.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: '',
                    border: OutlineInputBorder(),
                  ),
                  hint: Text(
                    'Township',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                CustomWidget.verticalSpacing(),
                DropdownButtonFormField<String>(
                  value: selectedCitizen,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCitizen = newValue!;
                    });
                  },
                  items:
                      citizenList.map<DropdownMenuItem<String>>((
                        String citizen,
                      ) {
                        return DropdownMenuItem<String>(
                          value: citizen,
                          child: Text(citizen),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: '',
                    border: OutlineInputBorder(),
                  ),
                  hint: Text(
                    'Citizen',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                CustomWidget.verticalSpacing(),
                TextField(
                  controller: nrcController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    labelText: 'NRC Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                CustomWidget.verticalSpacing(),
                ElevatedButton(
                  onPressed:
                      selectedState != null &&
                              selectedTownship != null &&
                              selectedCitizen != null &&
                              (isNRCValidate)
                          ? handleNRC
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomStyle.primary_color,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Continue', style: CustomStyle.bodyWhiteColor()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
