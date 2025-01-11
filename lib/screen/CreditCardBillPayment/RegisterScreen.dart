import 'package:dotmik_app/api/apiService.dart';
import 'package:dotmik_app/api/creditCardService.dart';
import 'package:dotmik_app/api/dmtService.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreditCardRegisterFormScreen extends StatefulWidget {
  @override
  _FormCashScreenState createState() => _FormCashScreenState();
}

class _FormCashScreenState extends State<CreditCardRegisterFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  bool _isLoading = false;

  final CreditCardService creditCardService = CreditCardService();

  String? selectedBank;
  List<Map<String, String>> banks = [];

  @override
  void initState() {
    super.initState();
  }

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
                'Create Credit Card Account',
                style: TextStyle(
                  color: Color(0xFFC63F3F),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildTextField(
                label: 'Credit Card Holder Name',
                hintText: 'Enter Credit Card Holder Name',
                keyboardType: TextInputType.text,
                controller: nameController),
            SizedBox(height: 20.0),
            _buildTextField(
                label: 'Credit Card Number',
                hintText: 'Enter Credit Card Number',
                keyboardType: TextInputType.number,
                controller: cardNumberController),
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
                        await creditCardService.NewAccountAdd(
                          nameController.text,
                          cardNumberController.text,
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
                      // Add your submit logic here
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
                    onPressed: () {
                      _resetForm();
                    },
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
                      await creditCardService.otpverify(otpCode, context);
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

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF263238),
            fontSize: 12,
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
          child: DropdownButton<String>(
            value: value,
            hint: Text(hintText),
            isExpanded: true,
            underline: SizedBox(),
            onChanged: onChanged,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
    bool isReadOnly = false,
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
            ),
            keyboardType: keyboardType,
            readOnly: isReadOnly,
          ),
        ),
      ],
    );
  }

  void _resetForm() {
    nameController.clear();
    cardNumberController.clear();
    setState(() {
      selectedBank = null;
    });
  }
}
