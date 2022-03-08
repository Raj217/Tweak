import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tweak/utils/constants.dart';

class NeumorphicCircle extends StatelessWidget {
  const NeumorphicCircle({
    required this.size,
    required this.shape,
    this.depth,
    this.intensity,
  });

  final double size;
  final NeumorphicShape shape;
  final double? depth;
  final double? intensity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: shape,
          color: kDarkBackgroundColor,
          shadowDarkColor: kNeumorphicShadowDark,
          shadowLightColor: kNeumorphicShadowLight,
          boxShape: const NeumorphicBoxShape.circle(),
          depth: depth,
          intensity: intensity,
        ),
      ),
    );
  }
}
