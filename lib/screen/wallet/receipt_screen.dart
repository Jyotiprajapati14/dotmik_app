import 'package:dotmik_app/screen/home/dthrecharge/receipt_screen.dart';
import 'package:dotmik_app/screen/home/home_bottombar_screen.dart';
import 'package:flutter/material.dart';

class WalletTransactionReceiptScreen extends StatelessWidget {
  final String amount;
  final String paymentTime;
  final String paymentStatus;
  final String txnId;
  final String paymentType;
  final String paymentMethod;
  final String operatorName;

  WalletTransactionReceiptScreen({
    required this.amount,
    required this.paymentTime,
    required this.paymentStatus,
    required this.txnId,
    required this.paymentType,
    required this.paymentMethod,
    required this.operatorName,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () {},
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: IconButton(
              icon: Icon(Icons.file_upload_outlined, color: Colors.red),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Container(
                  width: screenWidth * 0.9,
                  height: 300,
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, right: 8, bottom: 24),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0x26C63F3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x1EAAAAAA),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        SizedBox(
                          width: 313,
                          child: Text(
                            'Payment Success !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF121212),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0.07,
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          width: 313,
                          child: Text(
                            '₹ $amount',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF121212),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0.07,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 297,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF263238),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildRow('Amount', amount),
                        _buildRow('Payment Time', paymentTime),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DTHTransactionReceiptScreen(
                                amount: amount,
                                paymentStatus: paymentStatus,
                                txnId: txnId,
                                paymentType: paymentType,
                                paymentMethod: paymentMethod,
                                operatorName: operatorName)));
                  },
                  child: Center(
                    child: Container(
                      width: 316,
                      height: 63,
                      decoration: ShapeDecoration(
                        color: Color(0xFFC63F3F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'View Receipt',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 0.12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 25,
              left: (screenWidth / 2) - 65,
              child: Image.asset(
                'assets/images/SVGRepo_iconCarrier.png',
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
