import 'dart:io';

import 'package:dotmik_app/api/apiService.dart';
import 'package:dotmik_app/screen/home/home_bottombar_screen.dart';
import 'package:dotmik_app/screen/kyc/kycpendingScreen.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:dotmik_app/utils/upload_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class KycFormScreen extends StatelessWidget {
  final int initialStep;

  KycFormScreen({required this.initialStep});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MultiStepForm(initialStep: initialStep),
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
  final int initialStep;

  MultiStepForm({required this.initialStep});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final ApiService apiService = ApiService();
  bool _isLoading = false;
  late int _currentStep;
  File? _panCardImage;
  File? _aadharFrontImage;
  File? _aadharBackImage;
  File? _shopFrontImage;
  File? _shopBackImage;
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(
      ImageSource source, Function(File?) onImagePicked) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      onImagePicked(File(pickedFile!.path));
    });
  }

  // void _nextStep() async {
  //   if (_currentStep == 1) {
  //     await apiService.kycphaseOne(
  //       emailController.text,
  //       mobileController.text,
  //       accountController.text,
  //       panController.text,
  //       aadharController.text,
  //       ifscController.text,
  //     );
  //     // Show popup on step 0
  //     _showBillDialog(context);
  //   } else {
  //     setState(() {
  //       _currentStep++;
  //     });
  //   }
  // }
   Future <void> _nextStep() async {
    if (_currentStep == 1) {
      setState(() {
        _isLoading = true;
      });

      var response = await apiService.kycphaseOne(
        emailController.text,
        mobileController.text,
        accountController.text,
        panController.text,
        aadharController.text,
        ifscController.text,
        context,
      );
      //print(response! = null);
      setState(() {
        _isLoading = false; // Set loading to false
      });

      if (response['status'] == 'SUCCESS') {
        // Navigate to the OTP screen
        _showBillDialog(context);
      } else {
        // Show a snackbar with the error message
        final message = response['message'] ?? 'An error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } else {
      //final message = response['message'] ?? 'An error occurred.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("message")),
      );
      setState(() {
        _currentStep++;
      });
    }
  }

  void _showBillDialog(BuildContext context) {
    final List<TextEditingController> _otpControllers =
    List.generate(6, (_) => TextEditingController());
    final List<FocusNode> _otpFocusNodes =
    List.generate(6, (_) => FocusNode());
    bool _isLoading = false; // Track loading state

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(8.0),
              contentPadding: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: ShapeDecoration(
                  color: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Enter OTP',
                    style: TextStyle(
                      color: Color(0xFFC43F3E),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              content: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 800,
                  minWidth: 300,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SizedBox(
                              width: 30,
                              height: 50,
                              child: TextFormField(
                                controller: _otpControllers[index],
                                focusNode: _otpFocusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                decoration: InputDecoration(
                                  counterText: "",
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    if (index < 5) {
                                      _otpFocusNodes[index + 1].requestFocus();
                                    } else {
                                      _otpFocusNodes[index].unfocus();
                                    }
                                  } else if (value.isEmpty && index > 0) {
                                    _otpFocusNodes[index - 1].requestFocus();
                                  }
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator()),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null // Disable button during loading
                            : () async {
                          String otpCode = _otpControllers
                              .map((controller) => controller.text)
                              .join();

                          if (otpCode.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid 6-digit OTP.'),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            bool isVerified =
                           await apiService.kycOtpverify(otpCode);
                            if (isVerified) {
                              setState(() {
                                _isLoading = false;
                              });

                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                              Navigator.pop(context);
                              setState(() {
                                _currentStep++;
                              });
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid OTP, please try again.'),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                              ),
                            );
                          }
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true; // Set loading to true
    });
    dynamic response = await apiService.kycphaseTwo(
      _panCardImage,
      _aadharFrontImage,
      _aadharBackImage,
      _shopFrontImage,
      _shopBackImage,
      fatherNameController.text,
      shopNameController.text,
      shopAddressController.text
    );
    setState(() {
      _isLoading = false; // Set loading to false
    });
    if(response['status'] == 'SUCCESS')
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> KycPendingScreen()));
      }
    else
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            duration: Duration(seconds: 2),
          ),
        );
      }
    print("phase2 response :- $response");
    print(response['status']);
    // Navigate to another screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ThankYouScreen()),
    // );
  }

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
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
                        color: _currentStep >= 2 ? AppColors.red : Colors.grey,
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
                        color: _currentStep >= 3 ? AppColors.red : Colors.grey,
                      ),
                    ),
                    StepIndicator(
                      stepNumber: 3,
                      title: 'Shop\nDetails',
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
                      'Step $_currentStep: ${_currentStep == 1 ? "Personal Information" : (_currentStep == 2 ? "ID Details" : "Shop Details")}',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 18,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_currentStep == 1) ...[
                      Text(
                        'Email',
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
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter Email Address',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      SizedBox(height: 20),
                      Text(
                        'Mobile Number',
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
                        controller: mobileController,
                        decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Allow only digits
                          LengthLimitingTextInputFormatter(
                              10), // Limit to 10 digits
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Aadhar Number',
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
                        controller: aadharController,
                        decoration: InputDecoration(
                          hintText: 'Enter Aadhar Number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Allow only digits
                          LengthLimitingTextInputFormatter(
                              12), // Limit to 10 digits
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Pan Number',
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
                      TextFormField(
                        controller: panController,
                        decoration: InputDecoration(
                          hintText: 'Enter PAN Number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a PAN number';
                          }
                          if (!isValidPanNumber(value)) {
                            return 'Please enter a valid PAN number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Account Number",
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
                          controller: accountController,
                          decoration: InputDecoration(
                            hintText: 'Enter Account Number',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      SizedBox(height: 20),
                      Text(
                        'Ifsc Code',
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
                          controller: ifscController,
                          decoration: InputDecoration(
                            hintText: 'Enter Ifsc Code',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      SizedBox(height: 20),
                    ],
                    if (_currentStep == 2) ...[
                      Text(
                        'Father Name',
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
                          controller: fatherNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Father Name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      SizedBox(height: 20),
                      Utils.buildUploadContainer(
                          'Upload Pan Card Image',
                          _panCardImage,
                          () => _pickImage(ImageSource.camera, (image) {
                                setState(() {
                                  _panCardImage = image;
                                });
                              }),
                          150,
                          400),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Utils.buildUploadContainer(
                              'Upload Aadhar Front Image',
                              _aadharFrontImage,
                              () => _pickImage(ImageSource.camera, (image) {
                                setState(() {
                                  _aadharFrontImage = image;
                                });
                              }),
                              150,
                              150,
                            ),
                          ),
                          Container(
                            child: Utils.buildUploadContainer(
                              'Upload Aadhar Back Image',
                              _aadharBackImage,
                              () => _pickImage(ImageSource.camera, (image) {
                                setState(() {
                                  _aadharBackImage = image;
                                });
                              }),
                              150,
                              150,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                    if (_currentStep == 3) ...[
                      Text(
                        'Shop Name',
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
                          controller: shopNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Shop Name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      SizedBox(height: 20),
                      Text(
                        'Shop Address',
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
                          controller: shopAddressController,
                          decoration: InputDecoration(
                            hintText: 'Enter Shop Address',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Utils.buildUploadContainer(
                              'Upload Shop Front Image',
                              _shopFrontImage,
                              () => _pickImage(ImageSource.camera, (image) {
                                setState(() {
                                  _shopFrontImage = image;
                                });
                              }),
                              150,
                              150,
                            ),
                          ),
                          Container(
                            child: Utils.buildUploadContainer(
                              'Upload Shop Back Image',
                              _shopBackImage,
                              () => _pickImage(ImageSource.camera, (image) {
                                setState(() {
                                  _shopBackImage = image;
                                });
                              }),
                              150,
                              150,
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
            if (_currentStep > 2)
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

  bool isValidPanNumber(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return panRegex.hasMatch(pan);
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
