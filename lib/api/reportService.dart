import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Reportservice {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

  Future<List<dynamic>> fetchCatgoryList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Token = prefs.getString('token');
    String? AuthKey = prefs.getString('Authkey');
    final url = Uri.parse('$baseUrl/reports/index');

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
        List<dynamic> categories = data['data']['reportTypes'];

        // Save the categories data in SharedPreferences if needed
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('reportCategoryList', responseBody);
        return categories;
      } else {
        throw Exception('Failed to load categories');
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

  Future<Map<String, dynamic>> getReportDetail(
  String category,
  BuildContext context, {
  required int page,
  required String from,
  required String to,
  String? search,
  String? status,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? authKey = prefs.getString('Authkey');

  // Construct the URL with query parameters
  final url = Uri.parse(
    '$baseUrl/reports/$category?page=$page&from=$from&to=$to&search=${search ?? ''}&status=${status ?? 'all'}',
  );

  print('Requesting URL: $url'); // Debug the URL being requested

  try {
    final response = await http.get(
      url,
      headers: {
        'token': token ?? '', // Add the token to headers
        'key': authKey ?? '', // Add the key to headers
      },
    );

    print('Response status code: ${response.statusCode}'); // Log status code
    print('Response headers: ${response.headers}'); // Log headers
    print('Response body: ${response.body}'); // Log body

    final data = json.decode(response.body);
    print("Parsed API response: $data"); // Debug parsed response

    if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
      // Extract the map of report details
      Map<String, dynamic> reportDetails = data['data'];
      await prefs.setString('reportCategoryList', response.body);
      return reportDetails;
    } else {
      // Log failure details
      print('Failed response data: $data');
      throw Exception('Failed to load report details with status: ${data['status']}');
    }
  } catch (e) {
    print('Error during API call: $e'); // Log the caught error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred while fetching data.'),
        duration: Duration(seconds: 2),
      ),
    );
    return {}; // Return an empty map on error
  }
}

}
