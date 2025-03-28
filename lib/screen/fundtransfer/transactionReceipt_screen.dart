import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';

class TransactionReceiptScreen extends StatelessWidget {
  final String phoneNumber;
  final String accountNumber;
  final String ifscCode;
  final String mode;
  final String accountHolder;
  final DateTime dateTime;
  final String referenceNumber;
  final String utr;
  final String status;
  final double availableAmount;

  const TransactionReceiptScreen({
    required this.phoneNumber,
    required this.accountNumber,
    required this.ifscCode,
    required this.mode,
    required this.accountHolder,
    required this.dateTime,
    required this.referenceNumber,
    required this.utr,
    required this.status,
    required this.availableAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: const CustomAppBar(titleText: 'Transaction Details',),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          width: 345,
          height: 610,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color.fromARGB(255, 252, 230, 199),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Center(
                child: Text(
                  'Transaction Receipt',
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
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 397,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFF263238),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildRow('Phone', phoneNumber),
              _buildRow('Account Number', accountNumber),
              _buildRow('IFSC Code', ifscCode),
              _buildRow('Mode', mode),
              _buildRow('Account Holder', accountHolder),
              _buildRow('Date & Time', dateTime.toString()),
              _buildRow('Reference Number', referenceNumber),
              _buildRow('UTR', utr),
              _buildRow('Status', status),
              _buildRow('Available Amount', availableAmount.toString()),
              const SizedBox(
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
                      side: const BorderSide(width: 1, color: Color(0x72616161)),
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
                      const Text(
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
              const SizedBox(
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
