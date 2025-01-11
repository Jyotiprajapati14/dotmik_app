import 'package:dotmik_app/screen/home/home_bottombar_screen.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:flutter/material.dart';

class NotificationData {
  final String profileImageUrl;
  final String name;
  final double amount;
  final String timestamp;

  NotificationData({
    required this.profileImageUrl,
    required this.name,
    required this.amount,
    required this.timestamp,
  });
}

class NotificationUtils {
  static List<NotificationData> getNotifications() {
    return [
      NotificationData(
        profileImageUrl: "https://via.placeholder.com/48x48",
        name: "Lindsey Culhane",
        amount: 780.1,
        timestamp: "9:01am",
      ),
      NotificationData(
        profileImageUrl: "https://via.placeholder.com/48x48",
        name: "Lindsey Culhane",
        amount: 780.1,
        timestamp: "9:01am",
      ),

      NotificationData(
        profileImageUrl: "https://via.placeholder.com/48x48",
        name: "Lindsey Culhane",
        amount: 780.1,
        timestamp: "9:01am",
      ),
      // Add more NotificationData objects here as needed
    ];
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeBottomNavBar(
                          
                        )));
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                'assets/intro/back.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Notification',
            style: TextStyle(
              color: Color(0xFF23303B),
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Today',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: NotificationUtils.getNotifications().length,
              itemBuilder: (context, index) {
                final notification =
                    NotificationUtils.getNotifications()[index];
                return Column(
                  children: [
                    _buildNotificationCard(
                      profileImageUrl: notification.profileImageUrl,
                      name: notification.name,
                      amount: notification.amount,
                      timestamp: notification.timestamp,
                      onPressed: () {
                        // Implement action on PAY button press
                      },
                    ),
                    SizedBox(
                        height: 10), // Add space between notification cards
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Color(0xFFEEEEEE), // Bottom line color
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Yesterday',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: NotificationUtils.getNotifications().length,
              itemBuilder: (context, index) {
                final notification =
                    NotificationUtils.getNotifications()[index];
                return Column(
                  children: [
                    _buildNotificationCard(
                      profileImageUrl: notification.profileImageUrl,
                      name: notification.name,
                      amount: notification.amount,
                      timestamp: notification.timestamp,
                      onPressed: () {
                        // Implement action on PAY button press
                      },
                    ),
                    SizedBox(
                        height: 10), // Add space between notification cards
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Color(0xFFEEEEEE), // Bottom line color
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'This Week',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: NotificationUtils.getNotifications().length,
              itemBuilder: (context, index) {
                final notification =
                    NotificationUtils.getNotifications()[index];
                return Column(
                  children: [
                    _buildNotificationCard(
                      profileImageUrl: notification.profileImageUrl,
                      name: notification.name,
                      amount: notification.amount,
                      timestamp: notification.timestamp,
                      onPressed: () {
                        // Implement action on PAY button press
                      },
                    ),
                    SizedBox(
                        height: 10), // Add space between notification cards
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Color(0xFFEEEEEE), // Bottom line color
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String profileImageUrl,
    required String name,
    required double amount,
    required String timestamp,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl),
            radius: 24,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'requested a payment of \$${amount.toString()}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  timestamp,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                    letterSpacing: 0.40,
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 15),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'PAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
