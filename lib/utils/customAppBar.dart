import 'package:dotmik_app/screen/home/home_bottombar_screen.dart';
import 'package:flutter/material.dart';
import 'package:dotmik_app/screen/notification_screen.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  _MainAppBarState createState() => _MainAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _controller.clear();
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4,
      leading: !_isSearching
          ? GestureDetector(
              onTap: showMenu,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Image.asset(
                    'assets/intro/image 128.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          : GestureDetector(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeBottomNavBar(
                              
                            )));
              },
            ),
      title: _isSearching
          ? Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
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
                  color: Color(0x3FA4A9AE),
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
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
              child: !_isSearching
                  ? Container(
                      width: 35.33,
                      height: 35,
                      decoration: ShapeDecoration(
                        color: Color(0x3FA4A9AE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23.50),
                        ),
                      ),
                      child: Icon(
                        Icons.notification_add_outlined,
                        size: 20,
                      ),
                    )
                  : Container(),
            ),
            SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  void showMenu() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Mr. Lalit',
                                style: TextStyle(
                                  color: Color(0xFF23303B),
                                  fontSize: 26,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Lrrao@1606',
                                style: TextStyle(
                                  color: Color(0xFF4E4C4C),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Container(
                                width: 200,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1CCD9D).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Kyc Status: ',
                                        style: TextStyle(
                                          color: Color(0xFF13C999),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
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
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Today’s Earning',
                                  style: TextStyle(
                                    color: Color(0xFF23303B),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  '₹ 230.30',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xFF23303B),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Image.asset("assets/intro/line.png"),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
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
                                  '₹ 12560550.23',
                                  style: TextStyle(
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
                            SizedBox(height: 20),
                            Text(
                              'Share Profile',
                              style: TextStyle(
                                color: Color(0xFF23303B),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                        "assets/images/whatsapp.jpeg")),
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                        "assets/images/insta.jpeg")),
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child:
                                        Image.asset("assets/images/fb.jpeg")),
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child:
                                        Image.asset("assets/images/more.jpeg")),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.50 - 46,
                  left: screenWidth / 2 - 46,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: AssetImage(
                      'assets/intro/image 128.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
