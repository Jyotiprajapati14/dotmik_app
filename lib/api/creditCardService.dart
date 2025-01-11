import 'dart:convert';
import 'package:dotmik_app/helper/helper.dart';
import 'package:dotmik_app/screen/CreditCardBillPayment/CreditCardScreen.dart';
import 'package:dotmik_app/screen/CreditCardBillPayment/RegisterScreen.dart';
import 'package:dotmik_app/screen/CreditCardBillPayment/otpScreen.dart';
import 'package:dotmik_app/screen/fundtransfer/fundTransfer_screen.dart';
import 'package:dotmik_app/utils/notifiesClass/notifier.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreditCardService {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

  Future<void> check_contact(BuildContext context, String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/credit-card/check-contact');
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
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        String status = data['status'] ?? '';
        String contact_key = data['contact_key'] ?? '';
        await prefs.setString('contact_key', contact_key);
        getDetails(mobile, context);
      } else {
        NotifierUtils.showSnackBar(
            context, 'Registration failed: ${data['message']}',
            isError: true);
      }
    } catch (e) {
      NotifierUtils.showSnackBar(
          context, 'An error occurred during registration.',
          isError: true);
    }
  }

////////////-------Verify Otp-------/////////////////////
  Future<void> otpverify(
    String otp,
    BuildContext context, // Add BuildContext to use for navigation
  ) async {
    final url = Uri.parse('$baseUrl/credit-card/verify-register');
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
              builder: (context) => FundTransferScreen(
                shouldFetchData: false,
              ), // Replace with your actual screen
            ),
          );
        } else {
          // Handle other statuses or errors

          NotifierUtils.showSnackBar(
              context, 'Verification failed: ${data['message']}',
              isError: true);
        }
      } else {
        final responseBody = await response.stream.bytesToString();
        NotifierUtils.showSnackBar(
            context, 'An error occurred during verification.',
            isError: true);
      }
    } catch (e) {
      NotifierUtils.showSnackBar(
          context, 'An error occurred during verification.',
          isError: true);
    }
  }

////////////--------Contact  Index-----////////////////////
  Future<Map<String, dynamic>> getDetails(
      String mobile, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? contactKey = prefs.getString('contact_key');

    if (contactKey == null) {
      NotifierUtils.showFailedPopup(context, 'Contact key is null');
      throw Exception('Contact key is null');
    }

    final url = Uri.parse('$baseUrl/credit-card/index/$contactKey')
        .replace(queryParameters: {'mobile': mobile});

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
      await prefs.setString('userCardDetails', responseBody);
      String? Data = prefs.getString('userCardDetails');
      print("the dota $data");
      if (response.statusCode == 200) {
        if (data['status'] == 'SUCCESS') {
          NotifierUtils.showSuccessPopup(
              context, 'Details fetched successfully!');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    CreditCardScreen()), // Navigate to the credit card screen
          );
        } else if (data['status'] == "REGISTER") {
          NotifierUtils.showFailedPopup(context, 'Please register first.');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    CreditCardRegisterFormScreen()), // Navigate to the registration screen
          );
        } else {
          NotifierUtils.showFailedPopup(
              context, 'Failed to fetch details. Status: ${data['status']}');
          throw Exception('Failed with status: ${data['status']}');
        }
        return data;
      } else {
        NotifierUtils.showFailedPopup(
            context, 'Failed with status code: ${response.statusCode}');
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      NotifierUtils.showFailedPopup(context, 'Failed to fetch details: $e');
      throw Exception('Failed to fetch details: $e');
    }
  }

/////////--------------Remitter Register---------//////////////////////////

  Future<void> CreditCardRegister(String mobile, String email, String name,
      String address, String pinCode, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/credit-card/register');
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
        if (data['status'] == 'SUCCESS') {
          // Correctly access the 'create_contact_key' from the response
          String registerReference = data['create_contact_key'] ?? '';
          await prefs.setString('registerReference', registerReference);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FundTransferScreen(
                shouldFetchData: false,
              ), // Replace with your actual screen
            ),
          );
        } else {
          NotifierUtils.showSnackBar(
              context, 'Registration failed: ${data['message']}',
              isError: true);
        }
      } else {
        NotifierUtils.showSnackBar(
            context, 'An error occurred during registration.',
            isError: true);
      }
    } catch (e) {
      NotifierUtils.showSnackBar(
          context, 'An error occurred during registration.',
          isError: true);
    }
  }

/////////////------------Metchant Register-------------------/////////////////////
  Future<void> MerchantRegister(String email, String mobile, String aadhar,
      String pan, String account, String ifsc, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Helper helper = Helper();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');
    Map<String, double> location = await helper.getCurrentLocation(context);

    final url = Uri.parse('$baseUrl/money-transfer/merchant-register');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'email': email,
      'mobile': mobile,
      'aadhaar': aadhar,
      'pan': pan,
      'account': account,
      'ifsc': ifsc,
      'lat': '${location['latitude']}',
      'log': '${location['longitude']}',
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreditCardScreen()));
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }

  Future<void> MerchantOtpVerify(
    String otp,
  ) async {
    Helper helper = Helper();
    final url = Uri.parse('$baseUrl/money-transfer/merchant-register-verify');
    var request = http.MultipartRequest('POST', url);

    // Add headers if token and auth key are available
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? referenceRemitter = prefs.getString('referenceRemitter');

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'otp': otp,
      'key': '$referenceRemitter',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }

//////////////------------------Add Benificiary-------------///////////////////////

  Future<Map<String, dynamic>> getBankName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/money-transfer/bank-list');

    try {
      final response = await http.get(
        url,
        headers: {
          'token': token ?? '',
          'key': authKey ?? '',
        },
      );
      final responseBody = response.body;

      // Parse the response body
      final data = json.decode(responseBody) as Map<String, dynamic>;

      // Save response data in shared preferences
      await prefs.setString('responseData', responseBody);

      // Return the parsed data
      return data;
    } catch (e) {
      throw Exception('Failed to fetch bank names: $e');
    }
  }

  Future<void> NewAccountAdd(
      String name, String cardNumber, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ContactKey = prefs.getString('contact_key');
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/credit-card/addBeneficiary');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'name': name,
      'card_number': cardNumber,
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
          context, MaterialPageRoute(builder: (context) => CreditCardScreen()));
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }
////////////////-----------Delete Beneficiary--------/////////

  Future<void> deleteBenficiary(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/credit-card/deleteBeneficiary');
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

  Future<Map<String, dynamic>?> otpPerformTransaction(
      String otp, BuildContext context) async {
    final url = Uri.parse('$baseUrl/credit-card/performTransaction');
    var request = http.MultipartRequest('POST', url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? initiateTransactionKey =
        prefs.getString('initiateFundTransactionKey');

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'otp': otp,
      'key': '$initiateTransactionKey',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data; // Return the response data
    } else {
      final responseBody = await response.stream.bytesToString();
      return null; // Return null if the transaction failed
    }
  }

////////----------Transaction--------//////////

  Future<bool> TransactionDetailsSend(
      String id, String amount, String phone, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/credit-card/initiateTransaction');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'id': id,
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
              cardNumber: data['data']['creditCardInitiateTransaction']
                      ['Card Number'] ??
                  '',
              name: data['data']['creditCardInitiateTransaction']['Name'] ?? '',
              amount: data['data']['creditCardInitiateTransaction']
                      ['Transaction Amt.'] ??
                  '',
              transactionKey: initiateTransactionKey,
              transactionType: 'Credit Card',
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
