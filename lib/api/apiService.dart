import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dotmik_app/helper/helper.dart';
import 'package:dotmik_app/screen/home/home_bottombar_screen.dart';
import 'package:dotmik_app/screen/kyc/kycFormScreen.dart';
import 'package:dotmik_app/screen/kyc/kycpendingScreen.dart';
import 'package:dotmik_app/screen/login_screen.dart';
import 'package:dotmik_app/utils/notifiesClass/notifier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image/image.dart' as img;

class ApiService {
  final String baseUrl = 'https://b2b.shantipe.com/api/android';

  String _encrypt(String data) {
    final key = encrypt.Key.fromUtf8('934886cad106412a1e7be7d0965e3039');
    final iv = encrypt.IV.fromUtf8('DOTMIKSOFTWAREMK');

    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(data, iv: iv);

    return encrypted.base64;
  }

  Future<void> signUp(String firstName, String lastName, String email,
      String phone, String password) async {
    final url = Uri.parse('$baseUrl/authentication/signup');
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': password,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
    }
  }

  Future<void> logIn(
      String email, String password, BuildContext context) async {
    final url = Uri.parse('$baseUrl/authentication/login');
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'email': email,
      'password': password,
    });
    print("ther data i send ${request.fields}");
    try {
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      print("the data $responseBody   this is $data");
      if (data['status'] == 'SUCCESS') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('key', data['key']);
        await prefs.setBool('logout', data['logout']);

        String? savedKey = prefs.getString('key');
        bool? savedLogout = prefs.getBool('logout');

        // Navigate to OtpScreen on success
        Navigator.pushNamed(context, '/otpScreen');
      } else {
        NotifierUtils.showSnackBar(context, 'Login failed:${data['message']}',
            isError: true);
      }
    } catch (e) {
      NotifierUtils.showSnackBar(context, 'An error occurred', isError: true);
    }
  }

  // Future<void> logInOtp(String otpCode, BuildContext context) async {
  //   final url = Uri.parse('$baseUrl/authentication/verifyLogin');
  //   var request = http.MultipartRequest('POST', url);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Helper helper = Helper();
  //   String androidId = await helper.getAndroidId();
  //   String androidName = await helper.getAndroidName();
  //   Map<String, double> location = await helper.getCurrentLocation(context);
  //   dynamic? key = prefs.getString('key');

  //   request.fields.addAll({
  //     'code': otpCode,
  //     'lat': '${location['latitude']}',
  //     'log': '${location['longitude']}',
  //     'key': '$key',
  //     'device_token': '$androidId',
  //     'device_name': '$androidName',
  //   });

  //   try {
  //     http.StreamedResponse response = await request.send();

  //     final responseBody = await response.stream.bytesToString();
  //     final data = jsonDecode(responseBody);
  //     print(data);
  //     print("Response data: $data" );

  //     if (data['status'] == 'SUCCESS') {
  //       print(" print response data: $data"  );
  //       await prefs.setString('key', data['key'] ?? '');
  //       await prefs.setBool('logout', data['logout'] ?? false);

  //       // Debugging: Print the saved values
  //       String? savedKey = prefs.getString('key');
  //       bool? savedLogout = prefs.getBool('logout');

  //       String token = data['data']['authentication']['token'] ?? '';
  //       String authKey = data['data']['authentication']['key'] ?? '';

  //       // Ensure token and authKey are not null before encryption
  //       if (token.isNotEmpty && authKey.isNotEmpty) {
  //         String encryptedToken = _encrypt(token);
  //         String encryptedAuthKey = _encrypt(authKey);

  //         await prefs.setString('token', encryptedToken);
  //         await prefs.setString('Authkey', encryptedAuthKey);
  //         String? Token = prefs.getString('token');
  //         String? AuthKey = prefs.getString('Authkey');
  //         fetchDashboard(context, '$Token', '$AuthKey');
  //       } else {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //         NotifierUtils.showSnackBar(context, 'Invalid response data',
  //             isError: true);
  //       }
  //     } else {
  //       NotifierUtils.showSnackBar(context, 'Login failed: ${data['message']}',
  //           isError: true);
  //     }
  //   } catch (e) {
  //     NotifierUtils.showSnackBar(context, 'An error occurred', isError: true);
  //   }
  // }


Future<void> logInOtp(String otpCode, BuildContext context) async {
  final url = Uri.parse('$baseUrl/authentication/verifyLogin');
  var request = http.MultipartRequest('POST', url);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Helper helper = Helper();
  String androidId = await helper.getAndroidId();
  String androidName = await helper.getAndroidName();
  Map<String, double> location = await helper.getCurrentLocation(context);
  dynamic? key = prefs.getString('key');

  request.fields.addAll({
    'code': otpCode,
    'lat': '${location['latitude']}',
    'log': '${location['longitude']}',
    'key': '$key',
    'device_token': '$androidId',
    'device_name': '$androidName',
  });

  try {
    http.StreamedResponse response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);
    print("Response data: $data");

    if (data['status'] == 'SUCCESS') {
      await prefs.setString('key', data['key'] ?? '');
      await prefs.setBool('logout', data['logout'] ?? false);

      String kycStatus = 'pending';
      if (data['data'].containsKey('user') && data['data']['user'] != null) {
        kycStatus = data['data']['user']['kyc_status'] ?? 'pending';
      }

      String token = data['data']['authentication']['token'] ?? '';
      String authKey = data['data']['authentication']['key'] ?? '';

      if (token.isNotEmpty && authKey.isNotEmpty) {
        String encryptedToken = _encrypt(token);
        String encryptedAuthKey = _encrypt(authKey);
        await prefs.setString('token', encryptedToken);
        await prefs.setString('Authkey', encryptedAuthKey);

        Future.delayed(Duration.zero, () {
          if (kycStatus == 'approved') {
            print("Navigating to KYC Form...");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => KycFormScreen(initialStep: 1)),
            );
          } else {
            print("Navigating to KYC Pending...");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const KycPendingScreen()),
            );
          }
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        NotifierUtils.showSnackBar(context, 'Invalid response data', isError: true);
      }
    } else {
      NotifierUtils.showSnackBar(context, 'Login failed: ${data['message']}', isError: true);
    }
  } catch (e) {
    NotifierUtils.showSnackBar(context, 'An error occurred', isError: true);
    print("Error: $e");
  }
}

void startKycStatusCheck(BuildContext context) {
  Timer.periodic(Duration(seconds: 60), (timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/user/checkKycStatus');
    var response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    final data = jsonDecode(response.body);
    print("KYC Status Check: $data");

    if (data['status'] == 'SUCCESS') {
      String kycStatus = data['data']['user']['kyc_status'] ?? 'pending';

      if (kycStatus == 'approved') {
        timer.cancel(); //  अगर KYC Approve हो गया तो Timer रोक दो
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => KycFormScreen(initialStep: 1)),
        );
      }
    }
  });
}

  Future<void> _checkAuth(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    // If either token or authKey is null, redirect to login screen
    if (token == null || authKey == null) {
      Navigator.pushReplacementNamed(context, '/loginScreen');
    }
  }

  Future<void> fetchDashboard(BuildContext context, String token, String key) async {
    final url = Uri.parse('$baseUrl/dashboard');

    try {
      // Create a GET request with headers
      final response = await http.get(
        url,
        headers: {
          'token': token, // Add the token to headers
          'key': key, // Add the key to headers
        },
      );
    print(response.body);
      // Check if the response status is OK (200)
      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Parse the response body
        final data = json.decode(responseBody);

        // Save the entire response data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('responseData', responseBody);
        String activity = data['activity'];
        String message;

        // Navigate based on the activity type
        switch (activity) {
          case 'kyc_form':
            message = 'You need to complete the KYC form.';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KycFormScreen(initialStep: 1),
              ),
            );
            break;
          case 'kyc_phase2':
            message = 'Proceed to KYC Phase 2.';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KycFormScreen(initialStep: 2),
              ),
            );
            break;
          case 'kyc_pending':
            message = 'KYC process is still pending.';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KycPendingScreen(),
              ),
            );
            break;
          case 'dashboard':
            message = 'KYC process completed successfully.';
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => const HomeBottomNavBar(),
              ),
            );
            break;
          default:
            message = 'Unknown status: $activity';
            break;
        }
      }
      else if (response.statusCode == 422) {
        final responseBody = response.body;

        // Parse the response body
        final data = json.decode(responseBody);

        // Save the entire response data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('responseData', responseBody);
        String activity = data['activity'];
        String message;

        // Navigate based on the activity type
        switch (activity) {
          case 'kyc_form':
            message = 'You need to complete the KYC form.';
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => KycFormScreen(initialStep: 1),
              ),
            );
            break;
          case 'kyc_phase2':
            message = 'Proceed to KYC Phase 2.';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KycFormScreen(initialStep: 2),
              ),
            );
            break;
          case 'kyc_pending':
            message = 'KYC process is still pending.';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KycPendingScreen(),
              ),
            );
            break;
          case 'dashboard':
            message = 'KYC process completed successfully.';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeBottomNavBar(),
              ),
            );
            break;
          default:
            message = 'Unknown status: $activity';
            break;
        }
      }
      else {
        // If the response status is not OK, navigate to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      // Handle any errors and navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  Future<void> checkAuth(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    print("the tkeonweespg $token $authKey");
    // If either token or authKey is null, redirect to login screen
    if (token == null || authKey == null) {
      Navigator.pushReplacementNamed(context, '/loginScreen');
    }
  }

  Future<Map<String, dynamic>> kycphaseOne(
      String email,
      String mobile,
      String account,
      String pan,
      String aadhar,
      String ifsc,
      BuildContext context) async {
    Helper helper = Helper();
    final url = Uri.parse('$baseUrl/kyc/verification/phaseOne');
    var request = http.MultipartRequest('POST', url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }
    Map<String, double> location = await helper.getCurrentLocation(context);

    request.fields.addAll({
      'email': email,
      'mobile': mobile,
      'account': account,
      'pan': pan,
      'aadhaar': aadhar,
      'ifsc': ifsc,
      'lat': '${location['latitude']}',
      'log': '${location['longitude']}',
    });

    http.StreamedResponse response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      String reference = data['reference'] ?? '';
      await prefs.setString('reference', reference);
      return data;
    } else {
      final data = jsonDecode(responseBody);
      return data; // Return the error response for further handling
    }
  }


  Future kycOtpverify(
    String otp,
  ) async {
    // ignore: unused_local_variable
    Helper helper = Helper();
    final url = Uri.parse('$baseUrl/kyc/verification/verifyByOtp');
    var request = http.MultipartRequest('POST', url);

    // Add headers if token and auth key are available
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? reference = prefs.getString('reference');

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey;
    }

    request.fields.addAll({
      'otp': otp,
      'key': '$reference',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      print(data);
    } else {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      print(data);
    }
  }

  Future kycphaseTwo(
    File? panCardImage,
    File? aadharFrontImage,
    File? aadharBackImage,
    File? shopFrontImage,
    File? shopBackImage,
    String fatherName,
    String shopName,
    String shopAddress,
  ) async {
    final url = Uri.parse('$baseUrl/kyc/verification/phaseTwo');
    var request = http.MultipartRequest('POST', url);

    // Add headers if token and auth key are available
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');
    String? errorMessage;

    if (token != null && authKey != null) {
      request.headers['token'] = token;
      request.headers['key'] = authKey; 
    }
    //
    // Function to compress image
    Future<http.MultipartFile> compressImage(
        File imageFile, String fieldName) async {
      final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
      if (image == null) {
        throw Exception('Unable to decode image');
      }

      // Compress the image to ensure it is under 2MB
      img.Image resizedImage =
          img.copyResize(image, width: 800); // Resize as needed
      List<int> compressedImage =
          img.encodeJpg(resizedImage, quality: 85); // Adjust quality if needed

      // Create a temporary file for the compressed image
      final tempFile = File(
          '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedImage);

      return http.MultipartFile.fromPath(fieldName, tempFile.path);
    }

    // Add image files to the request
    if (panCardImage != null) {
      request.files.add(await compressImage(panCardImage, 'pan_image'));
    }
    if (aadharFrontImage != null) {
      request.files.add(await compressImage(aadharFrontImage, 'aadhaar_front'));
    }
    if (aadharBackImage != null) {
      request.files.add(await compressImage(aadharBackImage, 'aadhaar_back'));
    }
    if (shopFrontImage != null) {
      request.files.add(await compressImage(shopFrontImage, 'outlet_outer'));
    }
    if (shopBackImage != null) {
      request.files.add(await compressImage(shopBackImage, 'outlet_inner'));
    }

    // Add text fields to the request
    request.fields.addAll({
      'father_name': fatherName,
      'outlet': shopName,
      'outlet_address': shopAddress,
    });

    // Send the request
    http.StreamedResponse response = await request.send();
    print("KYC Successful!");
    if (response.statusCode == 200) {
      print(" any detail Okay ");
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data;
    } else {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data;
    }
}
}
