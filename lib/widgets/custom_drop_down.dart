import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown({required this.onChanged, required this.items, this.val});

  final void Function(Object?) onChanged;
  List<DropdownMenuItem<String>> items;
  String? val;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: items,
      onChanged: onChanged,
      value: val,
      alignment: Alignment.center,
      underline: Container(),
      dropdownColor: kGrayBG,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    );
  }
}
