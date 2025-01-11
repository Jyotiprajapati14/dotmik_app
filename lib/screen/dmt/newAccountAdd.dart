import 'package:dotmik_app/api/apiService.dart';
import 'package:dotmik_app/api/dmtService.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class NewAccountRegisterFormScreen extends StatefulWidget {
  @override
  _FormCashScreenState createState() => _FormCashScreenState();
}

class _FormCashScreenState extends State<NewAccountRegisterFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bankId = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  bool _isLoading = false;
  bool isVerified = false;

  final DmtService dmtService = DmtService();

  String? selectedBank;
  List<Map<String, String>> banks = [];

  @override
  void initState() {
    super.initState();
    _fetchBanks();
  }

  Future<void> _fetchBanks() async {
    try {
      final response = await dmtService.getBankName();
      // Check if the response contains the expected structure
      if (response['status'] == 'SUCCESS' && response['data'] != null) {
        final List<dynamic> bankList = response['data']['dmtAccountList'];

        setState(() {
          banks = bankList.map<Map<String, String>>((bank) {
            return {
              'id': (bank['id'] ?? '').toString(), // Ensure id is a string
              'name':
                  (bank['name'] ?? '').toString(), // Ensure name is a string
              'ifsc':
                  (bank['ifsc'] ?? '').toString(), // Ensure ifsc is a string
            };
          }).toList();
        });
      } else {
        throw Exception('Unexpected response structure');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch banks'),
        ),
      );
    }
  }

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
                'Create New Account',
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
                label: 'Name',
                hintText: 'Enter User Name',
                keyboardType: TextInputType.text,
                controller: nameController),
            SizedBox(height: 20.0),
            _buildTextField(
                label: 'Account Number',
                hintText: 'Enter Account Number',
                keyboardType: TextInputType.number,
                controller: accountController),
            SizedBox(height: 20.0),
            _buildDropdownField(
                label: 'Bank',
                hintText: 'Select Bank',
                value: selectedBank,
                items: banks.map((bank) => bank['name']!).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBank = value;
                    final selectedBankDetails =
                        banks.firstWhere((bank) => bank['name'] == value);
                    ifscController.text = selectedBankDetails['ifsc']!;
                    bankId.text = selectedBankDetails['id']!;
                  });
                }),
            SizedBox(height: 20.0),
            _buildTextField(
                label: 'IFSC Code',
                hintText: 'IFSC Code',
                keyboardType: TextInputType.text,
                controller: ifscController,
                isReadOnly: true),
            SizedBox(height: 20.0),
            _buildCheckboxField(),
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
                        final response = await dmtService.NewAccountAdd(
                          nameController.text,
                          accountController.text,
                          ifscController.text,
                          bankId.text,
                          isVerified ? "Yes" : "No",
                          context,
                        );

                        // Check API response
                        if (response['status'] == 'SUCCESS') {
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
    accountController.clear();
    ifscController.clear();
    setState(() {
      selectedBank = null;
      isVerified = false;
    });
  }

  Widget _buildCheckboxField() {
    return Row(
      children: [
        Checkbox(
          value: isVerified,
          onChanged: (bool? value) {
            setState(() {
              isVerified = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isVerified = !isVerified;
              });
            },
            child: Text(
              'I agree to the terms and conditions',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
