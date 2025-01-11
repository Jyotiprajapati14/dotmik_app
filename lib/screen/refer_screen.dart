import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:share_me/share_me.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({Key? key}) : super(key: key);

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  TextEditingController _dataController = TextEditingController();

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.10, bottom: screenHeight * 0.02),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start: screenWidth * 0.05),
                        height: screenHeight * 0.20,
                        width: screenHeight * 0.25,
                        child: Image.asset(
                          'assets/images/undraw_social_friends_re_7uaa (1) 1.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: Image.asset(
                          'assets/images/Refer & Earn.png',
                          fit: BoxFit.fill,
                          width: screenWidth * 0.6,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.06,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 36,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'refer_dotmik100',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.02,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.copy_all_outlined,
                              color: Colors.white,
                              size: screenHeight * 0.03,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomNormalButton(
                        buttonText: 'HOW IT WORKS',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReferWorkScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoCard(
                            'Your Invites',
                            '(2)',
                            screenHeight,
                            screenWidth,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          _buildInfoCard(
                            'Total Rewards',
                            '₹ 200',
                            screenHeight,
                            screenWidth,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Reward History',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenHeight * 0.025,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildRewardHistoryItem(
                        'Reward From Damilala',
                        'Oct 21',
                        '+200,000',
                        screenHeight,
                        screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      GestureDetector(
                        onTap: () {
                          ShareMe.system(
                            title: '',
                            url: '',
                            description: '',
                            subject: '',
                          );
                        },
                        child: BigCustomButton(
                          title: 'Share to Invite',
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, double screenHeight, double screenWidth) {
    return Container(
      width: screenWidth * 0.35,
      height: screenHeight * 0.1,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF242424),
              fontSize: screenHeight * 0.015,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF242424),
              fontSize: screenHeight * 0.02,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardHistoryItem(String title, String date, String amount,
      double screenHeight, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: screenHeight * 0.04,
          height: screenHeight * 0.04,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: screenHeight * 0.02,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenHeight * 0.02,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenHeight * 0.018,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          amount,
          style: TextStyle(
            color: Color(0xFF34C759),
            fontSize: screenHeight * 0.02,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.50,
          ),
        ),
      ],
    );
  }
}

class ReferWorkScreen extends StatefulWidget {
  const ReferWorkScreen({Key? key}) : super(key: key);

  @override
  State<ReferWorkScreen> createState() => _ReferWorkScreenState();
}

class _ReferWorkScreenState extends State<ReferWorkScreen> {
  TextEditingController _dataController = TextEditingController();

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

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'How it works',
                  style: TextStyle(
                    color: Color(0xFFC63F3F),
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    height: 0,
                    letterSpacing: -0.20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    _buildReferralRow(
                      'Share your referrals',
                      'Invite at least ',
                      '2 new users',
                    ),
                    _buildReferralRow(
                      'Track your progress',
                      'Keep an eye on your ',
                      'referral dashboard',
                    ),
                    _buildReferralRow(
                      'Redeem rewards',
                      'Exchange points for ',
                      'exclusive offers',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 373,
                height: 132,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFC63F3F)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 289,
                      top: 118,
                      child: Container(
                        width: 1,
                        height: 1,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 1,
                              height: 1,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, top: 10, bottom: 10, right: 10),
                      child: Text(
                        'Note:',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFFEB001B),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      top: 33,
                      child: SizedBox(
                        width: 327,
                        height: 86,
                        child: Text(
                          'Ensure your friends register with their details \nWe have a database that confirms the \ninformation provided to enable you to earn.\nAlso the more you share the more you earn. ',
                          style: TextStyle(
                            color: Color(0xFF242424),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildReferralRow(String title, String subtitle1, String subtitle2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Image.asset("assets/images/iconamoon_profile.png"),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF141414),
                  fontSize: 14,
                  fontFamily: 'KoHo',
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: 0.50,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: subtitle1,
                      style: TextStyle(
                        color: Color(0xFF919191),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.50,
                      ),
                    ),
                    TextSpan(
                      text: subtitle2,
                      style: TextStyle(
                        color: Color(0xFF242424),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, double screenHeight, double screenWidth) {
    return Container(
      width: screenWidth * 0.35,
      height: screenHeight * 0.1,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF242424),
              fontSize: screenHeight * 0.015,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF242424),
              fontSize: screenHeight * 0.02,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardHistoryItem(String title, String date, String amount,
      double screenHeight, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: screenHeight * 0.04,
          height: screenHeight * 0.04,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: screenHeight * 0.02,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenHeight * 0.02,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenHeight * 0.018,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          amount,
          style: TextStyle(
            color: Color(0xFF34C759),
            fontSize: screenHeight * 0.02,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.50,
          ),
        ),
      ],
    );
  }
}
