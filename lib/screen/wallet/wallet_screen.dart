import 'package:dotmik_app/api/profileService.dart';
import 'package:dotmik_app/api/walletService.dart';
import 'package:dotmik_app/screen/Reports/reportScreen.dart';
import 'package:dotmik_app/screen/wallet/companyBankListScreen.dart';
import 'package:dotmik_app/screen/wallet/transactionScreens.dart';
import 'package:flutter/material.dart';

class TransactionData {
  final String profileImageUrl;
  final String name;
  final String details;

  TransactionData({
    required this.profileImageUrl,
    required this.name,
    required this.details,
  });
}

class TransactionUtils {
  static List<TransactionData> getTransactions() {
    return [
      TransactionData(
        profileImageUrl: "assets/images/Mobile Tick.png",
        name: "Payout Successful",
        details: "Your Payout Was Succeed , Thank You",
      ),
      TransactionData(
        profileImageUrl: "assets/images/E Wallet.png",
        name: "E-Wallet Connected To Account",
        details: "E-Wallet has connected to Account",
      ),
      TransactionData(
        profileImageUrl: "assets/images/Free Cancellation.png",
        name: "Recharge Failed ❌",
        details: "Mobile recharge of 233 rs. is failed ",
      ),
      TransactionData(
        profileImageUrl: "assets/images/Verification List.png",
        name: "2 Step Verification Done ✅",
        details: "Your Account has been verified by 2 steps ",
      ),
      // Add more TransactionData objects here as needed
    ];
  }
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final Walletservice _walletService = Walletservice();
  bool _isLoading = false;
  final Profileservice _profileService = Profileservice();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await _profileService.fetchUserData(context);
      setState(() {
        _userData = response['data']['userProfile']['userData'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showCompanyBanks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<dynamic> banks = await _walletService.companyBanklist();

      if (banks.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CompanyBanksScreen(banks: banks),
        ));
      } else {
        _showMessage('No banks available.');
      }
    } catch (e) {
      print('Error: $e');
      _showMessage('Failed to fetch banks.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// _showMessage method to display messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 148,
              child: Stack(
                children: [
                  Positioned(
                    left: 80,
                    top: 49,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '₹ ',
                            style: TextStyle(
                              color: Color(0xFF616161),
                              fontSize: 36,
                              fontFamily: 'Spartan',
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: 1,
                            ),
                          ),
                          TextSpan(
                            text: _userData?['wallet'] ?? '0.00',
                            style: TextStyle(
                              color: Color(0xFF616161),
                              fontSize: 36,
                              fontFamily: 'Poller One',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 1,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Color(0xFF616161),
                              fontSize: 32,
                              fontFamily: 'Spartan',
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80,
                    top: 20,
                    child: Text(
                      'Total Wallet Balance',
                      style: TextStyle(
                        color: Color(0xFFC63F3F),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 111,
                    top: 105,
                    child: GestureDetector(
                      onTap: _showCompanyBanks,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.redAccent, Colors.red],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'Add Balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MobileNumberScreen()));
                  // showFilter();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.search_outlined,
                      size: 25,
                      color: Colors.black,
                    ),
                    Text(
                      'Search Users / Contact',
                      style: TextStyle(
                        color: Color(0xCC696D78),
                        fontSize: 13.55,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Padding(
            //     padding: EdgeInsets.only(left:12 , right: 12),
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               'Mr. Lalit',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 color: Color(0xFFC63F3F),
            //                 fontSize: 23,
            //                 fontFamily: 'Poppins',
            //                 fontWeight: FontWeight.w600,
            //                 height: 0,
            //                 letterSpacing: 1,
            //               ),
            //             ),
            //             Text(
            //               '+91 23658491',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 color: Color(0xFF616161),
            //                 fontSize: 15,
            //                 fontFamily: 'Poppins',
            //                 fontWeight: FontWeight.w400,
            //                 height: 0,
            //               ),
            //             ),
            //           ],
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               'lrrao@1606',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 color: Color(0xFF616161),
            //                 fontSize: 15,
            //                 fontFamily: 'Poppins',
            //                 fontWeight: FontWeight.w600,
            //                 height: 0,
            //               ),
            //             ),
            //             SizedBox(width: 100,),
            //             Text(
            //               'Retailer',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 color: Color(0xFF616161),
            //                 fontSize: 15,
            //                 fontFamily: 'Poppins',
            //                 fontWeight: FontWeight.w400,
            //                 height: 0,
            //               ),
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //           ],
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             Row(
            //               children: [
            //                 //  Image.asset(""),
            //                 Text(
            //                   'Enter Amount',
            //                   style: TextStyle(
            //                     color: Color(0xD8616161),
            //                     fontSize: 12,
            //                     fontFamily: 'Poppins',
            //                     fontWeight: FontWeight.w400,
            //                     height: 0.14,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             SizedBox(width: 130),
            //             CustomEditButton(
            //               color: Colors.red,
            //               text: 'Credit',
            //               imagePath: 'assets/intro/chevron-right.png',
            //               onPressed: () {
            //                 Navigator.of(context).push(
            //                   MaterialPageRoute(
            //                     builder: (context) => ProfileScreen(),
            //                   ),
            //                 );
            //               },
            //             ),
            //           ],
            //         ),
            //       ],
            //     )),
            // SizedBox(height: 20),
            // _buildTransactionCards(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCards() {
    final List<TransactionData> transactions =
        TransactionUtils.getTransactions();

    if (transactions.isEmpty) {
      return Text('No transactions found.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Transactions",
          style: TextStyle(
            color: Color(0xFFC63F3F),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            print('Transaction $index: $transaction');
            return _buildTransactionCard(
              profileImageUrl: transaction.profileImageUrl,
              name: transaction.name,
              details: transaction.details,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionCard({
    required String profileImageUrl,
    required String name,
    required String details,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            child: Image.asset(profileImageUrl),
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
                SizedBox(height: 5),
                Text(
                  details,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showFilter() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Text(
                'All Filter ',
                style: TextStyle(
                  color: Color(0xFFC63F3F),
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 394,
                height: 0.50,
                decoration: ShapeDecoration(
                  color: Color(0x7FD9D9D9),
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Sort Results',
                style: TextStyle(
                  color: Color(0xFFC63F3F),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
