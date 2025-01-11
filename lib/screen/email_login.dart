import 'package:dotmik_app/screen/login_screen.dart';
import 'package:dotmik_app/screen/otp_screen.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_styles.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    bool _isButtonPressed = false;
    final isDarkMode = brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(),
          child: Column(children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  left: screenWidth * 0.4,
                  top: -screenHeight * 0.3,
                  right: -screenWidth * 0.8,
                  child: Container(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.5,
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100000),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.10, bottom: screenHeight * 0.05),
                  child: Center(
                    child: Container(
                      margin:
                          EdgeInsetsDirectional.only(start: screenWidth * 0.05),
                      height: screenHeight * 0.3,
                      width: screenHeight * 0.3,
                      child: Image.asset(
                        'assets/intro/emailshow.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 10),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : AppColors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  )),
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Text(
                                      'Hi Welcome !',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poller One',
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 20, bottom: 12, top: 12),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Email Id',
                                      hintStyle: Styles.textStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
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
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _isButtonPressed = !_isButtonPressed;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OtpScreen(),
                                        ),
                                      );
                                    },
                                    height: 50,
                                    color: _isButtonPressed
                                        ? Colors.grey
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SEND OTP",
                                        style: TextStyle(
                                          color: _isButtonPressed
                                              ? Colors.black
                                              : Colors.white,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 158,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        color: Color(0xFFD6D6D6),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Or',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 158,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        color: Color(0xFFD6D6D6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            MaterialButton(
                              onPressed: () {
                                String phone = _mobileController.text.trim();
                              },
                              height: 50,
                              color: AppColors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: Colors.white), // Border color
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Container(
                                      width: 30,
                                      height: 28,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Icon(Icons.phone_android_outlined,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Center(
                                    child: Text(
                                      "Continue with Mobile Number",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40), // Added spacing
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Adjusted alignment
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: Color(0xFFFFD96E),
                                      fontSize: 19,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
