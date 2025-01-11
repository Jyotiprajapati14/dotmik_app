import 'package:dotmik_app/api/dmtService.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MerchantRegisterFormScreen extends StatefulWidget {
  @override
  _FormCashScreenState createState() => _FormCashScreenState();
}

class _FormCashScreenState extends State<MerchantRegisterFormScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final DmtService dmtService = DmtService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(titleText: 'Register',),
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
                label: 'Email Address',
                hintText: 'Enter Email Address',
                keyboardType: TextInputType.text,
                controller: emailController, maxLength:150),
            SizedBox(height: 10.0),
            _buildTextField(
                label: 'Mobile Number',
                hintText: 'Enter Mobile Number',
                keyboardType: TextInputType.number, // Mobile number should use number type
                controller: mobileController,
                maxLength: 10,),
            SizedBox(height: 10.0),
             _buildTextField(
                label: 'Aadhar Number',
                hintText: 'Enter First Name',
                keyboardType: TextInputType.text,
                controller: aadharController, maxLength: 14),
            SizedBox(height: 10.0),
            _buildTextField(
                label: 'Pan Code',
                hintText: 'Enter Pan Code',
                keyboardType: TextInputType.number,
                controller: panController, maxLength: 6),
            SizedBox(height: 20.0),
            _buildTextField(
                label: 'Account Number',
                hintText: 'Enter account number',
                keyboardType: TextInputType.number,
                controller: accountController, maxLength: 15),
            SizedBox(height: 20.0),
            _buildTextField(
                label: 'Ifsc Code',
                hintText: 'Enter Ifsc Code',
                keyboardType: TextInputType.number,
                controller: ifscController, maxLength: 15),
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
                      try {
                        await dmtService.MerchantRegister(
                          emailController.text,
                          mobileController.text,
                          aadharController.text,
                          panController.text,
                          accountController.text,
                          ifscController.text,
                          context,
                        );
                        _showBillDialog(context);
                      } catch (e) {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred'),
                          ),
                        );
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
    final _otpControllers =
        List<TextEditingController>.generate(6, (_) => TextEditingController());
    final _otpFocusNodes = List<FocusNode>.generate(6, (_) => FocusNode());

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
                                fillColor: Colors.grey,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
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
                                } else if (value.isEmpty) {
                                  if (index > 0) {
                                    _otpFocusNodes[index - 1].requestFocus();
                                  }
                                }
                              },
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  CustomNormalButton(
                    buttonText: 'OK',
                    onTap: () async {
                      String otpCode = _otpControllers
                          .map((controller) => controller.text)
                          .join();
                      await dmtService.MerchantOtpVerify(otpCode);
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
  int? maxLength,
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
            counterText: "",  // Hide the character counter
          ),
          keyboardType: keyboardType,
          maxLength: maxLength,  // Apply the maximum length
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength ?? 100),  // Default to 100 if maxLength is null
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
