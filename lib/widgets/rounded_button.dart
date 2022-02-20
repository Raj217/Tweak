import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {required this.text, required this.onPressed, this.textStyle});

  final String text;
  final TextStyle? textStyle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: kLightBlue,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: Colors.transparent,
            gradient: const LinearGradient(
              colors: [kLightBlue, kViolet],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [kLightBlue, kViolet]),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextButton(
              child: Text(
                text,
                style: textStyle ?? kButtonTextStyle.copyWith(fontSize: 20),
              ),
              onPressed: onPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
