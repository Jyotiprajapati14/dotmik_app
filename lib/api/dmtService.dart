import 'dart:convert';
import 'package:dotmik_app/helper/helper.dart';
import 'package:dotmik_app/screen/CreditCardBillPayment/otpScreen.dart';
import 'package:dotmik_app/screen/dmt/dmt_screen.dart';
import 'package:dotmik_app/screen/dmt/merchantRegisterForm.dart';
import 'package:dotmik_app/screen/dmt/remitterlogin_screen.dart';
import 'package:dotmik_app/utils/notifiesClass/notifier.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DmtService {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

  Future<void> fetchBankAccounts(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/money-transfer/index');

    // Create a GET request with headers
    final response = await http.get(
      url,
      headers: {
        'token': '$Token', // Add the token to headers
        'key': '$AuthKey', // Add the key to headers
      },
    );

    try {
      final responseBody = response.body;
      final data = json.decode(responseBody);
      String activity = data['activity'];
      String message;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('responseData', responseBody);

      // Navigate based on the activity type
      switch (activity) {
        case 'remitter_login':
          message = 'You need to Login Remitter form.';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DmtLoginFormScreen(),
            ),
          );
          break;
        case 'merchant_register':
          message = 'Proceed to KYC Phase 2.';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MerchantRegisterFormScreen(),
            ),
          );
          break;
        default:
          message = 'Unknown status: $activity';
          break;
      }

      // Show Snackbar with the message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while fetching data.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> DmtLogin(String mobile, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/money-transfer/remitter-login');
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
      final data = json.decode(responseBody);
      if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
        String activity = data['activity'];
        String message;
        await prefs.setString('responseData', responseBody);

        // Save the remitter_key
        if (data['data'] != null && data['data']['remitter_key'] != null) {
          await prefs.setString('remitter_key', data['data']['remitter_key']);
          String? remitterKey = prefs.getString('remitter_key');
        }

        switch (activity) {
          case 'remitter_index':
            message = 'You need to complete the registration.';
            getDetails(mobile , context);
            break;
          case 'remitter_register':
            message = 'Proceed to Phase 2 registration.';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RemitterRegisterFormScreen(),
              ),
            );
            break;
          default:
            message = 'Unknown status: $activity';
            break;
        }

        // Show success popup
     //   await NotifierUtils.showSuccessPopup(context, message);
      } else {
        // Handle unexpected response format or missing activity
        throw Exception('Unexpected response format or missing activity.');
      }
    } catch (e) {

      // Show failure popup
      await NotifierUtils.showFailedPopup(
          context, 'An error occurred while fetching data.');
    }
  }

////////////-------Verify Otp-------/////////////////////
  Future<void> otpverify(
    String otp,
  ) async {
    Helper helper = Helper();
    final url = Uri.parse('$baseUrl/money-transfer/validate-otp');
    var request = http.MultipartRequest('POST', url);

    // Add headers if token and auth key are available
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? remitterRegisterReference =
        prefs.getString('remitterRegisterReference');
    String? remitterBeneficiaryReference =
        prefs.getString('remitterBeneficiaryReference');
    String? remitterKey = prefs.getString('remitter_key');
    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }


    String? reference;
    if (remitterRegisterReference != null &&
        remitterRegisterReference.isNotEmpty) {
      reference = remitterRegisterReference;
    } else if (remitterKey != null && remitterKey.isNotEmpty) {
      reference = remitterBeneficiaryReference;
    } else if (remitterKey != null && remitterKey.isNotEmpty) {
      reference = remitterKey;
    }

    request.fields.addAll({
      'otp': otp,
      'reference': reference ??
          '', // Use reference if available, otherwise an empty string
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }

////////////--------Remitter Index-----////////////////////

  Future<Map<String, dynamic>> getDetails(String mobile , BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? remitterKey = prefs.getString('remitter_key');

    final url = Uri.parse('$baseUrl/money-transfer/remitter-index/$remitterKey')
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
      if (data['status'] == 'SUCCESS') {
        await prefs.setString('userData', responseBody);
        String? Data = prefs.getString('userData');
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DmtScreen(shouldFetchData: false),
              ),
            );

        return data;
      } else {
        throw Exception('Failed to fetch details');
      }
    } catch (e) {
      throw Exception('Failed to fetch details: $e');
    }
  }

/////////--------------Remitter Register---------//////////////////////////

 Future<Map<String, dynamic>> DmtRegister(
  String mobile,
  String firstName,
  String lastName,
  String pinCode,
  BuildContext context
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? authKey = prefs.getString('Authkey');

  final url = Uri.parse('$baseUrl/money-transfer/register-remitter');
  var request = http.MultipartRequest('POST', url);

  if (token != null && authKey != null) {
    request.headers['token'] = token;
    request.headers['key'] = authKey;
  }

  request.fields.addAll({
    'mobile': mobile,
    'first_name': firstName,
    'last_name': lastName,
    'pincode': pinCode,
  });

  try {
    http.StreamedResponse response = await request.send();

    // Log status code and headers
    print("Response Status Code: ${response.statusCode}");
    print("Response Headers: ${response.headers}");

    // Read and decode the response body
    final responseBody = await response.stream.bytesToString();
    print("Response Body: $responseBody");

    final data = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      String remitterRegisterReference = data['remitter_register_reference'] ?? '';
      await prefs.setString('remitterRegisterReference', remitterRegisterReference);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DmtScreen(shouldFetchData: false),
        ),
      );

      // Return the response data
      return {'status': true, 'data': data};
    } else {
      // Log error message and return failure status
      print("Error Response Data: $data");
      return {'status': false, 'message': data['message'] ?? 'Unknown error occurred'};
    }
  } catch (e) {
    // Log exception and return error status
    print("Exception occurred: $e");
    return {'status': false, 'message': 'An error occurred during registration.'};
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
          context,
          MaterialPageRoute(
              builder: (context) => DmtScreen(shouldFetchData: false)));
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

      final data = json.decode(responseBody) as Map<String, dynamic>;

      await prefs.setString('responseData', responseBody);

      // Return the parsed data
      return data;
    } catch (e) {
      throw Exception('Failed to fetch bank names: $e');
    }
  }

  Future<Map<String, dynamic>> NewAccountAdd(String name, String account, String ifsc,
    String bank, String isVerified, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? RemitterKey = prefs.getString('remitter_key');
  String? Token = prefs.getString('token');
  String? AuthKey = prefs.getString('Authkey');

  final url = Uri.parse('$baseUrl/money-transfer/add-beneficiary');
  var request = http.MultipartRequest('POST', url);

  // Add headers if available
  if (Token != null && AuthKey != null) {
    request.headers['token'] = Token;
    request.headers['key'] = AuthKey;
  }

  // Add request fields
  request.fields.addAll({
    'name': name,
    'account': account,
    'ifsc': ifsc,
    'bank': bank,
    'isVerified': isVerified,
    'key': '$RemitterKey',
  });

  try {
    // Send the request and get the response
    http.StreamedResponse response = await request.send();
  
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      String remitterBeneficiaryReference =
          data['add_beneficiary_reference'] ?? '';

      await prefs.setString(
          'remitterBeneficiaryReference', remitterBeneficiaryReference);
      
      return data; // Return the parsed response
    } else {
      // Log error response for debugging
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      return data; // Return the error response
    }
  } catch (e) {
    // Log exception for debugging
    print('API Exception: $e');
    return {
      'status': 'FAILURE',
      'message': 'An error occurred: $e',
    };
  }
}


////////////////-----------Delete Beneficiary--------/////////

  Future<void> deleteBenficiary(String accountId, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? RemitterKey = prefs.getString('remitter_key');
    String? RemitterBeneficiaryReference =
        prefs.getString('remitterBeneficiaryReference');
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/money-transfer/delete-beneficiary');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'account_id': accountId,
      'key': '$RemitterBeneficiaryReference',
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
    final url = Uri.parse('$baseUrl/money-transfer/perform-transaction');
    var request = http.MultipartRequest('POST', url);
    Helper helper = Helper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, double> location = await helper.getCurrentLocation(context);
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? initiateTransactionKey = prefs.getString('initiateTransactionKey');

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'otp': otp,
      'key': '$initiateTransactionKey',
      'lat': '${location['latitude']}',
      'log': '${location['longitude']}',
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

  Future<bool> TransactionDetailsSend(String accountId, String Key, String mode,
      String amount, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/money-transfer/initiate-transaction');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'account': accountId,
      'key': Key,
      'mode': mode,
      'amount': amount,
    });

    try {
      // Send request and capture response
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final data = jsonDecode(responseBody);
      if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
        String initiateTransactionKey =
            data['initiate_transaction_reference'] ?? '';
        await prefs.setString('initiateTransactionKey', initiateTransactionKey);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpCreditCardScreen(
              cardNumber:
                  data['data']['dmtDescription']['Account Number'] ?? '',
              name: data['data']['dmtDescription']['Beneficiary'] ?? '',
              amount: data['data']['dmtDescription']['Transaction Amt.'] ?? '',
              transactionKey: initiateTransactionKey,
              transactionType: 'Dmt',
            ),
          ),
        );

        return true;
      } else {
        // Handle failed response
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
