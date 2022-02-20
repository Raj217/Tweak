import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, this.onChanged}) : super(key: key);

  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: kGrayTranslucentBG,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextField(
        textAlign: TextAlign.center,
        autofocus: true,
        cursorColor: kGrayTranslucentText,
        onChanged: onChanged,
        style: kInfoTextStyle.copyWith(color: kGrayTranslucentText),
        decoration: const InputDecoration(
          hintText: 'Task name...',
          hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
