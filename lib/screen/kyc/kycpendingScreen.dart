import 'package:dotmik_app/api/apiService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycPendingScreen extends StatefulWidget {
  @override
  _KycPendingScreenState createState() => _KycPendingScreenState();
}

class _KycPendingScreenState extends State<KycPendingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = true;

  void _scrollToBottomAndFetch() async {
    // Animate scroll to the bottom
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );

    // Call the fetchDashboard method
    ApiService apiService = ApiService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? authKey = prefs.getString('Authkey');

    if (token != null && authKey != null) {
      apiService.fetchDashboard(context, token, authKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // The content of the screen
          SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                  // Display the image
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3 , // Keep it proportional
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/intro/cuate (1).png'), // Your image asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Display the KYC Pending text
                  Text(
                    'KYC Pending',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your KYC process is still pending. Please complete it to proceed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 100), // Space for the button
                ],
              ),
            ),
          ),
          // Animated Scroll Button
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            bottom: _isButtonVisible ? 50 : -20, // Hide button off-screen
            left: MediaQuery.of(context).size.width / 2 - 30, // Center horizontally
            child: FloatingActionButton(
              onPressed: () {
                _scrollToBottomAndFetch();
                setState(() {
                  _isButtonVisible = false;
                });
              },
              child: Icon(Icons.arrow_downward),
              backgroundColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
