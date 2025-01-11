import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isNextButton;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.isNextButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 54,
        decoration: isNextButton
            ? BoxDecoration(
                color: Color(0xFFC63F3F),
                borderRadius: BorderRadius.circular(48),
              )
            : ShapeDecoration(
                color: Colors.black,
                shape: CircleBorder(),
              ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isNextButton)
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ),
              ),
            if (isNextButton)
              Padding(
                padding: EdgeInsets.only(left: 20, right: 8),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (isNextButton) // Image to the right of next button
              Padding(
                padding: EdgeInsets.only(left: 8, right: 20),
                child: Image.asset(
                  "assets/intro/chevron-right.png",
                  width: 24,
                  height: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomNormalButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const CustomNormalButton(
      {Key? key, required this.buttonText, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 214,
        height: 50,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0xFFC63F3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BigCustomButton extends StatelessWidget {
  final String title;

  const BigCustomButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.06,
      decoration: BoxDecoration(
        color: Color(0xFFC63F3F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenHeight * 0.025,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class CustomImageButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onPressed;
  final Color color;

  const CustomImageButton({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height * 0.8;

    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        width: screenWidth * 0.38,
        height: screenHeight * 0.075,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomEditButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onPressed;
  final Color color;
  final dynamic BorderRadius;

  const CustomEditButton({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.onPressed,
    required this.color,
    required this.BorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height * 0.8;

    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        width: screenWidth * 0.25,
        height: screenHeight * 0.050,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.028,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: screenWidth * 0.03,
              height: screenWidth * 0.03,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final dynamic BorderRadius;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.BorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height * 0.8;

    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        width: screenWidth,
        height: screenHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomActionTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final dynamic BorderRadius;

  const CustomActionTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.BorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height * 0.8;

    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        width: screenWidth * 0.20,
        height: screenHeight * 0.050,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black26,
            ),
            borderRadius: BorderRadius),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: screenWidth * 0.024,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomActionTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Color borderColor;
  final BorderRadiusGeometry borderRadius;

  const CustomActionTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.borderColor = Colors.black26,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
     final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.40,
      height: screenHeight * 0.05, // Adjusted for better screen utilization
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1.5, // Thicker border for better visibility
        ),
        borderRadius: borderRadius,
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number, // Ensures numeric keyboard
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10), // Restrict input to 10 digits
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: screenWidth * 0.04, // Responsive font size
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}


class CustomSmallTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final dynamic BorderRadius;

  const CustomSmallTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.BorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.95;
    final screenHeight = MediaQuery.of(context).size.height * 0.95;

    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        width: screenWidth * 0.15,
        height: screenHeight * 0.050,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.024,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
