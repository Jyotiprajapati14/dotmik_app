import 'package:dotmik_app/api/creditCardService.dart';
import 'package:dotmik_app/api/dmtService.dart';
import 'package:dotmik_app/api/fundTranferService.dart';
import 'package:dotmik_app/screen/CreditCardBillPayment/transactionDetailScreen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';

class OtpCreditCardScreen extends StatefulWidget {
  final String cardNumber;
  final String name;
  final String amount;
  final String transactionKey;
  final String transactionType; // 'creditCard' or 'fundTransfer'

  OtpCreditCardScreen({
    required this.cardNumber,
    required this.name,
    required this.amount,
    required this.transactionKey,
    required this.transactionType,
  });

  @override
  _OtpCreditCardScreenState createState() => _OtpCreditCardScreenState();
}

class _OtpCreditCardScreenState extends State<OtpCreditCardScreen> {
  final List<TextEditingController> _otpControllers =
      List<TextEditingController>.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List<FocusNode>.generate(4, (_) => FocusNode());

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(titleText: "OTP"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Display transaction details
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Number: ${widget.cardNumber}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Name: ${widget.name}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Transaction Amount: ${widget.amount}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              // OTP Input Fields
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: screenWidth / 5,
                      height: 60,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          // Border when the field is not focused
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          // Border when the field is focused
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFFC43F3E), width: 2),
                          ),
                          // Border when the field has an error
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          // Border when the field is focused and has an error
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            if (index < 3) {
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
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
        bottomNavigationBar: _isLoading
            ? Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _submitOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC43F3E),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _submitOtp() async {
    setState(() {
      _isLoading = true;
    });

    // Combine the OTP input from all controllers
    final otpCode = _otpControllers.map((controller) => controller.text).join();
    Map<String, dynamic>? response;

    // Check the transaction type and call the corresponding service
    if (widget.transactionType == 'creditCard') {
      CreditCardService _cardService = CreditCardService();
      response = await _cardService.otpPerformTransaction(otpCode, context);
    } else if (widget.transactionType == 'fundTransfer') {
      FundTransferService _fundService = FundTransferService();
      response = await _fundService.otpPerformTransaction(otpCode, context);
    } else if (widget.transactionType == 'Dmt') {
      DmtService _dmtService = DmtService();
      response = await _dmtService.otpPerformTransaction(otpCode, context);
    } else {
      print("Unknown transaction type: ${widget.transactionType}");
    }

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TransactionDetailsScreen(transactionData: response!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction failed. Please try again.')),
      );
    }
  }
}
