/// Circular Progress Bar

import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tweak/classes/categories.dart';
import 'package:tweak/utils/color_helper.dart';
import 'package:tweak/utils/constants.dart';
import 'neumorphic_circle.dart';
import 'package:provider/provider.dart';

class CircularProgressBar extends StatefulWidget {
  CircularProgressBar({required this.radius, this.width = 20});

  final double radius;
  final double width;
  Duration time = const Duration(seconds: 0);

  List<Color> gradientColor = [
    kLightBlue,
    ColorHelper.getCounterForwardColor(color: kLightBlue)
  ];

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar> {
  @override
  Widget build(BuildContext context) {
    double progress = 0; // The value for the progressBar
    setState(() {
      widget.time =
          Provider.of<Categories>(context).getCategories['work']!.getTimePassed;
      Provider.of<Categories>(context).saveCategories();
      double temp = widget.time.inSeconds.toDouble();
      if (temp < 86400) {
        if (temp < 0) {
          progress = 0;
        } else {
          progress = temp;
        }
      } else {
        progress = 86400;
      }
    });
    return Stack(
      alignment: Alignment.center,
      children: [
        NeumorphicCircle(
          // Outer Circle
          size: widget.radius,
          shape: NeumorphicShape.concave,
          intensity: 0.9,
        ),
        NeumorphicCircle(
          // Inner Circle
          size: widget.radius,
          shape: NeumorphicShape.convex,
          intensity: 0.3,
          depth: -1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: SizedBox(
            height: widget.radius,
            child: SleekCircularSlider(
              // Circular Progress Bar
              min: 0,
              max: 86400,
              initialValue: progress,
              appearance: CircularSliderAppearance(
                size: 215,
                angleRange: 360,
                startAngle: -90,
                infoProperties: InfoProperties(
                  mainLabelStyle: const TextStyle(color: Colors.transparent),
                ),
                customColors: CustomSliderColors(
                  progressBarColors: widget.gradientColor,
                  trackColor: Colors.transparent,
                ),
                customWidths: CustomSliderWidths(
                  progressBarWidth: 15,
                  trackWidth: 0,
                  handlerSize: 0,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(widget.width),
          child: NeumorphicCircle(
            size: widget.radius - 2 * (widget.width),
            shape: NeumorphicShape.concave,
            intensity: 0.8,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 2 - widget.radius / 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowText(
                (widget.time.inHours > 0
                        ? widget.time.inHours
                        : widget.time.inMinutes % 60)
                    .toString(),
                style: kInfoTextStyle.copyWith(fontSize: 35),
              ),
              GlowText(
                widget.time.inHours > 0 ? 'h' : 'min',
                style: kInfoTextStyle,
              ),
              const SizedBox(width: 5),
              GlowText(
                (widget.time.inHours > 0
                        ? widget.time.inMinutes % 60
                        : widget.time.inSeconds % 60)
                    .toString(),
                style: kInfoTextStyle.copyWith(fontSize: 35),
              ),
              GlowText(
                widget.time.inHours > 0 ? 'min' : 's',
                style: kInfoTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
