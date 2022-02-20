import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:tweak/utils/constants.dart';

class EditableTime extends StatelessWidget {
  EditableTime(
      {required this.text, required this.timeVal, required this.onChange});

  final String text;
  final TimeOfDay timeVal;
  final void Function(TimeOfDay) onChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          showPicker(
              accentColor: kLightBlue,
              okStyle: TextStyle(
                  fontFamily: 'MohrRounded', fontWeight: FontWeight.bold),
              cancelStyle: TextStyle(
                  fontFamily: 'MohrRounded', fontWeight: FontWeight.bold),
              iosStylePicker: true,
              value: timeVal,
              onChange: onChange),
        );
      },
      child: Text(
        text,
        style:
            kInfoTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.w700),
      ),
    );
  }
}
