import 'package:flutter/material.dart';

class IntroductionUtils {
  
  static TextStyle getTitleTextStyle(BuildContext context) {
    final Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = systemBrightness == Brightness.dark;

    return TextStyle(
      fontSize: 36,
      fontFamily: 'Lexend',
      letterSpacing: 1,
      fontWeight: FontWeight.w700,
      color: isDarkMode ? Colors.white : Colors.black,
    );
  }

  static TextStyle getSubTitleTextStyle(BuildContext context) {
    final Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = systemBrightness == Brightness.dark;

    return TextStyle(
      fontSize: 36,
      letterSpacing: 1,
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w700,
      color:  Color(0xFFC63F3F),
    );
  }

  static TextStyle getDetailTextStyle(BuildContext context) {
    final Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = systemBrightness == Brightness.dark;

    return TextStyle(
      fontSize: 16,
      fontFamily: 'Lexend',
      color: isDarkMode ? Colors.white : Colors.black,
    );
  }
}
