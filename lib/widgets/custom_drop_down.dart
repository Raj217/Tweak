import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({required this.onChanged});

  final void Function(Object?) onChanged;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String val = 'work';
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(
        child: Text(
          'work',
          style: kInfoTextStyle.copyWith(color: kWhite),
        ),
        value: 'work',
        onTap: () => val = 'work',
      ),
      DropdownMenuItem(
        child: Text(
          'sleep',
          style: kInfoTextStyle.copyWith(color: kWhite),
        ),
        value: 'sleep',
        onTap: () => val = 'sleep',
      ),
      DropdownMenuItem(
        child: Text(
          'rest',
          style: kInfoTextStyle.copyWith(color: kWhite),
        ),
        value: 'rest',
        onTap: () => val = 'rest',
      ),
    ];

    return DropdownButton(
      items: items,
      onChanged: widget.onChanged,
      value: val,
      underline: Container(),
      dropdownColor: kGrayBG,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    );
  }
}
