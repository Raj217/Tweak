/// Pick time

import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:tweak/utils/constants.dart';

class EditableTime extends StatelessWidget {
  EditableTime(
      {required this.text,
      required this.timeVal,
      required this.onChange,
      required this.onChangeDateTime});

  final String text;
  final DateTime timeVal;
  final void Function(TimeOfDay) onChange;
  final void Function(DateTime) onChangeDateTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          showPicker(
              accentColor: kBaseColor,
              okStyle: const TextStyle(
                  fontFamily: 'MohrRounded', fontWeight: FontWeight.bold),
              cancelStyle: const TextStyle(
                  fontFamily: 'MohrRounded', fontWeight: FontWeight.bold),
              iosStylePicker: true,
              value: TimeOfDay(hour: timeVal.hour, minute: timeVal.minute),
              onChange: onChange,
              onChangeDateTime: onChangeDateTime),
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
