import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Walletservice {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

  Future<Map<String, dynamic>?> fetchIndex(
      BuildContext context, String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    // Use the mobile parameter dynamically in the URL
    final url = Uri.parse('$baseUrl/wallet-to-wallet/index?mobile=$mobile');
    var request = http.MultipartRequest('GET', url);

    // Add headers to the request
    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    // Add fields to the request
    request.fields['mobile'] = mobile;
    try {
      // Send the request
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
        // Return the decoded JSON data
        return data;
      } else {
        return null;
      }
    } catch (e) {
      // Handle errors and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while fetching data.'),
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }
  }

////////////--------Company Banks ------------//////////

  Future<List<dynamic>> companyBanklist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/companyBanks');

    try {
      // Create a GET request with headers
      final response = await http.get(
        url,
        headers: {
          'token': token ?? '', // Add the token to headers
          'key': authKey ?? '', // Add the key to headers
        },
      );
      final responseBody = response.body;

      // Parse the response body
      final data = json.decode(responseBody);

      if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
        // Extract the companyBanks list from the data field
        List<dynamic> companyBanks = data['data']['companyBanks'];
        return companyBanks;
      } else {
        throw Exception(data['message'] ?? 'Failed to load banks');
      }
    } catch (e) {
      // Handle any errors and show an error message
      return [];
    }
  }

  Future<void> fundRequestFormData({
    required BuildContext context,
    required String amount,
    required String bankId,
    required String date,
    required String mode,
    required String remark,
    required String utr,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/raiseFundRequest');

    try {
      final response = await http.post(
        url,
        headers: {
          'token': token ?? '',
          'key': authKey ?? '',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'amount': amount,
          'bank': bankId,
          'date': date,
          'mode': mode,
          'remark': remark,
          'utr': utr,
        }),
      );

      final responseBody = response.body;
      final data = json.decode(responseBody);

      if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
        // Show a beautifully designed success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 40),
                  SizedBox(width: 16),
                  Text('Success',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text(
                data['message'],
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to raise fund request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while raising the fund request.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> transactionTransfer(
    BuildContext context,
    String mobile,
    String amount,
    String pinCode,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    final url = Uri.parse('$baseUrl/wallet-to-wallet/transfer');
    var request = http.MultipartRequest('POST', url);

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    } else {
    }

    request.fields.addAll({
      'phone': mobile,
      'amount': amount,
      'pin': pinCode,
    });

    try {
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
