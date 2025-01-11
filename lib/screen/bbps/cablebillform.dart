import 'package:dotmik_app/screen/home/dthrecharge/receipt_screen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/customAppBar.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CableBillsFormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<CableBillsFormScreen> {
  String bankAccount = '';
  String transactionId = '';
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  String modeOfTransaction = '';
  String selectedBank = '';

  final List<String> bankNames = ['Bank A', 'Bank B', 'Bank C', 'Bank D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Cable Bill',),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 351,
              height: 33,
              child: Text(
                'Pay Your Cable Bill',
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
            _buildBankDropdown("Select Biller Category"),
            SizedBox(height: 10.0),
            _buildBankDropdown("Select Bill"),
            SizedBox(height: 10.0),
            _buildTextField(
              label: 'K Number',
              hintText: 'Enter K Number',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0.0;
                });
              },
              maxLength: 25
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              label: 'Mobile Number',
              hintText: 'Enter Mobile Number',
              onChanged: (value) {
                setState(() {
                  transactionId = value;
                });
              },
              maxLength: 10
            ),
            SizedBox(height: 20.0),
            CustomImageButton(
              text: 'Fetch Bill',
              imagePath: 'assets/intro/chevron-right.png',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CableBillDetailScreen()));
              },
              color: Colors.red,
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
    required ValueChanged<String> onChanged, required int maxLength,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Color(0xFF263238),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 6.0),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            counterText: "",  // Hide the character counter
          ),
            keyboardType: keyboardType,
            onChanged: onChanged,
          maxLength: maxLength,  // Apply the maximum length
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength ?? 100),  // Default to 100 if maxLength is null
          ],
        ),
      ),
    ],
  );
}
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            color: Color(0xFF263238),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Selected Date: ${selectedDate.toString().substring(0, 10)}',
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate)
                    setState(() {
                      selectedDate = pickedDate;
                    });
                },
                child: Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankDropdown(text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Color(0xFF263238),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedBank.isEmpty ? null : selectedBank,
              hint: Text(text),
              isExpanded: true,
              items: bankNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedBank = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CableBillDetailScreen extends StatefulWidget {
  @override
  _BillDetailsScreenState createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<CableBillDetailScreen> {
  DateTime selectedDate = DateTime.now();
  double amount = 150.00;
  double payableAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Cable Bill',),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Pay Your Cable Bill',
                style: TextStyle(
                  color: Color(0xFFC63F3F),
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 358,
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
                            'Bill Details',
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
              ),
              SizedBox(
                height: 20,
              ),
              BillDetailRow(label: 'Bill Number', value: '123456'),
              SizedBox(height: 10),
              BillDetailRow(
                label: 'Bill Date',
                value: selectedDate.toString().substring(0, 10),
              ),
              SizedBox(height: 10),
              BillDetailRow(
                label: 'Due Date',
                value: selectedDate
                    .add(Duration(days: 30))
                    .toString()
                    .substring(0, 10),
              ),
              SizedBox(height: 10),
              BillDetailRow(label: 'Consumer Name', value: 'John Doe'),
              SizedBox(height: 10),
              BillDetailRow(
                label: 'Bill Amount',
                value: '${amount.toStringAsFixed(2)}',
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.attach_money),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    payableAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showBillDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pay',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/intro/chevron-right.png',
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBillDialog(BuildContext context) {
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
                      'Enter M Pin',
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
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 42,
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
                              fillColor: Color(0x19292D32),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
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
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: CustomEditButton(
                      text: 'Pay',
                      imagePath: 'assets/intro/chevron-right.png',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DTHTransactionReceiptScreen(
                                        amount: "310",
                                        paymentStatus: "online",
                                        txnId: "234534343",
                                        paymentType: '',
                                        paymentMethod: '',
                                        operatorName: "Vidhi Sharma")));
                        // Handle button press
                      },
                      color: Colors.red,
                      BorderRadius: BorderRadius.circular(15),
                    ),
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

class BillDetailRow extends StatelessWidget {
  final String label;
  final String value;

  BillDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
