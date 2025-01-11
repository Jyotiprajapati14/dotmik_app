import 'package:flutter/material.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transactionData;

  TransactionDetailsScreen({required this.transactionData});

  @override
  Widget build(BuildContext context) {
    // Determine which receipt data is available
    final receiptData = transactionData['data']['creditCardBillReceiptData'] ??
        transactionData['data']['FundTransferReceiptData'] ??
        transactionData['data']['dmtReceiptData'];

    if (receiptData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Transaction Details'),
          backgroundColor: Colors.redAccent,
        ),
        body: Center(
          child: Text('No transaction data available.'),
        ),
      );
    }

    final outlet = receiptData['outlet'] ?? 'N/A';
    final phone = receiptData['phone'] ?? 'N/A';
    final logoUrl = receiptData['logo'] ?? '';
    final bodyData = receiptData['bodyData'] ?? {};
    final buttonHeader = receiptData['buttonHeader'] ?? [];
    final buttonData = receiptData['buttonData'] ?? [];
    final total = receiptData['total'] ?? '0';

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Transaction Details'),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Section
              if (logoUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: Image.network(
                      logoUrl,
                      height: 60,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

              // Transaction Data Table
              _buildTransactionDataTable(phone, bodyData, buttonHeader, buttonData, total),
              
              // Total Section
              SizedBox(height: 24),
              _buildTotalRow('Total Amount', total),
              SizedBox(height: 24),

              // Footer Section
              Center(
                child: Text(
                  'Thank you for your business!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionDataTable(String phone, Map<String, dynamic> bodyData,
      List<dynamic> buttonHeader, List<dynamic> buttonData, String total) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Body Data Rows
        if (bodyData is Map<String, dynamic>)
          for (var key in bodyData.keys)
            _buildTableRow(key, bodyData[key]?.toString() ?? 'N/A'),
        
        // Button Header and Data Rows
        if (buttonHeader is List<dynamic> && buttonData is List<dynamic> && buttonData.isNotEmpty)
          for (int i = 0; i < buttonHeader.length; i++)
            _buildTableRow(
              buttonHeader[i]?.toString() ?? 'N/A',
              _getButtonDataValue(buttonData[0], buttonHeader[i]?.toString() ?? 'N/A'),
              isGreen: true,
            ),
      ],
    );
  }

  // Helper widget to build table rows
  TableRow _buildTableRow(String label, String value, {bool isGreen = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isGreen ? Colors.green : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  // Helper function to extract button data value based on the header key
  String _getButtonDataValue(Map<String, dynamic> buttonData, String header) {
    switch (header) {
      case 'Ref.No':
        return buttonData['user_ref'] ?? 'N/A';
      case 'UTR':
        return buttonData['utr'] ?? 'N/A';
      case 'Status':
        return buttonData['status'] ?? 'N/A';
      default:
        return 'N/A';
    }
  }

  // Helper widget to build total row
  Widget _buildTotalRow(String label, String value) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

