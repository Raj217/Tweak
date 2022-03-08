/// Logo and app name

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'app_icons.dart';
import 'package:tweak/utils/constants.dart';

Row logoAndAppName(
    {double? iconSize, double spaceBetween = 6, double? fontSize}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      GlowIcon(
        MyFlutterApp.logo,
        color: kBaseColor,
        glowColor: kBaseColor,
        size: iconSize,
      ),
      SizedBox(
        width: spaceBetween,
      ),
      GlowText(
        'TWEAK',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: kBaseColor,
            fontFamily: 'Nomark',
            fontSize: fontSize,
            decoration: TextDecoration.none),
      ),
    ],
  );
}
