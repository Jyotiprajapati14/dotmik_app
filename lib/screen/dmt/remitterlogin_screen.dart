import 'package:dotmik_app/api/dmtService.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DmtLoginFormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<DmtLoginFormScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final DmtService _cardService = DmtService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Login',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Domestic Money Transfer',
              style: TextStyle(
                color: Color(0xFFC63F3F),
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Enter your mobile number to proceed with the domestic money transfer payment.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                hintText: 'Enter Mobile Number',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            SizedBox(height: 40),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator() // Show loading indicator when _isLoading is true
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Background color
                              foregroundColor: Colors.white, // Text color
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true; // Start loading
                              });

                              try {
                                await _cardService.DmtLogin(
                                    _mobileController.text, context);
                                await Future.delayed(Duration(seconds: 500));
                              } catch (e) {
                                // Handle error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('An error occurred'),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false; // Stop loading
                                });
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Background color
                              foregroundColor: Colors.white, // Text color
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RemitterRegisterFormScreen()),
                              );
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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

class RemitterRegisterFormScreen extends StatefulWidget {
  @override
  _FormCashScreenState createState() => _FormCashScreenState();
}

class _FormCashScreenState extends State<RemitterRegisterFormScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final DmtService dmtService = DmtService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Register',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 351,
              height: 33,
              child: Text(
                'Register User',
                style: TextStyle(
                  color: Color(0xFFC63F3F),
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildTextField(
                label: 'First Name',
                hintText: 'Enter First Name',
                keyboardType: TextInputType.text,
                controller: firstNameController,
                maxLength: 25),
            SizedBox(height: 10.0),
            _buildTextField(
                label: 'Last Name',
                hintText: 'Enter First Name',
                keyboardType: TextInputType.text,
                controller: lastNameController,
                maxLength: 25),
            SizedBox(height: 10.0),
            _buildTextField(
                label: 'Mobile Number',
                hintText: 'Enter Mobile Number',
                keyboardType: TextInputType.number,
                controller: mobileController,
                maxLength: 10),
            SizedBox(height: 10.0),
            _buildTextField(
                label: 'Pin Code',
                hintText: 'Enter Pin Code',
                keyboardType: TextInputType.number,
                controller: pinCodeController,
                maxLength: 6),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  height: 42,
                  child: CustomTextButton(
                    BorderRadius: BorderRadius.circular(5),
                    text: 'Submit',
                    onPressed: () async {
                      setState(() {
                        _isLoading = true; // Show loading indicator
                      });
                      try {
                        final response = await dmtService.DmtRegister(
                          mobileController.text,
                          firstNameController.text,
                          lastNameController.text,
                          pinCodeController.text,
                          context,
                        );

                        if (response['status'] == 'SUCCESS'|| response['status'] == true ) {
                          // If the response is successful, show the Bill dialog
                          _showBillDialog(context);
                        } else {
                          // If not successful, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Failed to add account: ${response['message']}'),
                            ),
                          );
                        }
                      } catch (e) {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred'),
                          ),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false; // Hide loading indicator
                        });
                      }
                    },
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 42,
                  child: CustomTextButton(
                    BorderRadius: BorderRadius.circular(5),
                    text: 'Reset',
                    onPressed: () {},
                    color: Color.fromARGB(255, 229, 208, 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showBillDialog(BuildContext context) {
    TextEditingController _otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(8.0),
          contentPadding: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: ShapeDecoration(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Center(
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
            constraints: BoxConstraints(
              maxWidth: 800,
              minWidth: 300,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  PinCodeTextField(
                    controller: _otpController,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: false,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 50,
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
                    animationDuration: const Duration(milliseconds: 300),
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
                  SizedBox(height: 20),
                  if (_isLoading)
                    Center(
                        child:
                            CircularProgressIndicator()), // Show loading spinner
                  CustomNormalButton(
                    buttonText: 'OK',
                    onTap: () async {
                      String otpCode = _otpController.text;
                      setState(() {
                        _isLoading = true; // Set loading to true
                      });
                      await dmtService.otpverify(otpCode);
                      setState(() {
                        _isLoading = false; // Set loading to false
                      });
                      await Future.delayed(Duration(milliseconds: 500));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
    int? maxLength, // Optional parameter to set maximum length
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF263238),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              counterText: "", // Hide the character counter
            ),
            keyboardType: keyboardType,
            maxLength: maxLength, // Apply the maximum length
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  maxLength ?? 100), // Default to 100 if maxLength is null
            ],
          ),
        ),
      ],
    );
  }

  void showErrorDialog(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(
              child: Text("Submit OTP", style: TextStyle(color: Colors.red))),
          content: Text(description),
          actions: [
            Center(
              child: CustomTextButton(
                text: "Submit",
                onPressed: () {},
                color: Colors.blue,
                BorderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        );
      },
    );
  }
}
