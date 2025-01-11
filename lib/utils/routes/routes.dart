import 'dart:convert';

import 'package:dotmik_app/screen/home/home_bottombar_screen.dart';
import 'package:dotmik_app/screen/introductionScreen/intro_screen.dart';
import 'package:dotmik_app/screen/login_screen.dart';
import 'package:dotmik_app/screen/otp_screen.dart';
import 'package:dotmik_app/screen/splash_screen.dart';
import 'package:dotmik_app/utils/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routes {
  static List<GetPage> _pages = [];

  // Method to initialize routes and set pages
  static Future<void> initializeRoutes() async {
    // Fetch shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? responseBody = prefs.getString('responseData');

    // Decode or process responseBody to get the necessary data
    var data = responseBody != null ? json.decode(responseBody) : null;

    // Define the pages with data if available
    _pages = [
      GetPage(name: RoutesName.splash, page: () => SplashScreen()),
      GetPage(name: RoutesName.introscreen, page: () => IntroScreen()),
      GetPage(name: RoutesName.otpScreen, page:() => OtpScreen()),
       GetPage(name: RoutesName.loginScreen, page:() => LoginScreen()),
      GetPage(
        name: RoutesName.home,
        page: () => HomeBottomNavBar(),
      ),
    ];
  }

  // Getter for the pages
  static List<GetPage> get pages => _pages;
}
