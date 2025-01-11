import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:flutter/material.dart';

class AepsDetailScreen extends StatelessWidget {
  final String phoneNumber = '1234567890';
  final String accountType = 'Savings';
  final String adharNumber = '1234 5678 9012';
  final String bank = 'ABC Bank';
  final String utr = 'UTR1234567890';
  final String message = 'Transaction successful';
  final String paymentType = 'Online Transfer';
  final List<TransactionData> transactions = [
    TransactionData(
      date: '2024-05-19',
      utr: 'UTR1234567890',
      remark: 'Payment for groceries',
    ),
    TransactionData(
      date: '2024-05-18',
      utr: 'UTR0987654321',
      remark: 'Payment for utilities',
    ),
    // Add more transactions as needed
  ];

  final List<Transaction2Data> transactions2 = [
    Transaction2Data(
      date: '2024-05-19',
      txn: 'RD Services',
      amount: '2000',
      remark: 'Payment for groceries',
    ),
    Transaction2Data(
      date: '2024-05-18',
      txn: 'RD Services',
      amount: '3000',
      remark: 'Payment for utilities',
    ),
    // Add more transactions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Aeps',),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildUserInfo(),
            SizedBox(height: 20),
            _buildTransactionTable(),
            SizedBox(height: 20),
            _buildTransaction2Table(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      color: Color.fromARGB(255, 238, 236, 236),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoRow('Phone Number', phoneNumber),
            _buildUserInfoRow('Account Type', accountType),
            _buildUserInfoRow('Adhar Number', adharNumber),
            _buildUserInfoRow('Bank', bank),
            _buildUserInfoRow('UTR', utr),
            _buildUserInfoRow('Message', message),
            _buildUserInfoRow('Payment Type', paymentType),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.red),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTransactionTable() {
    return DataTable(
      columns: [
        DataColumn(
            label: Text(
          'Date',
          style: TextStyle(color: AppColors.red),
        )),
        DataColumn(
            label: Text(
          'UTR',
          style: TextStyle(color: AppColors.red),
        )),
        DataColumn(
            label: Text(
          'Remark',
          style: TextStyle(color: AppColors.red),
        )),
      ],
      rows: transactions.map((transaction) {
        return DataRow(cells: [
          DataCell(Text(transaction.date)),
          DataCell(Text(transaction.utr)),
          DataCell(Text(transaction.remark)),
        ]);
      }).toList(),
    );
  }

  Widget _buildTransaction2Table() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 17.0,
        columns: [
          DataColumn(
              label: Text(
            'Date',
            style: TextStyle(color: AppColors.red),
          )),
          DataColumn(
              label: Text(
            'Txn. Type',
            style: TextStyle(color: AppColors.red),
          )),
          DataColumn(
              label: Text(
            'Amount',
            style: TextStyle(color: AppColors.red),
          )),
          DataColumn(
              label: Text(
            'Remark',
            style: TextStyle(color: AppColors.red),
          )),
        ],
        rows: transactions2.map((transactionData) {
          return DataRow(cells: [
            DataCell(Text(transactionData.date)),
            DataCell(Container(
                width: 84,
                height: 30,
                decoration: ShapeDecoration(
                  color: Color(0xFFFAC0D3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: Center(child: Text(transactionData.txn)))),
            DataCell(Text(transactionData.amount)),
            DataCell(Text(transactionData.remark)),
          ]);
        }).toList(),
      ),
    );
  }
}

class TransactionData {
  final String date;
  final String utr;
  final String remark;

  TransactionData(
      {required this.date, required this.utr, required this.remark});
}

class Transaction2Data {
  final String date;
  final String txn;
  final String amount;
  final String remark;

  Transaction2Data(
      {required this.date,
      required this.txn,
      required this.amount,
      required this.remark});
}
