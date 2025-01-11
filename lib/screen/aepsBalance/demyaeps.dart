// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
//
// // import 'package:mantra_biometric/mantra_biometric.dart';
// // import 'package:mantra_biometric/utils/mantra_plugin_exception.dart';
// import 'package:xml/xml.dart';
// import 'package:collection/collection.dart';
//
// class Dummyaeps extends StatefulWidget {

import 'package:flutter/material.dart';

class Dummyaeps extends StatefulWidget {
  const Dummyaeps({super.key});

  @override
  State<Dummyaeps> createState() => _DummyaepsState();
}

class _DummyaepsState extends State<Dummyaeps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}



//   const Dummyaeps({Key? key}) : super(key: key);
//
//   @override
//   State<Dummyaeps> createState() => _DummyaepsState();
// }
//
// class _DummyaepsState extends State<Dummyaeps> {
//   // final _mantraBiometricPlugin = MantraBiometric();
//   String result = "";
//   String deviceInfo = "";
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   // Display alert dialog for errors or status messages
//   void displayAlert(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Fetch and display device information
//   Future<void> getDeviceInfo() async {
//     try {
//       String output = await _mantraBiometricPlugin.getDeviceInformation() ?? "";
//       setState(() {
//         deviceInfo = output;
//       });
//     } on RDClientNotFound catch (e) {
//       log("${e.code} - ${e.message}");
//       displayAlert("RD Service Client not found. Please install the required client.");
//     } catch (e) {
//       displayAlert("Something went wrong while fetching device info: $e");
//     }
//   }
//
//   // Capture fingerprint scan
//   Future<void> scanFingerPrint() async {
//     try {
//       String wadh = ""; // Use a WADH value if needed, otherwise leave empty
//       String pidOptions =
//           "<PidOptions ver=\"1.0\">"
//           "  <Opts fCount=\"1\" fType=\"2\" pCount=\"0\" format=\"0\" pidVer=\"2.0\" "
//           "    wadh=\"$wadh\" timeout=\"20000\" posh=\"UNKNOWN\" env=\"P\" />"
//           "</PidOptions>";
//
//       String? capturedResult = await _mantraBiometricPlugin.captureFingerPrint(pidOptions: pidOptions);
//
//       if (capturedResult != null) {
//         setState(() {
//           result = capturedResult;
//         });
//         log("Fingerprint capture successful: $capturedResult");
//       } else {
//         displayAlert("Failed to capture fingerprint. Please try again.");
//       }
//     } on RDClientNotFound catch (e) {
//       log("${e.code} - ${e.message}");
//       displayAlert("RD Service Client not found. Please install the required client.");
//     } catch (e) {
//       displayAlert("Something went wrong during fingerprint capture: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mantra Biometric Example'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Button to get device information
//             ElevatedButton(
//               onPressed: getDeviceInfo,
//               child: const Text("Get Device Information"),
//             ),
//             const SizedBox(height: 20),
//
//             // Display device info
//             Text(
//               "Device Info: $deviceInfo",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//
//             // Button to scan fingerprint
//             ElevatedButton(
//               onPressed: scanFingerPrint,
//               child: const Text("Scan Fingerprint"),
//             ),
//             const SizedBox(height: 20),
//
//             // Display fingerprint scan result
//             Text(
//               "Scan Result: $result",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
