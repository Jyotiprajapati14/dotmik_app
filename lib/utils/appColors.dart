import 'package:flutter/material.dart';

class AppColors {
  static const Color red =  Color(0xFFCE3232);
  static final LinearGradient primaryBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromARGB(255, 200, 223, 243), Color.fromARGB(255, 141, 200, 243)],
  );
  // static const Color primaryBackgroundColor = Colors.white;
  static const Color buttonColor = Color.fromARGB(255, 96, 127, 251);
  static const Color textColor = Colors.black;
  // Define more colors as needed
}