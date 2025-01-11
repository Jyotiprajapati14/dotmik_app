import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_me/share_me.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  TransactionDetailScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Determine status color based on transaction status
    Color statusColor;
    String status = transaction['status']?.toString().toLowerCase() ??
        transaction['wallet_type'] ??
        'pending';
    if (status == 'success' ||
        status == 'credit' ||
        status == 'SUCCESS' ||
        status == 'CREDIT') {
      statusColor = Colors.green;
    } else if (status == 'pending') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: statusColor,
        title: Text(
          'Transaction Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share logic
              _shareReceipt(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(10.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display transaction status and main details
                    _buildTransactionStatus(context, statusColor),
                    SizedBox(height: 16),
                    // Payment details section
                    _buildTransactionDetails(statusColor),
                    SizedBox(height: 16),
                    // Additional details section
                    _buildAdditionalDetails(statusColor),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionStatus(BuildContext context, Color statusColor) {
    String name = transaction['name']?.toString() ??
        transaction['type']?.toString() ??
        transaction['other_user_name']?.toString() ??
        _extractNameFromRemark(transaction['remark']?.toString() ?? '');
    String bankingName = transaction['bank']?.toString() ??
        transaction['bank_name']?.toString() ??
        _extractBankingNameFromRemark(transaction['remark']?.toString() ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name.isNotEmpty)
          Text(
            'Paid to',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (name.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: _buildProfileImage(),
            title: Text(
              name.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(transaction['phone']?.toString() ??
                transaction['mobile']?.toString() ??
                transaction['other_user_phone']?.toString() ??
                ''),
            trailing: Text(
              transaction['amount'] != null
                  ? '₹${_formatAmount(transaction['amount'])}'
                  : '₹0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: statusColor,
              ),
            ),
          ),
        if (bankingName.isNotEmpty)
          Text(
            'Banking Name: $bankingName',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildProfileImage() {
    String? imageUrl = transaction['profileImageUrl']?.toString();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 24,
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.grey[300],
        radius: 24,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildTransactionDetails(Color statusColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: statusColor,
                )),
            SizedBox(height: 16),
            if ((transaction['user_ref']?.toString() ?? '').isNotEmpty)
              _buildDetailRow('Transaction ID   ',
                  transaction['user_ref']?.toString() ?? '',
                  showCopy: true),
            if ((transaction['debitedFrom']?.toString() ??
                    transaction['account']?.toString() ??
                    '')
                .isNotEmpty)
              _buildDetailRow(
                  'Debited from',
                  transaction['debitedFrom']?.toString() ??
                      transaction['account']?.toString() ??
                      ''),
            if ((transaction['utr']?.toString() ?? '').isNotEmpty)
              _buildDetailRow('UTR', transaction['utr']?.toString() ?? '',
                  showCopy: true),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalDetails(Color statusColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Additional Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: statusColor,
                )),
            SizedBox(height: 10),
            if ((transaction['account']?.toString() ?? '').isNotEmpty)
              _buildDetailRow(
                  'Account No.', transaction['account']?.toString() ?? ''),
            if ((transaction['ifsc']?.toString() ?? '').isNotEmpty)
              _buildDetailRow('IFSC', transaction['ifsc']?.toString() ?? ''),
            if ((transaction['charge']?.toString() ?? '').isNotEmpty)
              _buildDetailRow(
                  'Charge', transaction['charge']?.toString() ?? ''),
            if ((transaction['commission']?.toString() ?? '').isNotEmpty)
              _buildDetailRow(
                  'Commission', transaction['commission']?.toString() ?? ''),
            if ((transaction['tds']?.toString() ?? '').isNotEmpty)
              _buildDetailRow('TDS', transaction['tds']?.toString() ?? ''),
            if ((transaction['gst']?.toString() ?? '').isNotEmpty)
              _buildDetailRow('GST', transaction['gst']?.toString() ?? ''),
            if ((transaction['mode']?.toString() ?? '').isNotEmpty)
              _buildDetailRow(
                  'Mode of Transaction', transaction['mode']?.toString() ?? ''),
            if ((transaction['message']?.toString() ??
                    transaction['remark']?.toString() ??
                    '')
                .isNotEmpty)
              _buildDetailRow(
                  'Message',
                  transaction['message']?.toString() ??
                      transaction['remark']?.toString() ??
                      ''),
            if ((transaction['created_at']?.toString() ?? '').isNotEmpty)
              _buildDetailRow(
                  'Date', _formatDate(transaction['created_at']!.toString())),
          ],
        ),
      ),
    );
  }

  void _shareReceipt(BuildContext context) {
    ShareMe.system(
      title: 'Transaction',
      url: '',
      description: '',
      subject: '',
    );
  }


 Widget _buildDetailRow(String label, String value, {bool showCopy = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4), // Add some spacing between the label and value
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap value in Expanded to allow line breaking
            Expanded(
              child: Text(
                value,
                softWrap: true, // Wrap text to a new line if necessary
                overflow: TextOverflow.visible, // Ensure it doesn't get cut off
              ),
            ),
            if (showCopy)
              IconButton(
                icon: Icon(Icons.copy, size: 16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('$label copied to clipboard')),
                  // );
                },
              ),
          ],
        ),
      ],
    ),
  );
}

  String _formatAmount(String amount) {
    // Implement amount formatting logic if needed
    return amount;
  }

  String _formatDate(String dateString) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateTime.parse(dateString);

      // Define the desired date format: 07 Sep 2024
      DateFormat dateFormat = DateFormat('dd MMM yyyy');

      // Format the date
      return dateFormat.format(parsedDate);
    } catch (e) {
      // If the input is not a valid date, return the original string
      return dateString;
    }
  }

  String _extractNameFromRemark(String remark) {
    // Logic to extract name from the remark field
    return '';
  }

  String _extractBankingNameFromRemark(String remark) {
    // Logic to extract banking name from the remark field
    return '';
  }
}
