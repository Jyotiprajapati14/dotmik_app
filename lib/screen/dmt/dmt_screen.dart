import 'dart:convert';

import 'package:dotmik_app/api/dmtService.dart';
import 'package:dotmik_app/screen/dmt/newAccountAdd.dart';
import 'package:dotmik_app/screen/dmt/remitterlogin_screen.dart';
import 'package:dotmik_app/screen/fundtransfer/transactionReceipt_screen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DmtScreen extends StatefulWidget {
  final bool shouldFetchData;

  DmtScreen({required this.shouldFetchData});

  @override
  _DmtScreenState createState() => _DmtScreenState();
}

class _DmtScreenState extends State<DmtScreen> {
  late DmtService _dmtService;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = true;

  // Define fields to store user details
  String remitterName = '';
  String remitterKey = '';
  String mobileNumber = '';
  String totalLimit = '';
  String remainingLimit = '';
  String limitPerTransaction = '';
  List<Map<String, dynamic>> _accounts = [];

  @override
  void initState() {
    super.initState();
    _dmtService = DmtService();
    if (widget.shouldFetchData) {
      _fetchData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    if (userData != null) {
      final Map<String, dynamic> data = json.decode(userData);
      final remitterData = data['data']['remitterData'];
      final accounts =
          List<Map<String, dynamic>>.from(remitterData['accounts'] ?? []);

      setState(() {
        remitterName = remitterData['remitter'] ?? '';
        remitterKey = remitterData['remitter_key'] ?? '';
        mobileNumber = remitterData['mobile'] ?? '';
        totalLimit = remitterData['totalLimit'] ?? '';
        remainingLimit = remitterData['remainingLimit'] ?? '';
        limitPerTransaction = remitterData['limitPerTransaction'] ?? '';
        _accounts = accounts;
      });
    } else {
      print(
          "No userData found in SharedPreferences."); // Debugging step for missing data
    }
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    await _dmtService.fetchBankAccounts(context);

    setState(() {
      _isLoading = false;
    });
  }

  final String accountNumber = '1234567890';
  final String ifscCode = 'IFSC1234';
  final String beneficiary = 'John Doe';
  final String bankName = 'ABC Bank';
  final double transactionAmount = 1234.56;
  final String mode = 'Online Transfer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Domestic Money Transfer',
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isSmallScreen = constraints.maxWidth < 600;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUserInfo(context, isSmallScreen),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            _buildHeader(),
                            Divider(height: 1, color: Colors.black),
                            Divider(height: 1, color: Colors.black),
                            ..._accounts.map((account) {
                              return _buildRow(
                                  account['account_id'].toString() ?? '',
                                  account['account'] ?? '',
                                  account['name'] ?? '',
                                  account['ifsc'] ?? '',
                                  account['bank'] ?? '');
                            }).toList(),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildUserInfo(BuildContext context, bool isSmallScreen) {
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
              fontSize: 18,
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
              fontSize: 12,
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
                  // Column 1
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          limitPerTransaction,
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
                          'Limit Per Transactions', // Change text for column 1
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
                  // Column 2
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
                              NewAccountRegisterFormScreen()));
                  // showTransactionPopup(context);
                },
                color: Colors.green,
              ),
              CustomEditButton(
                BorderRadius: BorderRadius.circular(5),
                text: 'Logout User',
                imagePath: 'assets/images/Union.png',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DmtLoginFormScreen()));
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
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderCell("Account\nNo."),
          _buildHeaderCell("User\nName"),
          _buildHeaderCell("IFSC Code"),
          _buildHeaderCell("Bank\nName"),
          _buildHeaderCell("Actions"),
          _buildHeaderCell("Delete"),
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
                            id, context, 'IMPS', mobileNumber);
                        // showTransactionPopup(context);
                      },
                      color: Colors.green,
                    ),
                    CustomSmallTextButton(
                      BorderRadius: BorderRadius.circular(5),
                      text: 'NEFT',
                      onPressed: () {
                        _showTransactionConfirmationPopup(
                            id, context, 'NEFT', mobileNumber);
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

  void showTransactionPopup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionDataJson = prefs.getString('transactionData');

    if (transactionDataJson != null) {
      final transactionData = jsonDecode(transactionDataJson);
      final bodyData = transactionData['data']['dmtReceiptData']['bodyData'];
      final buttonData =
          transactionData['data']['dmtReceiptData']['buttonData'][0];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(
              'Transaction Description',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFC43F3E),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                TransactionDetailRow(
                    label: 'Account Number', value: bodyData['A/c Number']),
                SizedBox(height: 10),
                TransactionDetailRow(
                    label: 'IFSC Code', value: bodyData['IFSC Code']),
                SizedBox(height: 10),
                TransactionDetailRow(
                    label: 'Beneficiary', value: bodyData['A/c Holder']),
                SizedBox(height: 10),
                TransactionDetailRow(
                    label: 'Bank Name', value: 'Bank Name Placeholder'),
                SizedBox(height: 10),
                Container(
                  width: 297,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFF292D32),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TransactionDetailRow(label: 'Mode', value: bodyData['Mode']),
                SizedBox(height: 10),
                TransactionDetailRow(
                    label: 'Date & Time', value: bodyData['Date & Time']),
                SizedBox(height: 10),
                TransactionDetailRow(
                    label: 'Reference No.', value: buttonData['user_ref']),
                SizedBox(height: 10),
                TransactionDetailRow(label: 'UTR', value: buttonData['utr']),
                SizedBox(height: 10),
                TransactionDetailRow(
                    label: 'Status', value: buttonData['status']),
                SizedBox(height: 20),
                Center(
                  child: CustomEditButton(
                    text: 'Proceed',
                    imagePath: '',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionReceiptScreen(
                            phoneNumber: bodyData['Phone'],
                            accountNumber: bodyData['A/c Number'],
                            ifscCode: bodyData['IFSC Code'],
                            mode: bodyData['Mode'],
                            accountHolder: bodyData['A/c Holder'],
                            dateTime: DateTime.parse(bodyData['Date & Time']),
                            referenceNumber: buttonData['user_ref'],
                            utr: buttonData['utr'],
                            status: buttonData['status'],
                            availableAmount: 10000.00, // Adjust as needed
                          ),
                        ),
                      );
                    },
                    color: Colors.red,
                    BorderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      print('No transaction data found in SharedPreferences');
    }
  }

  void _showTransactionConfirmationPopup(String id, BuildContext context,
      String transactionType, String mobileNumber) {
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
                  Text(
                      'Are you sure you want to initiate this Card Transaction?'),
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
                      bool success = await _dmtService.TransactionDetailsSend(
                        id,
                        remitterKey,
                        transactionType,
                        _amountController.text,
                        context,
                      );
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
        await _dmtService.deleteBenficiary(id, context);
        //_showBillDialog(context);
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
                      await _dmtService.otpPerformTransaction(otpCode, context);
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

  TransactionDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF292D32),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF292D32),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
