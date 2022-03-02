import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:tweak/classes/tasks_data.dart';
import 'package:tweak/classes/time.dart';

class AlertDialogBox extends StatelessWidget {
  AlertDialogBox({
    Key? key,
    required this.textTitle,
    required this.textContent,
    required this.actions,
    this.textTitleStyle,
    this.textContentStyle,
    this.bgColor,
  }) : super(key: key);

  String textTitle;
  TextStyle? textTitleStyle;
  String textContent;
  TextStyle? textContentStyle;
  Color? bgColor;
  List<TextButton> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: bgColor ?? kGrayBG,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        title: Text(textTitle,
            style: textTitleStyle ?? kInfoTextStyle.copyWith(color: kWhite)),
        content: Text(textContent,
            style: textContentStyle ?? kInfoTextStyle.copyWith(color: kWhite)),
        actions: actions);
  }
}
