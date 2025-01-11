import 'package:flutter/material.dart';

class NotifierUtils {
  // Method to show a successful popup
  static Future<void> showSuccessPopup(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Success', style: TextStyle(color: Colors.green, fontSize: 22)),
            ],
          ),
          content: Text(message, style: TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  // Method to show a failed popup
  static Future<void> showFailedPopup(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text('Failed', style: TextStyle(color: Colors.red, fontSize: 22)),
            ],
          ),
          content: Text(message, style: TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Method to show a snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: isError ? Colors.white : Colors.black, fontSize: 16),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
