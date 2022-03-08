import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:tweak/utils/color_helper.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({required this.text, required this.onPressed, this.textStyle});

  final String text;
  final TextStyle? textStyle;
  final void Function()? onPressed;

  // Constant values for widgets
  final double height = 60;
  final double borderWidth = 2;
  final Color borderColor = kBaseColor;
  final List<Color> gradientColors = [
    kBaseColor,
    ColorHelper.getCounterForwardColor(color: kBaseColor)
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          // Outer border
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              width: borderWidth,
              color: borderColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(25)),
          ),
        ),
        Padding(
          // The inner button
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
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
