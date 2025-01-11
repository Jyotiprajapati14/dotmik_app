import 'dart:async';
import 'package:dotmik_app/screen/home/reset_pin_screen.dart';
import 'package:dotmik_app/screen/profileScreen/commissionScreen.dart';
import 'package:dotmik_app/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotmik_app/api/profileService.dart';
import 'package:dotmik_app/screen/profileScreen/profile_screen.dart';
import 'package:dotmik_app/screen/refer_screen.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final Profileservice _profileService = Profileservice();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _kycData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await _profileService.fetchUserData(context);

      // Print response for debugging
      print('API Response: $response');

      setState(() {
        _userData = response['data']['userProfile']['userData'];
        _kycData = response['data']['userProfile']['kycData'];
        _isLoading = false;
      });
    } catch (e) {
      // Print error for debugging
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
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

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black87,
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: <Widget>[
              Container(
                height: screenHeight * 0.20,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(_userData?['profile'] ??
                                        'assets/intro/image 128.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _userData?['name'] ?? '',
                                    style: TextStyle(
                                      color: Color(0xFFC63F3F),
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Opacity(
                                    opacity: 0.80,
                                    child: Text(
                                      'Retailer',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                              CustomEditButton(
                                BorderRadius: BorderRadius.circular(12),
                                color: Colors.red,
                                text: 'Edit Profile',
                                imagePath: 'assets/intro/chevron-right.png',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        userDataFuture: Future.value(_userData),
                                        kycDataFuture: Future.value(_kycData),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 70,
                        left: 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Wallet Balance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                _userData?['wallet'] ?? '0.00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Padding(
                  padding: EdgeInsets.only(left: 35, right: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Overview',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.key_outlined,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResetScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Pin Change',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_add_alt_1_outlined,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReferScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Refer And Earn',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_add_alt_1_outlined,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommissionScreen()));
                                  },
                                  child: Text(
                                    'Commission',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Support & About',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.question_answer_rounded,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    const url =
                                        'https://b2b.shantipe.com/about';
                                    final Uri uri = Uri.parse(url);
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                      
                                  },
                                  child: Text(
                                    'About Dotmik',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.contact_support_outlined,
                                  color: Colors.red,
                                  size: 23,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    const String url =
                                        'https://b2b.shantipe.com/contact';
                                    final Uri uri = Uri.parse(url);
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  child: Text(
                                    'Contact Support',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        GestureDetector(
                          onTap: () => logout(context),
                          child: Column(children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout_outlined,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ]),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
  }
}
