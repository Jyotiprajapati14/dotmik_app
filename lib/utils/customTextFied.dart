import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.w400,
          color: Colors.grey[600],
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
