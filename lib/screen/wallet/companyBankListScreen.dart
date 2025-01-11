import 'package:dotmik_app/api/walletService.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyBanksScreen extends StatelessWidget {
  final List<dynamic> banks;

  CompanyBanksScreen({required this.banks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Company Banks"),
      body: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) {
          final bank = banks[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    bank['logo'] != null
                  ? Center(
                    child: Image.network(bank['logo'],
                      width: 150, height: 60, fit: BoxFit.fill),
                  )
                  : Center(child: Icon(Icons.account_balance, size: 50)),
                  SizedBox(height: 10,),
                  Text(bank['bank_name'] ?? 'No Name' , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  Text('Account: ${bank['account'] ?? 'No Account'}'),
                  Text('IFSC: ${bank['ifsc'] ?? 'No IFSC'}'),
                  Text('Account Holder: ${bank['account_holder'] ?? 'No Account Holder'}'),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RaiseFundRequestScreen(
                      bankId: bank['id'].toString(),
                      bankDetails: bank,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class RaiseFundRequestScreen extends StatefulWidget {
  final String bankId;
  final Map<String, dynamic> bankDetails;

  RaiseFundRequestScreen({required this.bankId, required this.bankDetails});

  @override
  _RaiseFundRequestScreenState createState() => _RaiseFundRequestScreenState();
}

class _RaiseFundRequestScreenState extends State<RaiseFundRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _modeController = TextEditingController();
  final _remarkController = TextEditingController();
  final _utrController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final Walletservice _walletservice = Walletservice();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Raise Fund Request"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBankDetails(widget.bankDetails),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      'Amount',
                      _amountController,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter amount',
                    ),
                    SizedBox(height: 16),
                    _buildDateField(
                      'Date',
                      _dateController,
                      () => _selectDate(context),
                    ),
                    SizedBox(height: 16),
                    _buildModeField('Mode'),
                    SizedBox(height: 16),
                    _buildTextField(
                      'Remark',
                      _remarkController,
                      maxLines: 2,
                      hintText: 'Enter any remarks',
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      'UTR',
                      _utrController,
                      maxLength: 40,
                      hintText: 'Enter UTR number',
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _walletservice.fundRequestFormData(
                              context: context,
                              amount: _amountController.text,
                              bankId: widget.bankId,
                              date: _dateController.text,
                              mode: _modeController.text,
                              remark: _remarkController.text,
                              utr: _utrController.text,
                            );
                            // Handle form submission
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Submit Request',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankDetails(Map<String, dynamic> bank) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Margin around the card
    elevation: 6, // Elevation for shadow effect
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners for the card
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0), // Padding inside the card
      child: Column(
        children: [
          // Bank logo or default icon
          bank['logo'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Rounded corners for the logo
                  child: Image.network(
                    bank['logo'],
                    width: 150,
                    height: 80,
                    fit: BoxFit.fill, // Cover the image space while maintaining aspect ratio
                  ),
                )
              : Icon(
                  Icons.account_balance_outlined, 
                  size: 60, 
                  color: Colors.blueGrey,
                ),
          SizedBox(height: 10), // Space between image/icon and text
          Divider(thickness: 1, color: Colors.grey.shade300), // Divider for visual separation
          SizedBox(height: 10),
          // Bank details text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bank['bank_name'] ?? 'No Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Account: ${bank['account'] ?? 'No Account'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'IFSC: ${bank['ifsc'] ?? 'No IFSC'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Account Holder: ${bank['account_holder'] ?? 'No Account Holder'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    ),
  );
}


  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int? maxLines,
    int? maxLength,
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      ),
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Select date',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildModeField(String label) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      ),
      items: ['IMPS', 'NEFT', 'RTGS', 'CASH', 'CDM', 'UPI'].map((mode) {
        return DropdownMenuItem(
          value: mode,
          child: Text(mode),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _modeController.text = value ?? '';
        });
      },
      value: _modeController.text.isEmpty ? null : _modeController.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }
}
