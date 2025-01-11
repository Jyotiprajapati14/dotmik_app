import 'package:dotmik_app/screen/aepsBalance/aepsDettail_screen.dart';
import 'package:dotmik_app/screen/aepsBalance/aepsreceipt_screen.dart';
import 'package:dotmik_app/screen/fundtransfer/transactionReceipt_screen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AepsMiniScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<AepsMiniScreen> {
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
     appBar: CustomAppBar(titleText: 'Aeps',),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 351,
              height: 33,
              child: Center(
                child: Text(
                  'Aeps Mini Statement',
                  style: TextStyle(
                    color:AppColors.red,
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildBankDropdown('Select Bank Account'),
            SizedBox(height: 10.0),
            _buildTextField(
              label: 'Aadhar Number',
              hintText: 'Aadhar Number',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0.0;
                });
              },
              maxLength: 12
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              label: 'Mobile Number',
              hintText: 'Mobile Number',
              onChanged: (value) {
                setState(() {
                  transactionId = value;
                });
              },
              maxLength: 10
            ),
            SizedBox(height: 20.0),
            CustomImageButton(
              text: 'Fetch USer',
              imagePath: 'assets/intro/chevron-right.png',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AepsDetailScreen()));
              },
              color: AppColors.red,
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildTextField({
  required String label,
  required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged, required int maxLength,
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
            counterText: "",  // Hide the character counter
          ),
            keyboardType: keyboardType,
            onChanged: onChanged,
          maxLength: maxLength,  // Apply the maximum length
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength ?? 100),  // Default to 100 if maxLength is null
          ],
        ),
      ),
    ],
  );
}

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Selected Date: ${selectedDate.toString().substring(0, 10)}',
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate)
                    setState(() {
                      selectedDate = pickedDate;
                    });
                },
                child: Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ],
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
