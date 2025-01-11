import 'package:dotmik_app/screen/home/dthrecharge/receipt_screen.dart';
import 'package:dotmik_app/screen/notification_screen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';

class AmazonWalletBillsFormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<AmazonWalletBillsFormScreen> {
  String selectedBank = '';

  final List<String> bankNames = ['Bank A', 'Bank B', 'Bank C', 'Bank D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(titleText: 'Amazon Wallet',),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 33,
                  child: Text(
                    'Amazon Wallet Top Up',
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
                _buildBankDropdown("Wallet Name"),
                SizedBox(height: 10.0),
                _buildTextField(
                  label: 'Beneficiary Name',
                  hintText: 'Enter beneficiary name',
                  onChanged: (value) {
                    // Handle onChanged
                  },
                ),
                SizedBox(height: 10.0),
                _buildTextField(
                  label: 'Loan Number',
                  hintText: 'Enter loan number',
                  onChanged: (value) {
                    // Handle onChanged
                  },
                ),
                SizedBox(height: 10.0),
                _buildTextField(
                  label: 'Remarks (Optional)',
                  hintText: 'Enter remarks',
                  onChanged: (value) {
                    // Handle onChanged
                  },
                ),
                SizedBox(height: 10.0),
                _buildTextField(
                  label: 'Beneficiary Email (Optional)',
                  hintText: 'Enter beneficiary email',
                  onChanged: (value) {
                    // Handle onChanged
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: CustomEditButton(
                    text: 'Pay',
                    imagePath: 'assets/intro/chevron-right.png',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DTHTransactionReceiptScreen(
                                  amount: "310",
                                  paymentStatus: "online",
                                  txnId: "234534343",
                                  paymentType: '',
                                  paymentMethod: '',
                                  operatorName: "Vidhi Sharma")));
                      // Handle button press
                    },
                    color: Colors.red,
                    BorderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  showMenu() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.black87.withOpacity(0.5),
            body: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Mr. Lalit',
                                style: TextStyle(
                                  color: Color(0xFF23303B),
                                  fontSize: 26,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Lrrao@1606',
                                style: TextStyle(
                                  color: Color(0xFF4E4C4C),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Container(
                                width: 200,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1CCD9D).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Kyc Status: ',
                                        style: TextStyle(
                                          color: Color(0xFF13C999),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Color(0xFF13C999),
                                          fontSize: 16,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Today’s Earning',
                                  style: TextStyle(
                                    color: Color(0xFF23303B),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  '₹ 230.30',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xFF23303B),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Image.asset("assets/intro/line.png"),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Earning',
                                  style: TextStyle(
                                    color: Color(0xFF23303B),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  '₹ 12560550.23',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                    letterSpacing: 0.20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Share Profile',
                              style: TextStyle(
                                color: Color(0xFF23303B),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                        "assets/images/whatsapp.jpeg")),
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                        "assets/images/insta.jpeg")),
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child:
                                        Image.asset("assets/images/fb.jpeg")),
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child:
                                        Image.asset("assets/images/more.jpeg")),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.42 - 46,
                  left: screenWidth / 2 - 46,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(
                      "https://i.stack.imgur.com/S11YG.jpg?s=64&g=1",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
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
