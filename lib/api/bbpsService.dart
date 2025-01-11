import 'dart:convert';
import 'package:dotmik_app/helper/helper.dart';
import 'package:dotmik_app/screen/home/Broadband/bankDetailsData.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Bbpsservice {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

  Future<List<dynamic>> fetchCatgoryList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/bbps/getCategoryList');

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

      if (data['status'] == 'SUCCESS') {
        // Extract the list of categories
        List<dynamic> categories = data['data']['bbpsCategories'];

        // Save the categories data in SharedPreferences if needed
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('BbpsCategoryList', responseBody);

        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // Handle any errors and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while fetching data.'),
          duration: Duration(seconds: 2),
        ),
      );
      return [];
    }
  }

  Future<List<dynamic>> broadbandDataList(
      BuildContext context, String mode, String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/bbps/getBillerList/$mode/$category');
    print("broadband url $url");

    final response = await http.get(
      url,
      headers: {
        'token': '$Token',
        'key': '$AuthKey',
      },
    );

    try {
      final responseBody = response.body;
      final data = json.decode(responseBody);
      print("broadband Data $data");
      if (data['status'] == 'SUCCESS') {
        List<dynamic> billers = data['data']['bbpsGetBillers']['billers'];
        return billers;
      } else {
        throw Exception('Failed to load billers');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while fetching data.'),
          duration: Duration(seconds: 2),
        ),
      );
      return [];
    }
  }

  Future<Object> broadbandIdSend(BuildContext context, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/bbps/getParams?id=$id');
    final response = await http.get(
      url,
      headers: {
        'token': token ?? '',
        'key': authKey ?? '',
      },
    );

    try {
      final responseBody = response.body;
      final data = json.decode(responseBody);
      if (data['status'] == 'SUCCESS') {
        Map<String, dynamic> params = data['data']['bbpsParams'];
        return params;
      } else {
        throw Exception('Failed to load billers');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while fetching data.'),
          duration: Duration(seconds: 2),
        ),
      );
      return [];
    }
  }

  Future<void> fetchBill(
      String biller, Map<String, String> params, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/bbps/fetchBill');
    var request = http.MultipartRequest('POST', url);

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'biller': biller,
      ...params, // Spread the params map to add all key-value pairs to the fields
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (data['status'] == 'SUCCESS') {
        final billData = data['data']['bbpsBillFetch'];
        String initiateTransactionKey =
            data['data']['bbpsBillFetch']['bbpsFetchKey'] ?? '';
        await prefs.setString('bbpsFetchKey', initiateTransactionKey);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BillDetailsScreen(billData: billData, biller: biller),
          ),
        );
      } else {
        print('Fetch Bill Error: ${data['message']}');
      }
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }

  Future<void> TransactionDetailsSend(
      String biller, String amount, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');
    String? key = prefs.getString('bbpsFetchKey');
    final url = Uri.parse('$baseUrl/bbps/initiateBillPay');
    var request = http.MultipartRequest('POST', url);

    if (Token != null && AuthKey != null) {
      request.headers['token'] = Token;
      request.headers['key'] = AuthKey;
    }

    request.fields.addAll({
      'key': '$key',
      'biller': biller,
      'amount': amount,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');
    }
  }

////////////-------Verify Otp-------/////////////////////
  Future<void> otpverify(
    String otp,
  ) async {
    Helper helper = Helper();
    final url = Uri.parse('$baseUrl/bbps/confirmBillPay');
    var request = http.MultipartRequest('POST', url);

    // Add headers if token and auth key are available
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? remitterKey = prefs.getString('remitter_key');
    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    String? reference;

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
      print('Response body: $responseBody');
    }
  }
}
