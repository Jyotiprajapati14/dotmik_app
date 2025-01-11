import 'dart:async';

import 'package:dotmik_app/screen/login_screen.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:flutter/material.dart';

class CompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image in the center
            Image.asset(
              'assets/intro/congrats-girl.png',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 40), // Spacer
            // Tick icon
            Icon(
              Icons.check_circle,
              color: AppColors.red,
              size: 70,
            ),
            SizedBox(height: 40), // Spacer
            // Text line
            Text(
              'Sign Up has successfully done',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
