import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/models/data.dart';

class CustomWidget {
  static Widget loading() {
    return Positioned.fill(
      child: Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            color: CustomStyle.primary_color,
          ),
        ),
      ),
    );
  }

  static Widget textField(
      {required TextEditingController controller,
      required String label,
      bool readOnly = false,
      String? errorText,
      VoidCallback? onTap}) {
    return Column(
      children: [
        TextField(
          readOnly: readOnly,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            errorText: errorText,
          ),
        ),
        verticalSpacing()
      ],
    );
  }

  static Widget phoneTextField(
      {required TextEditingController controller,
      required String label,
      bool readOnly = false,
      String prefixText = '+66',
      String? errorText,
      VoidCallback? onTap}) {
    return Column(
      children: [
        TextField(
          readOnly: readOnly,
          controller: controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            labelText: label,
            prefixText: prefixText,
            border: OutlineInputBorder(),
            errorText: errorText,
          ),
        ),
        verticalSpacing()
      ],
    );
  }

  static Widget numberTextField(
      {required TextEditingController controller,
      required String label,
      bool readOnly = false,
      String? errorText,
      FocusNode? focusNode,
      VoidCallback? onTap}) {
    return Column(
      children: [
        TextField(
          focusNode: focusNode,
          readOnly: readOnly,
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            errorText: errorText,
          ),
        ),
        verticalSpacing()
      ],
    );
  }

  static Widget pinTextField(
      {required TextEditingController controller,
      required String label,
      required bool isObscured,
      String? errorText,
      VoidCallback? onPressed}) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: isObscured,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            errorText: errorText,
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
        verticalSpacing()
      ],
    );
  }

  static Widget datePicker(
      {required BuildContext context,
      required TextEditingController controller,
      required String label,
      required DateTime maxDate,
      required DateTime minDate,
      bool readOnly = false}) {
    return Column(
      children: [
        TextField(
          readOnly: readOnly,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          onTap: () {
            selectDate(context, controller, maxDate, minDate);
          },
        ),
        verticalSpacing()
      ],
    );
  }

  static Widget dropdownButtonDiffValue({
    required String label,
    required Item? selectedValue,
    required List<Item> items,
    String key = "",
    required void Function(Item?) onChanged,
  }) {
    return Column(
      children: [
        DropdownButtonFormField<Item>(
          value: selectedValue,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<Item>>((Item item) {
            return DropdownMenuItem<Item>(
              value: item,
              child: Text(
                item.text?.en ?? '',
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((Item item) {
              return Text(
                item.text?.en ?? '',
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
              );
            }).toList();
          },
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
        ),
        verticalSpacing()
      ],
    );
  }

  static Widget dropdownButtonSameValue<T>({
    required String label,
    required T? selectedValue,
    required List<T> items,
    String key = "",
    required void Function(T?) onChanged,
  }) {
    return Column(
      children: [
        DropdownButtonFormField<T>(
          value: selectedValue,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                value.toString(),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((T value) {
              return Text(
                value.toString(),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
              );
            }).toList();
          },
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
        ),
        verticalSpacing()
      ],
    );
  }

  static Widget elevatedButton(
      {bool? enabled = true,
      bool isLoading = false,
      String? text,
      Icon? icon,
      bool? isSmall = false,
      required void Function() onPressed}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: enabled! && !isLoading! ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomStyle.primary_color,
            minimumSize: isSmall == false ? Size(double.infinity, 50) : Size(120, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Please Wait...',
                        style: CustomStyle.bodyWhiteColor(),
                      ),
                    ],
                  ),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text ?? "",
                        style: CustomStyle.bodyWhiteColor(),
                      ),
                      if (icon != null) ...[
                        horizontalSpacing(),
                        Icon(Icons.image_outlined, color: Colors.white),
                      ]
                    ],
                  ),
                ),
        ),
        if (!isSmall!) verticalSpacing()
      ],
    );
  }

  static Widget checkbox(
      List<Item> selectedDataList, Item data, void Function() onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.0,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity:
                          VisualDensity(horizontal: -4.0, vertical: -4.0),
                      value: selectedDataList.contains(data),
                      onChanged: (bool? value) => onTap,
                    ),
                  ),
                ),
                horizontalSpacing(),
                Expanded(
                  child: Text(data.text!.en),
                ),
              ],
            ),
            verticalSpacing(),
          ],
        ));
  }

  static SizedBox horizontalSpacing() {
    return SizedBox(width: 10);
  }

  static SizedBox verticalSpacing() {
    return SizedBox(height: 20);
  }

  static Future<void> showDialogWithoutStyle({
    required BuildContext context,
    required String msg,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showDialogWithStyle({
    required BuildContext context,
    required List<Map<String, dynamic>> msg,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          content: RichText(
            text: TextSpan(
              children: msg.map((item) {
                return TextSpan(
                  text: item['text'].toString(),
                  style: item['style'] as TextStyle?,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> selectDate(
      BuildContext context,
      TextEditingController controller,
      DateTime maxDate,
      DateTime minDate) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = minDate.isAfter(today) ? minDate : today;
    final initialDate = initial.isAfter(maxDate) ? maxDate : initial;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: maxDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            primaryColor: CustomStyle.primary_color,
            colorScheme: ColorScheme.light(
              primary: CustomStyle.primary_color,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: CustomStyle.primary_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> showConfirmDialog({
    required BuildContext context,
    required String content,
    required VoidCallback onConfirmed,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmed();
              },
            ),
          ],
        );
      },
    );
  }
}
