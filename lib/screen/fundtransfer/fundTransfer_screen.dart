import 'dart:convert';

import 'package:dotmik_app/screen/fundtransfer/addbeneficiary.dart';
import 'package:dotmik_app/screen/fundtransfer/fundLoginScreen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';
import 'package:dotmik_app/api/fundTranferService.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FundTransferScreen extends StatefulWidget {
  final bool shouldFetchData;

  FundTransferScreen({required this.shouldFetchData});

  @override
  _FundTransferScreenState createState() => _FundTransferScreenState();
}

class _FundTransferScreenState extends State<FundTransferScreen> {
  final FundTransferService fundTransferService = FundTransferService();
  final FundTransferService _service = FundTransferService();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _isLoading = true;

  // Define fields to store user details
  String remitterName = '';
  String mobileNumber = '';
  String emailAddress = '';
  String totalLimit = '';
  String remainingLimit = '';
  String limitPerTransaction = '';
  List<Map<String, dynamic>> _accounts = [];

  @override
  void initState() {
    super.initState();
    if (widget.shouldFetchData) {
      _fetchUserDetails();
    }
  }

  void _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataDetails = prefs.getString('userFundDetails');
    print("the DataDetails $dataDetails");
    if (dataDetails != null) {
      final Map<String, dynamic> data = json.decode(dataDetails);
      final remitterData = data['data']['contactData']['contact_data'];
      print("the Dataa $remitterData");
      final accounts = List<Map<String, dynamic>>.from(
          data['data']['contactData']['accounts'] ?? []);
      print("the newAccounts $accounts"); // Debugging step to check data

      // Update the state with the parsed data
      setState(() {
        remitterName = remitterData['name'] ?? '';
        mobileNumber = remitterData['mobile'] ?? '';
        emailAddress = remitterData['email'] ?? '';
         totalLimit = data['data']['contactData']['maxLimit'].toString() ?? '';
         remainingLimit = data['data']['contactData']['remainingLimit'].toString() ?? '';
        _accounts = accounts.map((account) {
          final accountData = json.decode(account['account_data']);
          return {
            'id': account['id'].toString(),
            'contact_id': account['contact_id'].toString(),
            'account_id': account['account_id'],
            'beneficiaryName': accountData['bank_account']['name'],
            'accountType': '', // You can update this if you have account type
            'accountNo': accountData['bank_account']['account'],
            'ifscCode': accountData['bank_account']['ifsc'],
            'bankName': accountData['bank_account']['bank_name'],
            'is_verified': account['is_verified'],
            'account_status': accountData['account_status'],
          };
        }).toList();
        _isLoading = false;
      });
    } else {
      print(
          "No userData found in SharedPreferences."); // Debugging step for missing data
      setState(() {
        _isLoading = false; // Data not found, update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(titleText: 'Fund Transfer',),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUserInfo(context),
              SizedBox(height: 20),
              Column(
                children: [
                  _buildHeader(),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ), // Adding a line after the header
                  ..._accounts.map((account) => _buildRow(
                      account['id'],
                      account['beneficiaryName'],
                      account['accountNo'],
                      account['ifscCode'],
                      account['bankName'])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildUserInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: Color.fromARGB(255, 238, 232, 232),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            remitterName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFC63F3F),
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          SizedBox(height: 5),
          Text(
            mobileNumber,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF616161),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              bool isSmallScreen = width < 600;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          totalLimit, // Different text for column 2
                          style: TextStyle(
                            color: Color(0xFF4D5DFA),
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Total Limit',
                          textAlign: isSmallScreen
                              ? TextAlign.center
                              : TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF616161),
                            fontSize: 10,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: -0.11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10), // Space between columns
                  // Column 3
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          remainingLimit, // Different text for column 3
                          style: TextStyle(
                            color: Color(0xFF4D5DFA),
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Remaining Limit',
                          textAlign: isSmallScreen
                              ? TextAlign.center
                              : TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF616161),
                            fontSize: 10,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: -0.11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              CustomEditButton(
                BorderRadius: BorderRadius.circular(5),
                text: 'Add Account',
                imagePath: 'assets/images/user-edit.png',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                             NewBeneficiaryFormScreen() ));
                  // showTransactionPopup(context);
                },
                color: Colors.green,
              ),
              CustomEditButton(
                BorderRadius: BorderRadius.circular(5),
                text:'LogOut User',
                imagePath: 'assets/images/Union.png',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                             FundTranferLoginFormScreen() ));
                },
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderCell("User Name"),
          _buildHeaderCell("Account  No."),
          _buildHeaderCell("IFSC Code"),
          _buildHeaderCell("Bank Name"),
          _buildHeaderCell("Actions"),
          _buildHeaderCell("Delete"), // Header for action column
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFFEB5757),
            fontSize: 11,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String id, String beneficiaryName, String accountNo,
      String ifscCode, String bankName) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCell(beneficiaryName),
                    _buildCell(accountNo),
                    _buildCell(ifscCode),
                    _buildCell(bankName),
                    // Action column with an icon
                    IconButton(
                      icon: Icon(
                        isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _deleteRow(id);
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomActionTextField(
                      hintText: 'Enter amount',
                      controller:
                          _amountController, // You need to define _amountController in your widget
                      borderColor: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CustomSmallTextButton(
                      BorderRadius: BorderRadius.circular(5),
                      text: 'IMPS',
                      onPressed: () {
                        _showTransactionConfirmationPopup(
                          id,
                          context,
                          'IMPS', mobileNumber
                        );
                        // showTransactionPopup(context);
                      },
                      color: Colors.green,
                    ),
                    CustomSmallTextButton(
                      BorderRadius: BorderRadius.circular(5),
                      text: 'NEFT',
                      onPressed: () {
                        _showTransactionConfirmationPopup(id, context, 'NEFT',mobileNumber);
                        //showTransactionPopup(context);
                      },
                      color: Colors.yellow,
                    ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }

  void showTransactionPopup(BuildContext context) {
    final _otpControllers =
        List<TextEditingController>.generate(4, (_) => TextEditingController());
    final _otpFocusNodes = List<FocusNode>.generate(4, (_) => FocusNode());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Container(
            width: 329,
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: ShapeDecoration(
              color: Color(0x19292D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Text(
                      'Transaction Description',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFC43F3E),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.09,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              // TransactionDetailRow(
              //     label: 'Account Number', value: accountNumber),
              // SizedBox(height: 10),
              // TransactionDetailRow(label: 'IFSC Code', value: ifscCode),
              // SizedBox(height: 10),
              // TransactionDetailRow(label: 'Beneficiary', value: beneficiary),
              // SizedBox(height: 10),
              // TransactionDetailRow(label: 'Bank Name', value: bankName),
              // SizedBox(height: 10),
              // TransactionDetailRow(
              //     label: 'Transaction Amount',
              //     value: '\u{20B9}$transactionAmount'),
              // SizedBox(height: 10),
              // TransactionDetailRow(label: 'Mode', value: mode),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                // Handle confirm action here
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                textStyle: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                // Handle cancel action here
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCell(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
  void _showTransactionConfirmationPopup(String id, BuildContext context,String transactionType, String mobileNumber) {
  final amount = _amountController.text;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Container(
              width: 329,
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: ShapeDecoration(
                color: Color(0x19292D32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  'Confirm Card Transaction',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC43F3E),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0.09,
                  ),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Are you sure you want to initiate this Card Transaction?'),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Yes', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                 // Navigator.pop(context); // Close the current dialog
                  try {
                    bool success =  await fundTransferService.TransactionDetailsSend(
                    id,
                    transactionType,
                    _amountController.text,
                    mobileNumber,
                    context,
                  );
                    print("the api response $success");
                  } catch (e) {
                    // Handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An error occurred'),
                      ),
                    );
                  }
                },
              ),
              ElevatedButton(
                child: Text('No', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context); // Handle cancel action here
                },
              ),
            ],
          );
        },
      );
    },
  );
}


  void _deleteRow(String id) {
    setState(() async {
      try {
        await fundTransferService.deleteBenficiary(id);
        // _showBillDialog(context);
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
          ),
        );
      }
      _accounts.removeWhere((account) => account['id'] == id);
    });
  }

  void _showOtpTransaction(BuildContext context) {
    final _otpControllers =
        List<TextEditingController>.generate(4, (_) => TextEditingController());
    final _otpFocusNodes = List<FocusNode>.generate(4, (_) => FocusNode());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(8.0),
          contentPadding: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: ShapeDecoration(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                'Enter OTP',
                style: TextStyle(
                  color: Color(0xFFC43F3E),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          content: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: 800,
              minWidth: 300,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: SizedBox(
                          width: 30,
                          height: 50,
                          child: TextFormField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.grey,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 1) {
                                  if (index < 5) {
                                    _otpFocusNodes[index + 1].requestFocus();
                                  } else {
                                    _otpFocusNodes[index].unfocus();
                                  }
                                } else if (value.isEmpty) {
                                  if (index > 0) {
                                    _otpFocusNodes[index - 1].requestFocus();
                                  }
                                }
                              },
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  if (_isLoading)
                    Center(
                        child:
                            CircularProgressIndicator()), // Show loading spinner
                  CustomNormalButton(
                    buttonText: 'OK',
                    onTap: () async {
                      String otpCode = _otpControllers
                          .map((controller) => controller.text)
                          .join();
                      setState(() {
                        _isLoading = true; // Set loading to true
                      });
                      await fundTransferService.otpPerformTransaction(
                          otpCode, context);
                      setState(() {
                        _isLoading = false; // Set loading to false
                      });

                      await Future.delayed(Duration(milliseconds: 500));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TransactionDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const TransactionDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
