import 'dart:async';
import 'dart:ui' as ui;
import 'package:dotmik_app/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:dotmik_app/utils/navigation_router.dart';
import 'package:dotmik_app/screen/login_screen.dart';
import 'package:dotmik_app/utils/textstyles/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<StartScreen> {
  bool _isOn = false;
  double _position = 0.0;
  double _dragStartX = 0.0;
  bool _isForward = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () => NavigationRouter.switchToIntro(context));
  }

  @override
  Widget build(BuildContext context) {
    final Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = systemBrightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? Colors.black87 : Colors.white;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return ui.Gradient.linear(
                    Offset(0, bounds.top),
                    Offset(0, bounds.bottom),
                    [Colors.black, AppColors.red],
                  );
                },
                child: Text(
                  "Let's get",
                  textAlign: TextAlign.start,
                  style: IntroductionUtils.getTitleTextStyle(context),
                ),
              ),
              Text(
                "Started 😀",
                textAlign: TextAlign.start,
                style: IntroductionUtils.getSubTitleTextStyle(context),
              ),
              SizedBox(
                width: screenWidth * 0.7,
                child: Text(
                  "Browse the menu and order directly from the application",
                  textAlign: TextAlign.start,
                  style: IntroductionUtils.getDetailTextStyle(context),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.5,
                width: screenWidth * 0.8,
                child: Center(
                  child: Image(
                    image: const AssetImage("assets/intro/intro4.png"),
                    height: screenHeight * 0.32,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    _dragStartX = details.localPosition.dx;
                  },
                  onHorizontalDragUpdate: (details) {
                    final delta = details.localPosition.dx - _dragStartX;
                    final containerWidth = screenWidth * 0.6;
                    final maxPosition = containerWidth - 61;

                    setState(() {
                      _position = (_position + delta).clamp(0.0, maxPosition);
                      _dragStartX = details.localPosition.dx;
                      _isForward = _position >= maxPosition;
                    });
                  },
                  onHorizontalDragEnd: (details) async {
                    if (_isForward){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('hasShownIntro', true);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.07,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(-0.99, -0.17),
                        end: Alignment(0.99, 0.17),
                        colors: [
                          AppColors.red,
                          ui.Color.fromARGB(255, 234, 116, 116),
                          Color(0xFFC63F3F),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: _position,
                          child: Container(
                            width: 61,
                            height: screenHeight * 0.07,
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Image.asset("assets/intro/chevron-right.png"),
                          ),
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
    );
  }
}
