import 'package:dotmik_app/api/bbpsService.dart';
import 'package:flutter/material.dart';

class BillDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> billData;
  final String biller;

  const BillDetailsScreen(
      {Key? key, required this.billData, required  this.biller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 16, color: Colors.black87);
    final labelStyle = TextStyle(fontSize: 14, color: Colors.grey[600]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bill Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailCard(
              context,
              'Biller/Board',
              billData['description']['Biller/Board'],
              Icons.business,
              textStyle,
              labelStyle,
            ),
            _buildDetailCard(
              context,
              'Last 4 digits of primary credit card number',
              billData['description']
                  ['Last 4 digit of primary credit card number'],
              Icons.credit_card,
              textStyle,
              labelStyle,
            ),
            _buildDetailCard(
              context,
              'Mobile Number',
              billData['description']['Mobile Number'],
              Icons.phone,
              textStyle,
              labelStyle,
            ),
            _buildDetailCard(
              context,
              'Name',
              billData['description']['Name'],
              Icons.person,
              textStyle,
              labelStyle,
            ),
            _buildDetailCard(
              context,
              'Amount',
              billData['description']['Amount'],
              Icons.attach_money,
              textStyle,
              labelStyle,
            ),
            _buildDetailCard(
              context,
              'Due Date',
              billData['description']['DueDate'],
              Icons.calendar_today,
              textStyle,
              labelStyle,
            ),
            _buildDetailCard(
              context,
              'Bill Date',
              billData['description']['BillDate'],
              Icons.date_range,
              textStyle,
              labelStyle,
            ),
            _buildDetailCard(
              context,
              'Bill Period',
              billData['description']['BillPeriod'],
              Icons.timeline,
              textStyle,
              labelStyle,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showTransactionPopup(context, biller);
                  // Handle transaction button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Make Transaction',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionPopup(BuildContext context , String biller) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = amountController.text;
                if (amount.isNotEmpty) {
                  Navigator.of(context).pop();
                  _sendTransaction(context, amount,biller);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: Text('Send',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  void _sendTransaction(BuildContext context, String amount,String biller) async {
    // Call the transaction API
    final service = Bbpsservice();
    await service.TransactionDetailsSend(biller, amount, context);
  }

  Widget _buildDetailCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    TextStyle textStyle,
    TextStyle labelStyle,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent),
        title: Text(label, style: labelStyle),
        subtitle: Text(value, style: textStyle),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
