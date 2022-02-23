import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.onChanged,
      this.hintText,
      this.maxLines = 1,
      this.verticalPadding = 10,
      this.initVal})
      : super(key: key);

  final void Function(String)? onChanged;
  final String? hintText;
  final int maxLines;
  final double verticalPadding;
  final String? initVal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: kGrayTranslucentBG,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 15.0, vertical: verticalPadding),
        child: TextFormField(
          initialValue: initVal,
          textAlign: TextAlign.center,
          autofocus: true,
          cursorColor: kGrayTranslucentText,
          onChanged: onChanged,
          maxLines: maxLines,
          style: kInfoTextStyle.copyWith(color: kWhite),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }
}
