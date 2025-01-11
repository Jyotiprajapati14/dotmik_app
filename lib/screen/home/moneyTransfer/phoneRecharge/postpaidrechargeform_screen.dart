import 'package:dotmik_app/screen/home/dthrecharge/receipt_screen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:dotmik_app/utils/textstyles/customCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostpaidrechargeFormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<PostpaidrechargeFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Mobile Recharge',),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 351,
              height: 33,
              child: Text(
                'Postpaid Mobile',
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
              label: 'Mobile No.',
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 50.0),
            CustomTextButton(
                text: "Submit",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RechargeTranferFormScreen()));
                },
                color: Colors.red,
                BorderRadius: BorderRadius.circular(12))
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
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
              border: InputBorder.none,
            ),
            keyboardType: keyboardType,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class RechargeTranferFormScreen extends StatefulWidget {
  @override
  _FormCashScreenState createState() => _FormCashScreenState();
}

class _FormCashScreenState extends State<RechargeTranferFormScreen> {
  String bankAccount = '';
  String transactionId = '';
  double amount = 0.0;
  String modeOfTransaction = '';
  String selectedBank = '';

  final List<String> bankNames = ['Bank A', 'Bank B', 'Bank C', 'Bank D'];
  List<CustomCard> items = [
    CustomCard(imageUrl: 'https://via.placeholder.com/51x51', text: 'BSNL',operatorCode: "",operatorId: 1),
    CustomCard(imageUrl: 'https://via.placeholder.com/51x51', text: 'AIRTEL',operatorCode: "",operatorId: 2),
    CustomCard(imageUrl: 'https://via.placeholder.com/51x51', text: 'JIO',operatorCode: "",operatorId: 3 ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: '',),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 351,
              height: 33,
              child: Text(
                'Postpaid Mobile',
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
              label: 'Mobile Number',
              hintText: 'Enter Mobile Number',
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Select Operator',
              style: TextStyle(
                color: Color(0xFFC63F3F),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // child: CustomCardWidget(items: items)),
                child: CustomCardWidget(items: items, onTap: (CustomCard ) {  },)),
            SizedBox(height: 20.0),
            Text(
              'Enter Amount',
              style: TextStyle(
                color: Color(0xFFC63F3F),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: 260,
                height: 45,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFC63F3F)),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Center(
                  child: Text(
                    '₹250',
                    style: TextStyle(
                      color: Color(0xFFC63F3F),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                )),
            SizedBox(height: 20),
            CustomTextButton(
                text: "Recharge",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DTHTransactionReceiptScreen(
                                amount: '250',
                                paymentStatus: 'done',
                                txnId: '54431232322',
                                paymentType: 'online',
                                paymentMethod: 'DTH',
                                operatorName: 'vidhi sharma',
                              )));
                },
                color: Colors.red,
                BorderRadius: BorderRadius.circular(12))
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
