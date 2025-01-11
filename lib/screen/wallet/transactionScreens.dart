import 'package:dotmik_app/api/walletService.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/notifiesClass/notifier.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:convert';

class MobileNumberScreen extends StatefulWidget {
  @override
  _MobileNumberScreenState createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final TextEditingController _mobileNumberController = TextEditingController();
  bool _isLoading = false;

Future<void> _hitMobileNumberApi(String mobileNumber) async {
  final Walletservice _service = Walletservice();

  setState(() {
    _isLoading = true;
  });

  try {
    // Fetch the response from the service
    final Map<String, dynamic>? response = await _service.fetchIndex(context, mobileNumber);
    print("the response $response");

    setState(() {
      _isLoading = false;
    });

    if (response != null && response.isNotEmpty) {
      // Check if status is SUCCESS
      if (response['status'] == 'SUCCESS') {
        // Extract walletToWalletKey
        final walletToWalletKey = response['data']['walletToWalletKey'];

        // Decode Base64
        final decodedBase64 = utf8.decode(base64Decode(walletToWalletKey));

        // Parse JSON string
        final walletData = jsonDecode(decodedBase64);

        print("Decoded wallet data: $walletData");

        await NotifierUtils.showSuccessPopup(
          context,
          'Mobile number verified successfully!',
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AmountScreen(
              mobileNumber: mobileNumber,
              walletData: walletData, // Pass decoded data
            ),
          ),
        );
      } else {
        NotifierUtils.showFailedPopup(
          context,
          'Failed to verify mobile number.',
        );
      }
    } else {
      NotifierUtils.showFailedPopup(
        context,
        'Failed to verify mobile number.',
      );
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    NotifierUtils.showFailedPopup(
      context,
      'An error occurred: $e',
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Wallet TO Wallet"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Mobile Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      final mobileNumber = _mobileNumberController.text.trim();
                      if (mobileNumber.isNotEmpty) {
                        _hitMobileNumberApi(mobileNumber);
                      } else {
                        NotifierUtils.showSnackBar(
                          context,
                          'Please enter a valid mobile number',
                          isError: true,
                        );
                      }
                    },
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Fetch User', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}


class AmountScreen extends StatefulWidget {
  final String mobileNumber;
  final Map<String, dynamic> walletData; // Add walletData parameter

  AmountScreen({required this.mobileNumber, required this.walletData}); // Update constructor

  @override
  _AmountScreenState createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;

  Future<void> _hitAmountApi(BuildContext context, String amount) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final walletService = Walletservice();

    try {
      final response = await walletService.transactionTransfer(
        context,
        widget.mobileNumber,
        amount,
        _pinController.text,
      );

      if (response != null && response['status'] == 'SUCCESS') {
        NotifierUtils.showSuccessPopup(
          context,
          'Transaction successful!',
        );
      } else {
        NotifierUtils.showFailedPopup(
          context,
          'Failed to complete transaction.',
        );
      }
    } catch (e) {
      NotifierUtils.showFailedPopup(
        context,
        'An error occurred: $e',
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Enter Amount"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Details Row
            Row(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      widget.walletData['profile'] ?? 'https://example.com/user-profile-image'), // Use decoded profile URL
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.walletData['name'] ?? 'Lalit Yadav', // Use decoded name
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.check_circle,
                          color: Colors.blue, // Verified checkmark icon
                          size: 16,
                        ),
                      ],
                    ),
                    Text(
                      widget.walletData['userId'] ?? 'DOTMIK160615', // Use decoded user ID
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.mobileNumber, // Display the mobile number passed
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),

            // Amount, Remark, PIN input fields in a row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.red.withOpacity(0.01),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _remarkController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Remark',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.red.withOpacity(0.01),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter PIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.red.withOpacity(0.01),
              ),
            ),
            SizedBox(height: 20),

            // Pay Now button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      final amount = _amountController.text.trim();
                      if (amount.isNotEmpty) {
                        _hitAmountApi(context, amount);
                      } else {
                        NotifierUtils.showSnackBar(
                          context,
                          'Please enter a valid amount',
                          isError: true,
                        );
                      }
                    },
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Pay Now', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}



// class PinScreen extends StatefulWidget {
//   final String mobileNumber;
//   final String amount;

//   PinScreen({required this.mobileNumber, required this.amount});

//   @override
//   _PinScreenState createState() => _PinScreenState();
// }

// class _PinScreenState extends State<PinScreen> {
//   final TextEditingController _pinController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _handleSubmit() async {
//     final pin = _pinController.text.trim();

//     if (pin.length == 4) {
//       setState(() {
//         _isLoading = true;
//       });

//       final walletService = Walletservice();

//       try {
//         final response = await walletService.transactionTransfer(
//           context,
//           widget.mobileNumber,
//           widget.amount,
//           pin,
//         );

//         if (response != null && response['status'] == 'SUCCESS') {
//           NotifierUtils.showSuccessPopup(
//             context,
//             'PIN submitted successfully!',
//           );
//         } else {
//           NotifierUtils.showFailedPopup(
//             context,
//             'Failed to verify PIN.',
//           );
//         }
//       } catch (e) {
//         NotifierUtils.showFailedPopup(
//           context,
//           'An error occurred: $e',
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } else {
//       NotifierUtils.showSnackBar(
//         context,
//         'Please enter a valid 4-digit PIN',
//         isError: true,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter 4-Digit PIN'),
//         centerTitle: true,
//         backgroundColor: Colors.red,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Enter the 4-digit PIN for mobile number:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: 8),
//             Text(
//               widget.mobileNumber,
//               style: TextStyle(fontSize: 16, color: Colors.red),
//             ),
//             SizedBox(height: 24),
//             PinCodeTextField(
//               appContext: context,
//               length: 4,
//               obscureText: true,
//               animationType: AnimationType.fade,
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(12),
//                 fieldHeight: 50,
//                 fieldWidth: 50,
//                 activeFillColor: Colors.red.withOpacity(0.1),
//                 inactiveFillColor: Colors.red.withOpacity(0.05),
//                 selectedFillColor: Colors.red.withOpacity(0.2),
//               ),
//               animationDuration: Duration(milliseconds: 300),
//               backgroundColor: Colors.transparent,
//               enableActiveFill: true,
//               controller: _pinController,
//               onCompleted: (pin) {
//                 // The PIN will be submitted when the user completes the input
//                 _handleSubmit();
//               },
//               onChanged: (value) {},
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: _isLoading ? null : _handleSubmit,
//               child: _isLoading
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : Text('Submit', style: TextStyle(fontSize: 18)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
