import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:tweak/utils/tasks_data.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({required this.onChanged, this.val});

  final void Function(Object?) onChanged;
  String? val;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    widget.val ?? categories.work.toString().substring(11);
    final List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(
        child: Text(
          categories.work.toString().substring(11),
          style: kInfoTextStyle.copyWith(color: kWhite),
        ),
        value: categories.work.toString().substring(11),
        onTap: () {
          widget.val = categories.work.toString().substring(11);
        },
      ),
      DropdownMenuItem(
        child: Text(
          categories.sleep.toString().substring(11),
          style: kInfoTextStyle.copyWith(color: kWhite),
        ),
        value: categories.sleep.toString().substring(11),
        onTap: () {
          widget.val = categories.sleep.toString().substring(11);
        },
      ),
      DropdownMenuItem(
        child: Text(
          categories.rest.toString().substring(11),
          style: kInfoTextStyle.copyWith(color: kWhite),
        ),
        value: categories.rest.toString().substring(11),
        onTap: () {
          widget.val = categories.rest.toString().substring(11);
        },
      ),
      DropdownMenuItem(
        child: Text(
          categories.unregistered.toString().substring(11),
          style: kInfoTextStyle.copyWith(color: kWhite),
        ),
        value: categories.unregistered.toString().substring(11),
        onTap: () {
          widget.val = categories.unregistered.toString().substring(11);
        },
      )
    ];

    return DropdownButton(
      items: items,
      onChanged: widget.onChanged,
      value: widget.val,
      underline: Container(),
      dropdownColor: kGrayBG,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    );
  }
}
