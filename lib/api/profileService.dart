import 'dart:convert';
import 'package:dotmik_app/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profileservice {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

Future<Map<String, dynamic>> fetchUserData(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? authKey = prefs.getString('Authkey');

  final url = Uri.parse('$baseUrl/userProfile');

  try {
    // Perform the API call
    final response = await http.get(
      url,
      headers: {
        'token': token ?? '',
        'key': authKey ?? '',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'SUCCESS') {
        // If data is successfully fetched, return it
        return data;
      } else if (data['status'] == 'UNAUTHORIZED') {
        // Token/auth key is invalid or expired; navigate to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please log in again.'),
            duration: Duration(seconds: 2),
          ),
        );
        _navigateToLoginScreen(context);
        return {}; // Return an empty map
      } else {
        // Other API errors
        throw Exception(data['message'] ?? 'Failed to load user data');
      }
    } else {
      // Handle non-200 HTTP status codes
      throw Exception('Server error: ${response.statusCode}');
    }
  } catch (e) {
    // Catch and handle network errors or exceptions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        duration: const Duration(seconds: 2),
      ),
    );
    _navigateToLoginScreen(context); // Redirect to login page on error
    return {}; // Return an empty map on error
  }
}

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

Future<Map<String, dynamic>> fetchComission(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? authKey = prefs.getString('Authkey');
  final url = Uri.parse('$baseUrl/getCommissionPlan');

  try {
    final response = await http.get(
      url,
      headers: {
        'token': token ?? '',
        'key': authKey ?? '',
      },
    );
    final responseBody = response.body;
    final data = json.decode(responseBody);

    if (data['status'] == 'SUCCESS') {
      return data; // Return the whole response data
    } else {
      throw Exception('Failed to load commission plans');
    }
  } catch (e) {
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