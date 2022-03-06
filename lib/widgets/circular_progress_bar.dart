import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tweak/classes/categories.dart';
import 'package:tweak/utils/constants.dart';
import 'neumorphic_circle.dart';
import 'package:provider/provider.dart';

class CircularProgressBar extends StatefulWidget {
  CircularProgressBar({required this.radius, this.width = 20});

  final double radius;
  final double width;
  Duration time = Duration(seconds: 0);

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar> {
  @override
  Widget build(BuildContext context) {
    // Category workData = Provider.of<Categories>(context).getCategories['work']!;
    // widget.time = workData.getTimePassed;
    setState(() {
      widget.time =
          Provider.of<Categories>(context).getCategories['work']!.getTimePassed;
      Provider.of<Categories>(context).saveCategories();
    });
    return Stack(
      alignment: Alignment.center,
      children: [
        NeumorphicCircle(
          size: widget.radius,
          shape: NeumorphicShape.concave,
          intensity: 0.9,
        ),
        NeumorphicCircle(
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
              min: 0,
              max: 86400,
              initialValue: widget.time.inSeconds.toDouble(),
              appearance: CircularSliderAppearance(
                size: 215,
                angleRange: 360,
                startAngle: -90,
                infoProperties: InfoProperties(
                  mainLabelStyle: const TextStyle(color: Colors.transparent),
                ),
                customColors: CustomSliderColors(
                  progressBarColors: [kLightBlue, kViolet],
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
