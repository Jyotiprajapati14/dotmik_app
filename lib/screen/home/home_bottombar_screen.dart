import 'dart:convert';
import 'package:dotmik_app/api/apiService.dart';
import 'package:dotmik_app/screen/Reports/reportScreen.dart';
import 'package:dotmik_app/screen/home/home_screen.dart';
import 'package:dotmik_app/screen/notification_screen.dart';
import 'package:dotmik_app/screen/profileScreen/profile_setting_screen.dart';
import 'package:dotmik_app/screen/wallet/transactionScreens.dart';
import 'package:dotmik_app/screen/wallet/wallet_screen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotmik_app/api/profileService.dart';
import 'package:share_me/share_me.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeBottomNavBar extends StatefulWidget {
  const HomeBottomNavBar({super.key});

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar> {
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? data;

  bool _isSearching = false;
  final Profileservice _profileService = Profileservice();
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _kycData;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Initialize data on page load
    _apiService.checkAuth(context);
    _checkInternetConnection();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? responseData = prefs.getString('responseData');
    print("the reponseData ${responseData}");
    // responseData['category_id'];
    if (responseData != null) {
      setState(() {
        data = json.decode(responseData);
        print("the data $data");
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _controller.clear();
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _refreshData() async {
    await _fetchUserProfile();
    // Optionally, you can refresh data for individual screens here as well
  }

  int _page = 0;
  List<Widget> get screens => [
        RefreshIndicator(
          onRefresh: _refreshData,
          child: HomeScreen(
            data: data!,
          ),
        ),
        RefreshIndicator(
          onRefresh: _refreshData,
          child: ReportScreen(),
        ),
        RefreshIndicator(
          onRefresh: _refreshData,
          child: const WalletScreen(),
        ),
        RefreshIndicator(
          onRefresh: _refreshData,
          child: const SettingScreen(),
        ),
      ];

  List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.wallet,
    Icons.settings,
  ];

  List<String> labels = [
    'Home',
    'Report',
    'Wallet',
    'Settings',
  ];

  Color _iconColor(int index) {
    return _page == index ? AppColors.red : Colors.grey;
  }

  PreferredSizeWidget getAppBar() {
    switch (_page) {
      case 0: // Home Screen
        return AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          leading: !_isSearching
              ? GestureDetector(
                  onTap: showMenu,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      // Display the user's profile image here
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          _userData?['profile'] ??
                              'assets/intro/default_profile.png',
                        ),
                        radius: 20,
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeBottomNavBar(),
                      ),
                    );
                  },
                ),
          title: _isSearching
              ? Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.black),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      debugPrint('Search submitted: $value');
                    },
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Image.asset(
                      'assets/intro/image 129.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: _toggleSearch,
                  child: Container(
                    width: 35.33,
                    height: 35,
                    decoration: ShapeDecoration(
                      color: const Color(0x3FA4A9AE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.50),
                      ),
                    ),
                    child: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()),
                      );
                    },
                    child: !_isSearching
                        ? Container(
                            width: 35.33,
                            height: 35,
                            decoration: ShapeDecoration(
                              color: const Color(0x3FA4A9AE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23.50),
                              ),
                            ),
                            child: const Icon(
                              Icons.notification_add_outlined,
                              size: 20,
                            ),
                          )
                        : Container()),
                const SizedBox(
                  width: 10,
                )
              ],
            )
          ],
        );
      case 1: // Report Screen
        return const CustomAppBar(titleText: "Report");
      case 2: // Wallet Screen
        return const CustomAppBar(titleText: "Wallet");
      case 3: // Settings Screen
        return const CustomAppBar(titleText: "Setting");
      default:
        return AppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldClose = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you really want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return shouldClose ?? false;
      },
      child: Scaffold(
        appBar: getAppBar(),
        backgroundColor: Colors.grey,
        body: _isConnected ? Center(child: _isSearching ? Container() : screens[_page]) : const Text('No Internet Connection'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MobileNumberScreen()),
            );
          },
          backgroundColor: AppColors.red,
          foregroundColor: Colors.white,
          tooltip: 'Add',
          child: const Icon(Icons.add, size: 32),
          shape: const CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _page = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.home, color: _iconColor(0)),
                    Text('Home', style: TextStyle(color: _iconColor(0))),
                  ],
                ),
              ),
              const SizedBox(width: 35),
              InkWell(
                onTap: () {
                  setState(() {
                    _page = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.search, color: _iconColor(1)),
                    Text('Report', style: TextStyle(color: _iconColor(1))),
                  ],
                ),
              ),
              const SizedBox(width: 80),
              InkWell(
                onTap: () {
                  setState(() {
                    _page = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.wallet, color: _iconColor(2)),
                    Text('Wallet', style: TextStyle(color: _iconColor(2))),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              InkWell(
                onTap: () {
                  setState(() {
                    _page = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.settings, color: _iconColor(3)),
                    Text('Settings', style: TextStyle(color: _iconColor(3))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void showMenu() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;

          return FutureBuilder<void>(
            future: _fetchUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Failed to load user data.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (_userData == null || _kycData == null) {
                return const Center(
                  child: Text(
                    'No user data available.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final userName = _userData!['name'] ?? 'N/A';
              final userId = _userData!['username'] ?? 'N/A';
              final kycStatus =
                  _kycData!['aadhaar'] != null ? 'Completed' : 'Pending';
              final todayEarnings = _userData!['wallet'] ?? '0.00';
              final totalEarnings = _userData!['wallet'] ?? '0.00';
              final profileImage =
                  _userData!['profile'] ?? 'assets/intro/default_profile.png';

              return GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Scaffold(
                  backgroundColor: Colors.black87.withOpacity(0.5),
                  body: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      userName,
                                      style: const TextStyle(
                                        color: Color(0xFF23303B),
                                        fontSize: 26,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      userId,
                                      style: const TextStyle(
                                        color: Color(0xFF4E4C4C),
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Container(
                                      width: 210,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            const Color(0xFF1CCD9D).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'KYC Status: ',
                                              style: TextStyle(
                                                color: Color(0xFF13C999),
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              kycStatus,
                                              style: const TextStyle(
                                                color: Color(0xFF13C999),
                                                fontSize: 16,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       'Today’s Earning',
                                  //       style: TextStyle(
                                  //         color: Color(0xFF23303B),
                                  //         fontSize: 20,
                                  //         fontFamily: 'Poppins',
                                  //         fontWeight: FontWeight.w600,
                                  //         height: 0,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       '₹ $todayEarnings',
                                  //       textAlign: TextAlign.right,
                                  //       style: TextStyle(
                                  //         color: Color(0xFF23303B),
                                  //         fontSize: 20,
                                  //         fontFamily: 'Poppins',
                                  //         fontWeight: FontWeight.w700,
                                  //         height: 0,
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  // SizedBox(height: 10),
                                  Image.asset("assets/intro/line.png"),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Earning',
                                        style: TextStyle(
                                          color: Color(0xFF23303B),
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                      Text(
                                        '₹ $totalEarnings',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                          letterSpacing: 0.20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Share Profile',
                                    style: TextStyle(
                                      color: Color(0xFF23303B),
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () => _shareProfile('whatsapp'),
                                        child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                "assets/images/whatsapp.jpeg")),
                                      ),
                                      GestureDetector(
                                        onTap: () => _shareProfile('instagram'),
                                        child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                "assets/images/insta.jpeg")),
                                      ),
                                      GestureDetector(
                                        onTap: () => _shareProfile('facebook'),
                                        child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                "assets/images/fb.jpeg")),
                                      ),
                                      GestureDetector(
                                        onTap: () => _shareProfile('more'),
                                        child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                "assets/images/more.jpeg")),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.52 - 46,
                        left: screenWidth / 2 - 46,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(profileImage),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void _shareProfile(String platform) {
    String profileUrl =
        'https://b2b.shantipe.com/'; // Replace with the actual profile URL
    String message = 'Check out my profile on this awesome app!';

    // Customize the share content based on the platform
    String title = '';
    String description = '';

    switch (platform) {
      case 'whatsapp':
        title = 'Share on WhatsApp';
        description = message;
        break;
      case 'instagram':
        title = 'Share on Instagram';
        description = message;
        break;
      case 'facebook':
        title = 'Share on Facebook';
        description = message;
        break;
      case 'more':
        title = 'Share Profile';
        description = message;
        break;
      default:
        title = 'Share Profile';
        description = message;
        break;
    }

    ShareMe.system(
      title: title,
      url: profileUrl,
      description: description,
    );
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await _profileService.fetchUserData(context);
      setState(() {
        _userData = response['data']['userProfile']['userData'];
        _kycData = response['data']['userProfile']['kycData'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
 // Method to check internet connection
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("internet is ........... $_isConnected");
      setState(() {
        _isConnected = false; // No internet connection
      });
      _showNoInternetDialog();  // Show alert if no internet
    } else {
      setState(() {
        _isConnected = true; // Internet is connected
      });
    }
  }

  // Optional: Show a dialog or snackbar when there is no internet connection
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your internet settings and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


}
