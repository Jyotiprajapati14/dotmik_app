import 'package:dotmik_app/api/mobileService.dart';
import 'package:dotmik_app/screen/home/moneyTransfer/PlanScreen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:dotmik_app/utils/textstyles/customCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RechargePrepaidMobileScreen extends StatefulWidget {
  final String Amount;
  final String Operator;
  final String phoneNumber;

  RechargePrepaidMobileScreen(
      {required this.Amount,
      required this.Operator,
      required this.phoneNumber});

  @override
  _RechargePrepaidMobileScreenState createState() =>
      _RechargePrepaidMobileScreenState();
}

class _RechargePrepaidMobileScreenState extends State<RechargePrepaidMobileScreen> {
  bool isPhoneNumberValid = false;
  String dthNumber = '';
  String amount = '';
  String selectedOperatorCode = '';
  bool isLoading = true;
  bool isFetchingOperator = false;
  String operatorName = '';
  List<CustomCard> items = [];
  MobileService service = MobileService();
  List<String> operatorList = [];
  String? selectedOperator;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amount = widget.Amount;
    dthNumber = widget.phoneNumber;
    operatorName = widget.Operator;
    amountController.text = amount;
    phoneNumberController.text = dthNumber;

    if (dthNumber.isNotEmpty) {
      isPhoneNumberValid = dthNumber.length == 10;
      if (isPhoneNumberValid) {
        _fetchOperatorDetails(dthNumber);
      }
    }

    _fetchRechargeDetails();
  }

  Future<void> _fetchOperatorDetails(String mobile) async {
    setState(() {
      isFetchingOperator = true;
    });

    final isSuccess = await service.getOperator(mobile, context);

    if (isSuccess) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedOperator = prefs.getString('Operator');
      String? savedCircle = prefs.getString('Circle');

      setState(() {
        operatorName = savedOperator ?? '';
        selectedOperatorCode = savedCircle ?? '';
        isFetchingOperator = false;
        operatorList = items.map((item) => item.text).toList();
        selectedOperator =
            operatorList.contains(operatorName) ? operatorName : null;
      });
    } else {
      setState(() {
        operatorName = '';
        selectedOperatorCode = '';
        isFetchingOperator = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Operator not found"),
      ));
    }
  }

  Future<void> _fetchRechargeDetails() async {
    try {
      final details = await service.getDetails();
      if (details['status'] == 'SUCCESS') {
        final rechargeOperators = details['data']['rechargeOperators'] as List;
        setState(() {
          items = rechargeOperators.map((operator) {
            return CustomCard(
              imageUrl: "",
              text: operator['operator'],
              operatorId: operator['id'],
              operatorCode: operator['operator_code'].toString(),
            );
          }).toList();
          isLoading = false;
          operatorList = items.map((item) => item.text).toList();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to fetch details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initiateTransaction() async {
    if (dthNumber.isEmpty || amount.isEmpty || selectedOperatorCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill all fields"),
      ));
      return;
    }

    try {
      await service.TransactionDetailsSend(
          amount, dthNumber, selectedOperatorCode, context);

      _showOtpTransaction(context);
    } catch (e) {
      print('Transaction initiation failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Transaction initiation failed"),
      ));
    }
  }

  void _showOtpTransaction(BuildContext context) {
    bool _isLoading = false;
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
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  if (_isLoading) Center(child: CircularProgressIndicator()),
                  CustomNormalButton(
                    buttonText: 'OK',
                    onTap: () async {
                      String otpCode = _otpControllers
                          .map((controller) => controller.text)
                          .join();
                      setState(() {
                        _isLoading = true;
                      });
                      await service.otpPerformTransaction(otpCode, context);
                      setState(() {
                        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Mobile Recharge'),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: 351,
                    height: 33,
                    child: Text(
                      'Mobile Recharge',
                      style: TextStyle(
                        color: Color(0xFFC63F3F),
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  _buildTextField(
                    controller: phoneNumberController,
                    label: 'Phone Number',
                    hintText: 'Enter phone Number',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        dthNumber = value;
                        isPhoneNumberValid = value.length == 10;
                      });
                      if (value.length == 10) {
                        _fetchOperatorDetails(value);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  if (isFetchingOperator)
                    Center(child: CircularProgressIndicator()),
                  if (isPhoneNumberValid)
                    DropdownButtonFormField<String>(
                      value: selectedOperator,
                      decoration: InputDecoration(
                        labelText: 'Operator',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      hint: Text('$operatorName'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOperator = newValue;
                          selectedOperatorCode = items
                              .firstWhere(
                                (item) => item.text == newValue,
                              )
                              .operatorCode;
                        });
                      },
                      items: operatorList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  else if (operatorList.isNotEmpty)
                    DropdownButtonFormField<String>(
                      value: selectedOperator,
                      decoration: InputDecoration(
                        labelText: 'Select Operator',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      hint: Text('Select Operator'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOperator = newValue;
                          selectedOperatorCode = items
                              .firstWhere(
                                (item) => item.text == newValue,
                              )
                              .operatorCode;
                        });
                      },
                      items: operatorList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: amountController,
                    label: 'Amount',
                    hintText: 'Enter Amount',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        amount = value;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  if (operatorName.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlansPage(
                              operatorName: operatorName,
                              selectedOperatorCode: selectedOperatorCode,
                              phoneNumber: dthNumber,
                            ),
                          ),
                        );
                      },
                      child: Text('Show Plans'),
                    ),
                  SizedBox(height: 20),
                  CustomNormalButton(
                    buttonText: 'Recharge Now',
                    onTap: _initiateTransaction,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextInputType keyboardType,
    required ValueChanged<String> onChanged,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }
}
