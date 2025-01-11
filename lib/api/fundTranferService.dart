import 'dart:convert';
import 'package:dotmik_app/helper/helper.dart';
import 'package:dotmik_app/screen/CreditCardBillPayment/otpScreen.dart';
import 'package:dotmik_app/screen/dmt/dmt_screen.dart';
import 'package:dotmik_app/screen/fundtransfer/fundTransfer_screen.dart';
import 'package:dotmik_app/screen/fundtransfer/registerUser_screen.dart';
import 'package:dotmik_app/utils/notifiesClass/notifier.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FundTransferService {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

  Future<void> check_contact(BuildContext context, String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/fund-transfer/check-contact');
    var request = http.MultipartRequest('POST', url);

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'mobile': mobile,
    });

    try {
      http.StreamedResponse response = await request.send();

      // Read and decode the response body
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        String status = data['status'] ?? '';
        String contact_key = data['contact_key'] ?? '';
        await prefs.setString('contact_key', contact_key);
        getDetails(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${data['message']}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during registration.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

////////////-------Verify Otp-------/////////////////////
  Future<void> otpverify(
    String otp,
    BuildContext context, // Add BuildContext to use for navigation
  ) async {
    final url = Uri.parse('$baseUrl/fund-transfer/verify-register');
    var request = http.MultipartRequest('POST', url);

    // Add headers if token and auth key are available
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? registerReference =
        prefs.getString('remitterRegisterReference'); // Use correct key

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'otp': otp,
      'key': registerReference ??
          '', // Use reference if available, otherwise an empty string
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        // Check if the response status is SUCCESS
        if (data['status'] == 'SUCCESS') {
          // Navigate to the FundTransferScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FundTransferScreen(shouldFetchData: false,), // Replace with your actual screen
            ),
          );
        } else {
          // Handle other statuses or errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${data['message']}'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        final responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred during verification.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during verification.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

////////////--------Contact  Index-----////////////////////

  Future<Map<String, dynamic>> getDetails(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? contact_key = prefs.getString('contact_key');

    if (contact_key == null) {
      throw Exception('Contact key is null');
    }

    final url = Uri.parse('$baseUrl/fund-transfer/index/$contact_key');
    try {
      final response = await http.get(
        url,
        headers: {
          'token': token ?? '',
          'key': authKey ?? '',
        },
      );
      final responseBody = response.body;
      final data = json.decode(responseBody) as Map<String, dynamic>;
      await prefs.setString('userFundDetails', responseBody);
      String? Data = prefs.getString('userFundDetails');
      if (response.statusCode == 200) {
        if (data['status'] == 'SUCCESS') {
          NotifierUtils.showSuccessPopup(context, 'Details fetched successfully!');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => FundTransferScreen(shouldFetchData: true)), // Navigate to the credit card screen
          );
        } else if (data['status'] == "REGISTER") {
          NotifierUtils.showFailedPopup(context, 'Please register first.');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => RegisterFundFormScreen()), // Navigate to the registration screen
          );
        } else {
          NotifierUtils.showFailedPopup(context, 'Failed to fetch details. Status: ${data['status']}');
          throw Exception('Failed with status: ${data['status']}');
        }
        return data;
      } else {
        NotifierUtils.showFailedPopup(context, 'Failed with status code: ${response.statusCode}');
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      NotifierUtils.showFailedPopup(context, 'Failed to fetch details: $e');
      throw Exception('Failed to fetch details: $e');
    }
  }
/////////--------------Remitter Register---------//////////////////////////

  Future<void> FundTransferRegister(String mobile, String email, String name,
      String address, String pinCode, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/fund-transfer/register');
    var request = http.MultipartRequest('POST', url);

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'mobile': mobile,
      'email': email,
      'name': name,
      'address': address,
      'pincode': pinCode,
    });

    try {
      http.StreamedResponse response = await request.send();
      // Read and decode the response body
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        // Check for status in response data
        if (data['status'] == 'SUCCESS' || data['status'] == 'CREATED') {
          // Correctly access the 'create_contact_key' from the response
          String registerReference = data['create_contact_key'] ?? '';
          await prefs.setString('registerReference', registerReference);
          // Navigate to the FundTransferScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FundTransferScreen(shouldFetchData:false,), // Replace with your actual screen
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: ${data['message']}'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred during registration.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during registration.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> NewAccountAdd(String name, String account, String ifsc,
      String bank ,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ContactKey = prefs.getString('contact_key');
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/fund-transfer/addBeneficiary');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'name': name,
      'account': account,
      'ifsc': ifsc,
      'bank_name': bank,
      'accountKey': '$ContactKey',
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      String remitterBeneficiaryReference =
          data['add_beneficiary_reference'] ?? '';
      await prefs.setString(
          'remitterBeneficiaryReference', remitterBeneficiaryReference);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DmtScreen(shouldFetchData: false)));
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }
////////////////-----------Delete Beneficiary--------/////////

  Future<void> deleteBenficiary(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/fund-transfer/deleteBeneficiary');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'id': id,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }

///////////////-----------Prform Transaction----------/////////////

Future<Map<String, dynamic>?> otpPerformTransaction(String otp, BuildContext context) async {
  Helper helper = Helper();
  final url = Uri.parse('$baseUrl/fund-transfer/performTransaction');
  var request = http.MultipartRequest('POST', url);

  // Add headers if token and auth key are available
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? authKey = prefs.getString('Authkey');
  String? initiateTransactionKey = prefs.getString('initiateFundTransactionKey');
  if (token != null && authKey != null) {
    request.headers['token'] = token;
    request.headers['key'] = authKey;
  }


  request.fields.addAll({
    'otp': otp,
    'key': '$initiateTransactionKey',
  });

  try {
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      if (data['status'] == 'success') {
        await NotifierUtils.showSuccessPopup(context, "Transaction Successful");
      } else {
        await NotifierUtils.showFailedPopup(context, data['message'] ?? "Transaction Failed");
      }
      return data; // Return the response data
    } else {
      final responseBody = await response.stream.bytesToString();
      await NotifierUtils.showFailedPopup(context, "Transaction failed with status: ${response.statusCode}");
      return null; // Return null if the transaction failed
    }
  } catch (e) {
    await NotifierUtils.showFailedPopup(context, "An unexpected error occurred. Please try again.");
    return null;
  }
}


////////----------Transaction--------//////////


Future<bool> TransactionDetailsSend(String id, String mode, String amount,
      String phone ,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/fund-transfer/initiateTransaction');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'id': id,
      'mode': mode,
      'amount': amount,
      'phone': phone,
    });

    try {
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (data['status'] == 'SUCCESS') {
        String initiateTransactionKey = data['initiate_transaction_key'] ?? '';
        await prefs.setString(
            'initiateFundTransactionKey', initiateTransactionKey);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpCreditCardScreen(
              cardNumber: data['data']['initiateTransaction']
                      ['Account Number'] ??
                  '',
              name: data['data']['initiateTransaction']['Beneficiary'] ?? '',
              amount: data['data']['initiateTransaction']
                      ['Transaction Amt.'] ??
                  '',
              transactionKey: initiateTransactionKey, transactionType: 'Fund Transfer',
            ),
          ),
        );

        return true;
      } else {
        // Show error message in case of failed response
        final errorMessage =
            data['message'] ?? 'Transaction failed. Please try again.';
        NotifierUtils.showSnackBar(context, errorMessage, isError: true);
        return false;
      }
    } catch (e) {
      NotifierUtils.showSnackBar(
          context, 'An error occurred. Please try again later.',
          isError: true);
      return false;
    }
  }
}
