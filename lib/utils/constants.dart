import 'package:flutter/material.dart';
import 'package:tweak/utils/color_helper.dart';

// --------------- App Constants ---------------
const Color kBaseColor = kLightBlue;
final Color kDarkBackgroundColor =
    ColorHelper.getCounterDarkColor(color: kLightBlue);
const Color kBGGrayTranslucent = kGrayTranslucent;
const Color kNeumorphicShadowDark = Color(0xFF10121A);
const Color kNeumorphicShadowLight = Color(0xFF3F4766);

// --------------- TextStyle ---------------
const TextStyle kInfoTextStyle =
    TextStyle(fontFamily: 'MohrRounded', color: kBaseColor);
final TextStyle kButtonTextStyle =
    TextStyle(fontFamily: 'MohrRounded', color: kDarkBackgroundColor);

// --------------- Color ---------------
const Color kDarkBlue = Color(0xFF1D202D);
const Color kLightBlue = Color(0xFF72DDFD);
const Color kGreen = Color(0xFF5DFE69);
const Color kYellow = Color(0xFFF8FE5D);
const Color kOrange = Color(0xFFFFB329);
const Color kRed = Color(0xFFFF4646);
const Color kGrayTranslucentBG = Color(0x29C0C0C0);
const Color kGrayTranslucentText = Color(0x8CEAEBED);
const Color kGrayBG = Color(0xFF22242b);
const Color kGray = Color(0xFF707070);
const Color kGrayTranslucent = Color(0x40707070);
const Color kWhite = Color(0xFFEAEBED);

// --------------- Path ---------------
const String kIconsPath = 'assets/icons';
