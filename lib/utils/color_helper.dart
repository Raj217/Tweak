import 'dart:math';
import 'package:flutter/material.dart';

class ColorHelper {
  static dynamic getCounterForwardColor({required Color color}) {
    /// Given a color it finds the counter color in forward direction (my lang,
    /// see rounded button for visual example {forward = right })
    List<double> hsv = rgb2hsv(
        r: color.red.toDouble(),
        g: color.green.toDouble(),
        b: color.blue.toDouble());

    // My Algorithm
    hsv[0] += 48;
    hsv[1] += 2;

    // Making the values bounded to the upper limit
    hsv[0] = hsv[0] > 360 ? 360 : hsv[0];
    hsv[1] = hsv[1] > 100 ? 100 : hsv[1];
    hsv[2] = hsv[2] > 100 ? 100 : hsv[2];

    List<double> rgb = hsv2rgb(h: hsv[0], s: hsv[1], v: hsv[2]);

    return Color.fromRGBO(rgb[0].toInt(), rgb[1].toInt(), rgb[2].toInt(), 1);
  }

  static dynamic getCounterDarkColor({required Color color}) {
    /// Given a color it finds the counter dark color
    List<double> hsv = rgb2hsv(
        r: color.red.toDouble(),
        g: color.green.toDouble(),
        b: color.blue.toDouble());

    // My Algorithm
    hsv[0] += 35;
    hsv[1] -= 19;
    hsv[2] -= 81;

    // Making the values bounded to the upper limit
    hsv[0] = hsv[0] > 360 ? 360 : hsv[0];
    hsv[1] = hsv[1] > 100 ? 100 : hsv[1];
    hsv[2] = hsv[2] > 100 ? 100 : hsv[2];

    // Negative values
    hsv[0] = hsv[0] < 0 ? 0 : hsv[0];
    hsv[1] = hsv[1] < 0 ? 0 : hsv[1];
    hsv[2] = hsv[2] < 0 ? 0 : hsv[2];

    List<double> rgb = hsv2rgb(h: hsv[0], s: hsv[1], v: hsv[2]);

    return Color.fromRGBO(rgb[0].toInt(), rgb[1].toInt(), rgb[2].toInt(), 1);
  }

  static List<double> rgb2hsv(
      {required double r, required double g, required double b}) {
    r = r / 255;
    g = g / 255;
    b = b / 255;

    double cMax = _max(r, _max(g, b));
    double cMin = _min(r, _min(g, b));
    double diff = cMax - cMin;

    double value = cMax * 100;
    double saturation = cMax != 0 ? (diff / cMax) * 100 : 0;
    double hue = -1;

    if (cMax == cMin) {
      hue = 0;
    } else if (cMax == r) {
      hue = (60 * ((g - b) / diff) + 360) % 360;
    } else if (cMax == g) {
      hue = (60 * ((b - r) / diff) + 120) % 360;
    } else {
      hue = (60 * ((r - g) / diff) + 240) % 360;
    }

    return [hue, saturation, value];
  }

  static List<double> hsv2rgb(
      {required double h, required double s, required double v}) {
    s /= 100;
    v /= 100;

    double c = v * s;
    double x = c * (1 - _abs(((h / 60) % 2) - 1));
    double m = v - c;

    List<double> rgb_;

    if (0 <= h && h <= 60) {
      rgb_ = [c, x, 0];
    } else if (60 <= h && h <= 120) {
      rgb_ = [x, c, 0];
    } else if (120 <= h && h <= 180) {
      rgb_ = [0, c, x];
    } else if (180 <= h && h <= 240) {
      rgb_ = [0, x, c];
    } else if (240 <= h && h <= 300) {
      rgb_ = [x, 0, c];
    } else {
      rgb_ = [c, 0, x];
    }

    double r = (rgb_[0] + m) * 255;
    double g = (rgb_[1] + m) * 255;
    double b = (rgb_[2] + m) * 255;

    return [r, g, b];
  }

  static double _max(double a, double b) {
    return a > b ? a : b;
  }

  static double _min(double a, double b) {
    return a > b ? b : a;
  }

  static double _abs(double val) {
    return val >= 0 ? val : -val;
  }
}
