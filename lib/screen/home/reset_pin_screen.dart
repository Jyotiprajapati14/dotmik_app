import 'dart:async';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
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
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 4,
        leading: GestureDetector(
          onTap: () {},
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                'assets/intro/back.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Change Pin',
            style: TextStyle(
              color: Color(0xFF23303B),
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/intro/bell.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: screenHeight,
          width: screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              Text(
                'Enter Old Pin',
                style: TextStyle(
                  color: Color(0xFF23303B),
                  fontSize: 19,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              buildPinInputRow(),
              SizedBox(height: 20),
              Text(
                'Enter New Pin',
                style: TextStyle(
                  color: Color(0xFF23303B),
                  fontSize: 19,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              buildPinInputRow(),
              SizedBox(height: 20),
              Text(
                'Enter Confirm Pin',
                style: TextStyle(
                  color: Color(0xFF23303B),
                  fontSize: 19,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              buildPinInputRow(),
              SizedBox(height: 40),
              Center(
                  child: CustomNormalButton(
                buttonText: 'Save Changes',
                onTap: () {},
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPinInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (index) => Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Focus on the next field or unfocus if it's the last one
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
