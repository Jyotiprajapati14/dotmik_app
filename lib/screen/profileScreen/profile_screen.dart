import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Future<Map<String, dynamic>> userDataFuture;
  final Future<Map<String, dynamic>> kycDataFuture;

  const ProfileScreen({
    Key? key,
    required this.userDataFuture,
    required this.kycDataFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Edit Profile"),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Future.wait([userDataFuture, kycDataFuture]).then((results) {
          return {
            'userData': results[0] as Map<String, dynamic>,
            'kycData': results[1] as Map<String, dynamic>,
          };
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final userData = snapshot.data!['userData'] as Map<String, dynamic>;
          final kycData = snapshot.data!['kycData'] as Map<String, dynamic>?;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(userData['profile'] ?? 'https://via.placeholder.com/150'),
                  backgroundColor: Colors.grey.shade200,
                ),
                SizedBox(height: 20),
                Text(
                  userData['name'] ?? 'Unknown',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC43F3E),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  userData['email'] ?? 'Unknown',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                // User Information
                _buildInfoCard(label: 'Name', value: userData['name']),
                _buildInfoCard(label: 'Email', value: userData['email']),
                _buildInfoCard(label: 'Mobile Number', value: userData['phone']),
                SizedBox(height: 20),
                // KYC Information
                if (kycData != null) ...[
                  _buildKycSection(title: 'KYC Information'),
                  SizedBox(height: 10),
                  _buildInfoCard(label: 'Aadhaar', value: kycData?['aadhaar_front'], isKyc: true),
                  _buildInfoCard(label: 'PAN', value: kycData?['pan_image'], isKyc: true),
                  _buildInfoCard(label: 'Address Line 1', value: kycData?['address'], isKyc: true),
                  _buildInfoCard(label: 'City', value: kycData?['city'], isKyc: true),
                  _buildInfoCard(label: 'State', value: kycData?['state'], isKyc: true),
                  _buildInfoCard(label: 'Pin Code', value: kycData?['pincode'], isKyc: true),
                ],
                SizedBox(height: 20),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Color(0xFFC63F3F),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(48),
                //     ),
                //     minimumSize: Size(185, 50),
                //   ),
                //   onPressed: () {},
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         'Start Now',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 17,
                //           fontFamily: 'Open Sans',
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       SizedBox(width: 8),
                //       Image.asset("assets/intro/chevron-right.png", width: 24, height: 24),
                //     ],
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({required String label, String? value, bool isKyc = false}) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isKyc ? Color(0x26A4A9AE) : Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isKyc ? Color(0x26A4A9AE) : Colors.transparent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: value != null && value.startsWith('http') ? 
            Padding(
              padding: const EdgeInsets.only(left:30 , right: 30),
              child: Image.network(value,height: 80, fit: BoxFit.fill),
            ) : 
            Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKycSection({required String title}) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0x26A4A9AE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
