import 'package:dotmik_app/screen/introductionScreen/intro_content.dart';
import 'package:dotmik_app/screen/introductionScreen/introduction_screen.dart';
import 'package:dotmik_app/screen/start_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Welcome to',
      subTitle: 'Dotmik!',
      detail: 'Browse the menu and order directly from the application',
      imageUrl: 'assets/intro/intro1.png',
    ),
    Introduction(
      title: 'Great B2b',
      subTitle: 'Experience',
      detail: 'Your order will be immediately collected and',
      imageUrl: 'assets/intro/intro2.png',
    ),
    Introduction(
      title: 'Send Money ',
      subTitle: 'anytime,& anywhere',
      detail: 'Pick up delivery at your door and enjoy groceries',
      imageUrl: 'assets/intro/intro3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartScreen(),
          ),
        );
      },
    );
  }
}
