import 'package:dotmik_app/api/creditCardService.dart';
import 'package:dotmik_app/screen/CreditCardBillPayment/RegisterScreen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditCardLoginScreen extends StatefulWidget {
  @override
  _CreditCardLoginScreenState createState() => _CreditCardLoginScreenState();
}

class _CreditCardLoginScreenState extends State<CreditCardLoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final CreditCardService _cardService = CreditCardService();
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
              'Credit Card Bill Payment',
              style: TextStyle(
                color: Color(0xFFC63F3F),
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Enter your mobile number to proceed with the credit card bill payment.',
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
                                await _cardService.check_contact(
                                    context, _mobileController.text);
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
                                        CreditCardRegisterFormScreen()),
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
