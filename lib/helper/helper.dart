import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Helper {
  Future<String> getAndroidId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id ?? 'Unknown';
      } else {
        return 'Not Android';
      }
    } catch (e) {
      print('Failed to get Android ID: $e');
      return 'Error';
    }
  }
  
  Future<String> getAndroidName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.device ?? 'Unknown';
      } else {
        return 'Not Android';
      }
    } catch (e) {
      print('Failed to get Android ID: $e');
      return 'Error';
    }
  }


Future<Map<String, double>> getCurrentLocation(BuildContext context) async {
  while (true) {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Handle the case where location services are disabled
        throw Exception('Location services are disabled.');
      }

      // Check for location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Show Snackbar and continue asking for permission
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location permissions are important for this feature. Please allow access.'),
              duration: Duration(seconds: 2),
            ),
          );
          continue; // Re-check permission
        } else if (permission == LocationPermission.deniedForever) {
          // Handle the case where permissions are permanently denied
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location permissions are permanently denied. Please enable them in settings.'),
              duration: Duration(seconds: 2),
            ),
          );
          throw Exception('Location permissions are permanently denied, we cannot request permissions.');
        }
      } else if (permission == LocationPermission.deniedForever) {
        // Handle the case where permissions are permanently denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permissions are permanently denied. Please enable them in settings.'),
            duration: Duration(seconds: 2),
          ),
        );
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      print('Failed to get location: $e');
      return {'latitude': 0.0, 'longitude': 0.0}; // Return default values or handle the error
    }
  }
}
}