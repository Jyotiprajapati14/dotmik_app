import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';
import 'package:dotmik_app/api/DthService.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:dotmik_app/utils/textstyles/customCard.dart';

class RechargeDthScreen extends StatefulWidget {
  const RechargeDthScreen({super.key});

  @override
  _RechargeDthScreenState createState() => _RechargeDthScreenState();
}

class _RechargeDthScreenState extends State<RechargeDthScreen> {
  String dthNumber = '';
  String amount = '';
  String selectedOperatorCode = '';
  bool isLoading = true;
  List<CustomCard> items = [];
  DthService service = DthService();
  List<String> operatorList = []; // List to hold operator names
  String? selectedOperator;
  bool isFetchingOperator = false;

  @override
  void initState() {
    super.initState();
    _fetchRechargeDetails();
  }

  Future<void> _fetchRechargeDetails() async {
    try {
      final details = await service.getDetails();
      if (details['status'] == 'SUCCESS') {
        final rechargeOperators =
            details['data']['dthRechargeOperators'] as List;
        setState(() {
          items = rechargeOperators.map((operator) {
            return CustomCard(
              imageUrl: "",
              text: operator['operator'],
              operatorId: operator['id'],
              operatorCode: operator['operator_code'].toString(),
            );
          }).toList();

          // Populate the operatorList for the dropdown
          operatorList = rechargeOperators.map((operator) {
            return operator['operator'] as String;
          }).toList();

          isLoading = false;
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
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all fields"),
      ));
      return;
    }

    try {
      await service.TransactionDetailsSend(
          amount, dthNumber, selectedOperatorCode, context);

      // Show OTP dialog on successful transaction initiation
      _showOtpTransaction(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
          titlePadding: const EdgeInsets.all(8.0),
          contentPadding: const EdgeInsets.all(8.0),
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
            child: const Center(
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
            constraints: const BoxConstraints(
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
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                              style: const TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const Center(
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
                      await service.otpPerformTransaction(otpCode, context);
                      setState(() {
                        _isLoading = false; // Set loading to false
                      });

                      await Future.delayed(const Duration(milliseconds: 500));
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
      appBar: const CustomAppBar(
        titleText: 'Dth Recharge',
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    width: 351,
                    height: 33,
                    child: Text(
                      'DTH Recharge',
                      style: TextStyle(
                        color: Color(0xFFC63F3F),
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _buildTextField(
                    label: 'Phone Number',
                    hintText: 'Enter phone Number',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        dthNumber = value;
                        // isPhoneNumberValid = value.length == 10;
                      });
                      // if (value.length == 10) {
                      //   _fetchOperatorDetails(value);
                      // }
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedOperator,
                    decoration: InputDecoration(
                      labelText: 'Select Operator',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    hint: const Text('Select Operator'),
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

                  const SizedBox(height: 20.0),
                  const Text(
                    'Enter Amount',
                    style: TextStyle(
                      color: Color(0xFFC63F3F),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: '',
                    hintText: 'Enter Amount',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        amount = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: CustomTextButton(
                      text: "Recharge",
                      onPressed: _initiateTransaction,
                      color: Colors.red,
                      BorderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF263238),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 6.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            keyboardType: keyboardType,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
