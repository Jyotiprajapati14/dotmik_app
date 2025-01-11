import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color upperColor;
  final Color lowerColor;

  GradientText({
    required this.text,
    required this.textStyle,
    required this.upperColor,
    required this.lowerColor,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [upperColor, lowerColor],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
