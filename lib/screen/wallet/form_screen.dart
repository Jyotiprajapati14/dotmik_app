import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';

class BankFormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<BankFormScreen> {
  String bankAccount = '';
  String transactionId = '';
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  String modeOfTransaction = '';
  String selectedBank = '';

  final List<String> bankNames = ['Bank A', 'Bank B', 'Bank C', 'Bank D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Wallet',),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Wallet Add Money',
              style: TextStyle(
                color: Color(0xFFC63F3F),
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.0),
            _buildBankDropdown('Select Bank'),
            SizedBox(height: 10.0),
            _buildTextField(
              label: 'Amount',
              hintText: 'Enter amount',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              label: 'Transaction Id/UTR',
              hintText: 'Enter transaction ID or UTR',
              onChanged: (value) {
                setState(() {
                  transactionId = value;
                });
              },
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              label: 'Date',
              hintText: 'Enter date',
              onChanged: (value) {
                setState(() {
                  modeOfTransaction = value;
                });
              },
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              label: 'Mode of Transaction',
              hintText: 'Enter mode of transaction',
              onChanged: (value) {
                setState(() {
                  modeOfTransaction = value;
                });
              },
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              label: '',
              hintText: 'Enter Remark',
              onChanged: (value) {
                setState(() {
                  modeOfTransaction = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Container(
              width: 80,
              height: 125,
              decoration: ShapeDecoration(
                color: Color(0xFFFFEDF1),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFC63F3F),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/upload-cloud.jpg',
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  SizedBox(
                    width: 176.55,
                    height: 25.48,
                    child: Text(
                      'Drag & Drop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF17282F),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 236.35,
                    height: 16.98,
                    child: Text(
                      'or select files from device',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.44999998807907104),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            BigCustomButton(title: 'Submit'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
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
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            keyboardType: keyboardType,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildBankDropdown(text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedBank.isEmpty ? null : selectedBank,
              hint: Text(text),
              isExpanded: true,
              items: bankNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedBank = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
