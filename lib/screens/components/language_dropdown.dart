import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';

class LanguageDropdown extends StatefulWidget {
  final Locale selectedLocale;
  final Function(Locale) onLanguageChanged;

  const LanguageDropdown({super.key,
    required this.selectedLocale,
    required this.onLanguageChanged,
  });

  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  late Locale selectedLocale;

  @override
  void initState() {
    super.initState();
    selectedLocale = widget.selectedLocale;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      alignment: AlignmentDirectional.topEnd,
      value: selectedLocale,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      underline: const SizedBox(),
      dropdownColor: Colors.white,
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          setState(() {
            selectedLocale = newLocale;
          });
          widget.onLanguageChanged(newLocale);
        }
      },
      selectedItemBuilder: (BuildContext context) {
        return _buildItems().map((item) => item.child!).toList();
      },
      items: _buildItems(),
    );
  }

  List<DropdownMenuItem<Locale>> _buildItems() {
    return [
      DropdownMenuItem(
        value: const Locale('my'),
        child: _dropdownItem('Myanmar', 'assets/images/my.png'),
      ),
      DropdownMenuItem(
        value: const Locale('en'),
        child: _dropdownItem('English', 'assets/images/en.png'),
      ),
      DropdownMenuItem(
        value: const Locale('th'),
        child: _dropdownItem('Thai', 'assets/images/th.png'),
      ),
    ];
  }

  Widget _dropdownItem(String title, String assetPath) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            assetPath,
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: CustomStyle.body()),
      ],
    );
  }
}
