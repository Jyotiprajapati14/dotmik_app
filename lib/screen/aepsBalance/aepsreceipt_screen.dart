import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:flutter/material.dart';

class AepsReceiptScreen extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final DateTime dateTime;
  final double availableAmount;

  AepsReceiptScreen({
    required this.accountNumber,
    required this.dateTime,
    required this.bankName,
    required this.availableAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Receipt',),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          width: 345,
          height: 410,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color.fromARGB(255, 252, 230, 199),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  'Balance Inquiry Success!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF23A26D),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0.09,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 397,
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
              SizedBox(
                height: 20,
              ),
              _buildRow('Aadhar Number', accountNumber),
              _buildRow('Bank Name', bankName),
              _buildRow('Date & Time', dateTime.toString()),
              SizedBox(
                height: 20,
              ),
              _buildRow('Available Amount', availableAmount.toString()),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 297,
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0x72616161)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: 24, height: 24, child: Stack()),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Get PDF Receipt',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0.12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
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
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
