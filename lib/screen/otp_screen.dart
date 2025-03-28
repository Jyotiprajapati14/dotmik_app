import 'dart:async';
import 'package:dotmik_app/api/apiService.dart';
import 'package:dotmik_app/utils/notifiesClass/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final ApiService apiService = ApiService();
  late Timer _timer;
  int _start = 60;
  TextEditingController _otpController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _start = 60; // Reset the timer
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    // Prevent navigating back
    return false;
  }

  void _handleResend() {
    // Restart the timer and reset OTP field
    startTimer();
    _otpController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP has been resent')),
    );
    // Implement OTP resend functionality if needed
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(),
            child: Column(
              children: <Widget>[
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
                          top: screenHeight * 0.12,
                          bottom: screenHeight * 0.05),
                      child: Center(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                              start: screenWidth * 0.05),
                          height: screenHeight * 0.3,
                          width: screenHeight * 0.3,
                          child: Image.asset(
                            'assets/intro/cuate (1).png',
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
                        color: isDarkMode ? Colors.grey[900] : Colors.red,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 7, bottom: 7, left: 10),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'OTP Verification\n',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'A 6-digit code has been sent to your number',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '00:$_start',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          PinCodeTextField(
                            controller: _otpController,
                            appContext: context,
                            pastedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            obscureText: false,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12),
                              fieldHeight: 45,
                              fieldWidth: 40,
                              activeColor: Colors.black,
                              inactiveColor: Colors.black,
                              selectedColor: Colors.black,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                            ),
                            cursorColor: Colors.black,
                            cursorHeight: 10,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            keyboardType: TextInputType.number,
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onChanged: (value) {
                              // Handle OTP change if needed
                            },
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              MaterialButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : (
                                    ) async {
                                        setState(() {
                                          _isSubmitting = true;
                                        });
                                        String otpCode = _otpController.text;
                                        if (otpCode.length == 6) {

                                          await apiService.logInOtp(
                                            otpCode,
                                            context,

                                          );
                                        }
                                        else {
                                          NotifierUtils.showSnackBar(context,
                                              'Please enter the complete OTP');
                                        }
                                        setState(() {
                                          _isSubmitting = true;
                                        });
                                      },
                                height: 50,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: _isSubmitting
                                      ? null
                                      : const Text(
                                          "Verify",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Open Sans',
                                            fontSize: 18,
                                          ),
                                        ),
                                ),
                              ),
                              if (_isSubmitting)
                                const Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "If you don't receive a code! ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Open Sans',
                                ),
                              ),
                              GestureDetector(
                                onTap: _handleResend,
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: Color(0xFFFFD96E),
                                    fontSize: 19,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Row(
                            children: [
                              Container(
                                width: screenWidth * 0.3,
                                decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              Text(
                                'Or',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: screenWidth * 0.045,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              Container(
                                width: screenWidth * 0.3,
                                decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "If you want Login Again! ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Open Sans',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login_screen');
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xFFFFD96E),
                                    fontSize: 19,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
