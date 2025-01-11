// import 'dart:async';
// import 'package:dotmik_app/api/apiService.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:get/get.dart';
// import 'package:dotmik_app/utils/routes/routes_name.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   int _currentIndex = 0;

//   final List<String> _imagePaths = [
//     'assets/splash/Splash-1.png',
//     'assets/splash/Splash-3.png',
//     'assets/splash/Splash-4.png',
//     'assets/splash/Splash-5.png',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     Future.delayed(Duration(milliseconds: 500), () {
//       if (_currentIndex < _imagePaths.length - 1) {
//         setState(() {
//           _currentIndex++;
//         });
//         _startTimer();
//       } else {
//         _checkNavigation();
//       }
//     });
//   }

//   Future<void> _checkNavigation() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool hasShownIntro = prefs.getBool('hasShownIntro') ?? false;
//     String? token = prefs.getString('token');

//     if (hasShownIntro) {
//     String? authKey = prefs.getString('Authkey');
//     // If either token or authKey is null, redirect to login screen
//     if (token == null || authKey == null) {
//         Get.offNamed(RoutesName.home);
//       } else {
//         Get.offNamed(RoutesName.loginScreen);
//       }
//     } else {
//       Get.offNamed(RoutesName.introscreen);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: AnimatedOpacity(
//           duration: Duration(milliseconds: 1000),
//           opacity: _currentIndex < _imagePaths.length ? 1.0 : 0.0,
//           child: AnimatedSwitcher(
//             duration: Duration(milliseconds: 1000),
//             child: Image.asset(
//               _imagePaths[_currentIndex],
//               key: ValueKey<String>(_imagePaths[_currentIndex]),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:dotmik_app/utils/routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentIndex = 0;

  final List<String> _imagePaths = [
    'assets/splash/Splash-1.png',
    'assets/splash/Splash-3.png',
    'assets/splash/Splash-4.png',
    'assets/splash/Splash-5.png',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (_currentIndex < _imagePaths.length - 1) {
        setState(() {
          _currentIndex++;
        });
        _startTimer();
      } else {
        _checkNavigation();
      }
    });
  }

  Future<void> _checkNavigation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool hasShownIntro = prefs.getBool('hasShownIntro') ?? false;
      String? token = prefs.getString('token');
      String? authKey = prefs.getString('Authkey');

      if (!hasShownIntro) {
        // If the intro screen hasn't been shown, navigate to IntroScreen
        Get.offNamed(RoutesName.introscreen);
      } else if (token == null || authKey == null || token.isEmpty || authKey.isEmpty) {
        Get.offNamed(RoutesName.loginScreen);
      } else {
        Get.offNamed(RoutesName.home);
      }
    } catch (e) {
      Get.offNamed(RoutesName.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 1000),
          opacity: _currentIndex < _imagePaths.length ? 1.0 : 0.0,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 1000),
            child: Image.asset(
              _imagePaths[_currentIndex],
              key: ValueKey<String>(_imagePaths[_currentIndex]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
