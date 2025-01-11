import 'package:dotmik_app/screen/home/home_bottombar_screen.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:dotmik_app/utils/upload_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Use system theme mode
      home: MultiStepForm(),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int stepNumber;
  final String title;
  final bool isActive;
  final bool isCompleted;

  StepIndicator({
    required this.stepNumber,
    required this.title,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.red
                : isActive
                    ? AppColors.red
                    : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              width: 0.80,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      color: isActive ? Colors.white : Color(0xFF6D6D6D),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? AppColors.red : Color(0xFF6D6D6D),
            fontSize: 10,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.30,
          ),
        ),
      ],
    );
  }
}

class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 1;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  void _submitForm() {
    // Navigate to another screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThankYouScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'UPDATE KYC',
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              // Steps Indicator
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StepIndicator(
                      stepNumber: 1,
                      title: 'Personal\nInformation',
                      isActive: _currentStep >= 1,
                      isCompleted: _currentStep > 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 5,
                        color:
                            _currentStep >= 2 ? AppColors.red: Colors.grey,
                      ),
                    ),
                    StepIndicator(
                      stepNumber: 2,
                      title: 'ID\nDetails',
                      isActive: _currentStep >= 2,
                      isCompleted: _currentStep > 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 5,
                        color:
                            _currentStep >= 3 ? AppColors.red: Colors.grey,
                      ),
                    ),
                    StepIndicator(
                      stepNumber: 3,
                      title: 'Outlet\nDetails',
                      isActive: _currentStep >= 3,
                      isCompleted: _currentStep > 3,
                    ),
                  ],
                ),
              ),
              // Form Fields
              Container(
                width: 362,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 10,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step $_currentStep: ${_currentStep == 1 ? "Personal Information" : (_currentStep == 2 ? "ID Details" : "Outlet Details")}',
                      style: TextStyle(
                        color:AppColors.red,
                        fontSize: 18,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_currentStep == 1) ...[
                      Text(
                        'First Name',
                        style: TextStyle(
                          color: Color(0xA51F1F1F),
                          fontFamily: 'Open Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Last Name',
                        style: TextStyle(
                          color: Color(0xA51F1F1F),
                          fontFamily: 'Open Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Address',
                        style: TextStyle(
                          color: Color(0xA51F1F1F),
                          fontFamily: 'Open Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Father's Name",
                        style: TextStyle(
                          color: Color(0xA51F1F1F),
                          fontFamily: 'Open Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter Father Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'DOB',
                            style: TextStyle(
                              color: Color(0xA51F1F1F),
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 137),
                          Text(
                            'Pincode',
                            style: TextStyle(
                              color: Color(0xA51F1F1F),
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Date Of Birth',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Pincode',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'District',
                            style: TextStyle(
                              color: Color(0xA51F1F1F),
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 122),
                          Text(
                            'State',
                            style: TextStyle(
                              color: Color(0xA51F1F1F),
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter District',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter State',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (_currentStep == 2) ...[
                      Text(
                        'Pan Card Number',
                        style: TextStyle(
                          color: Color(0xA51F1F1F),
                          fontFamily: 'Open Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter Pan Card Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 400,
                        // child: Utils.buildUploadContainer(
                        //
                        //
                        //   // 'Upload Pan Card Image',
                        //
                        // ),
                        child: Utils.buildUploadContainer(
                          'Upload Image',
                          null,          // Pass the actual image file
                              () {
                            print("Container tapped!");
                          },
                          200.0,              // height
                          200.0,              // width
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Adhar Card Number',
                        style: TextStyle(
                          color: Color(0xA51F1F1F),
                          fontFamily: 'Open Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter Aadhar Card Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // child: Utils.buildUploadContainer(
                            //   'Upload Aadhar Front Image',
                            // ),
                            child: Utils.buildUploadContainer(
                              'Upload Image',
                              null,          // Pass the actual image file
                                  () {
                                print("Container tapped!");
                              },
                              200.0,              // height
                              200.0,              // width
                            ),
                          ),
                          Container(
                            // child: Utils.buildUploadContainer(
                            //   'Upload Aadhar Back Image ',
                            // ),
                            child: Utils.buildUploadContainer(
                              'Upload Image',
                              null,          // Pass the actual image file
                                  () {
                                print("Container tapped!");
                              },
                              200.0,              // height
                              200.0,              // width
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Check this box if you agree to the terms and conditions',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (_currentStep == 3) ...[
                      Text(
                        'Outlet Name',
                        style: TextStyle(
                          color: Color(0xA51F1F1F),
                          fontFamily: 'Open Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter Outlet Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Outlet Address',
                        style: TextStyle(
                          color: Color(0xA51F1F1F),
                          fontFamily: 'Open Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter Outlet Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // child: Utils.buildUploadContainer(
                            //
                            //   'Upload Outlet Front Image',
                            // ),
                            child: Utils.buildUploadContainer(
                              'Upload Image',
                              null,          // Pass the actual image file
                                  () {
                                print("Container tapped!");
                              },
                              200.0,              // height
                              200.0,              // width
                            ),
                          ),
                          Container(
                            // child: Utils.buildUploadContainer(
                            //   'Upload Outlet Back Image',
                            // ),


                            child: Utils.buildUploadContainer(
                              'Upload Image',
                              null,          // Pass the actual image file
                                  () {
                                print("Container tapped!");
                              },
                              200.0,              // height
                              200.0,              // width
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Check this box if you agree to the terms and conditions',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                          ),
                          Text(
                            'I agree to the terms and conditions',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (_currentStep > 1)
              CustomButton(
                text: 'Previous',
                onPressed: _previousStep,
              ),
            CustomButton(
              text: _currentStep == 3 ? 'Submit' : 'Next',
              onPressed: _currentStep == 3 ? _submitForm : _nextStep,
              isNextButton: true,
            ),
          ],
        ),
      ),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: 315,
              height: 686,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 280,
                    child: SizedBox(
                      width: 315,
                      child: Text(
                        'Thanks for submitting your document. We’ll verify it and complete your KYC as soon as possible.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF171716),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 64,
                    top: 204,
                    child: Text(
                      'KYC Completed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF171716),
                        fontSize: 23,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 9,
                    top: 526,
                    child: GestureDetector(
                      onTap: () => HomeBottomNavBar(),
                      child: Container(
                        width: 293,
                        height: 60,
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Back to home',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.16,
                                    ),
                                  ),
                                  Image.asset("assets/intro/chevron-right.png"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80,
                    top: 0,
                    child: Container(
                      width: 150,
                      height: 150,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Image(
                        image: AssetImage("assets/intro/kycthankyou.png"),
                        height: 360,
                        width: 360,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
