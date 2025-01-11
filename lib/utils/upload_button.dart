import 'dart:io';
import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  final String buttonText;

  const UploadButton({Key? key, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 122.24,
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 11,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 70.15,
            height: 21,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'Upload +',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Utils {
  static Widget buildUploadContainer(
    String text,
    File? imageFile,
    VoidCallback onTap,
    double height,
    double width,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: imageFile == null
            ? UploadButton(buttonText: text)
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}