import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MobileService {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

////////////--------Contact  Index-----////////////////////

  Future<Map<String, dynamic>> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/mobile-recharge/index');
    try {
      final response = await http.get(
        url,
        headers: {
          'token': token ?? '',
          'key': authKey ?? '',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final data = json.decode(responseBody) as Map<String, dynamic>;

        if (data['status'] == 'SUCCESS') {
          await prefs.setString('userDthDetails', responseBody);
          String? Data = prefs.getString('userMobileDetails');
          return data;
        } else {
          throw Exception('Failed to fetch details: ${data['message']}');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch details: $e');
    }
  }
////////////---------Get Operator------////////

Future<bool> getOperator(String mobile, BuildContext context) async {
  // Construct the URL with the mobile number as a query parameter
  final url =
      Uri.parse('$baseUrl/mobile-recharge/getOperator?mobile_number=$mobile');

  // Create a GET request
  final request = http.Request('GET', url);

  // Get the token and auth key from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? authKey = prefs.getString('Authkey');

  if (token != null && authKey != null) {
    request.headers['token'] = token;
    request.headers['key'] = authKey;
  }

  // Send the request and get the response
  final response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    String operator = data['data']['rechargeOperator']['operator'] ?? '';
    String circle = data['data']['rechargeOperator']['circle'] ?? '';

    // Save the operator and circle in SharedPreferences
    await prefs.setString('Operator', operator);
    await prefs.setString('Circle', circle);

    return true; // Request was successful
  } else {
    return false; // Request failed
  }
}

///////////-------Get Plans---------/////////
  Future<Map<String, dynamic>?> getPlans(
    String operator, String circle, BuildContext context) async {
  // Construct the URL with operator and circle as query parameters
  final url = Uri.parse(
      '$baseUrl/mobile-recharge/fetchPlans?operator=$operator&circle=$circle');

  // Create a GET request
  final request = http.Request('GET', url);

  // Get the token and auth key from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? authKey = prefs.getString('Authkey');

  // Set the headers
  if (token != null && authKey != null) {
    request.headers['token'] = token;
    request.headers['key'] = authKey;
  }

  try {
    // Send the request and get the response
    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // Return the data
    } else {
      return null; // Return null on failure
    }
  } catch (e) {
    return null; // Return null on error
  }
}


///////////////-----------Prform Transaction----------/////////////

  Future<bool> otpPerformTransaction(String otp, BuildContext context) async {
    final url = Uri.parse('$baseUrl/dth-recharge/performTransaction');
    var request = http.MultipartRequest('POST', url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? initiateDthKey = prefs.getString('initiateDthKey');

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'otp': otp,
      'key': '$initiateDthKey',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return true; // Transaction was successful
    } else {
      final responseBody = await response.stream.bytesToString();
      return false; // Transaction failed
    }
  }

////////----------Transaction--------//////////

  Future<void> TransactionDetailsSend(String amount, String phone,
      String operatorCode, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/dth-recharge/initiateTransaction');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'mobileNumber': phone,
      'operatorCode': operatorCode,
      'amount': amount,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      String initiateDthKey = data['dth_recharge_initiate_key'] ?? '';
      await prefs.setString('initiateDthKey', initiateDthKey);;
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }
}
