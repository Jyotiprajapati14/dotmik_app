import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dotmik_app/screen/CreditCardBillPayment/LoginScreen.dart';
import 'package:dotmik_app/screen/aepsBalance/demyaeps.dart';
import 'package:dotmik_app/screen/bbps/bbps_screen.dart';
import 'package:dotmik_app/screen/dmt/remitterlogin_screen.dart';
import 'package:dotmik_app/screen/fundtransfer/fundLoginScreen.dart';
import 'package:dotmik_app/screen/home/Broadband/broadbandPostpaid.dart';
import 'package:dotmik_app/screen/home/dthrecharge/DthRechargeScreen.dart';
import 'package:dotmik_app/screen/home/moneyTransfer/phoneRecharge/rechageform_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  const HomeScreen({super.key, required this.data});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String encodedCategory = '';

  @override
  void initState() {
    super.initState();
    debugDataKeys(widget.data['data']);
    debugCategorychange(widget.data['data']);
  }

  void debugDataKeys(Map<dynamic, dynamic> data) {
    if (data != null) {
      data.forEach((key, value) {});
    }
  }

  void debugCategorychange(Map<dynamic, dynamic> data) {
    print("Data is null.  ${data['service']} ");
    if (data == null) {
      print("Data is null.  $data");
      return;
    }

    if (!data.containsKey('service')) {
      print("Data does not contain 'service' key.");
      return;
    }

    if (data['service'] == null) {
      print("Data['service'] is null.");
      return;
    }

    if (!data['service'].containsKey('utility')) {
      print("${data['service']} does not contain 'utility' key.");
      return;
    }

    if (data['service']['utility'] == null) {
      print("Data['service']['utility'] is null.");
      return;
    }

    if (!data['service']['utility'].containsKey('data')) {
      print("Data['service']['utility'] does not contain 'data' key.");
      return;
    }

    List<dynamic> dataList = data['service']['utility']['data'];
    if (dataList == null) {
      print("Data['service']['utility']['data'] is null.");
      return;
    }

    if (dataList.isEmpty) {
      print("Data['service']['utility']['data'] is empty.");
      return;
    }

    print("The dataList: $dataList");

    for (var entry in dataList) {
      try {
        // Check if entry is a Map
        if (entry is Map<dynamic, dynamic>) {
          String categoryName = entry['category_name'] ?? '';
          int categoryId = entry['category_id'] ?? 0;
          String categoryIdStr = categoryId.toString(); // Convert int to String

          // Convert category ID to Base64 and store it in the state variable
          setState(() {
            encodedCategory = base64.encode(utf8.encode(categoryIdStr));
          });

          print(
              "Category Name: $categoryName, Category ID: $categoryId, Encoded Category: $encodedCategory");
        } else {
          print("Entry is not a Map: $entry");
        }
      } catch (e) {
        print("Exception occurred while processing entry: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data['data'] as Map<dynamic, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: CarouselSliderWidget(
                  images: _getImageList(data['banners']),
                  screensOrLinks: _getScreensOrLinks(data['banners']),
                ),
              ),
              SizedBox(height: 10),
              ContinuousTextAnimation(),
              SizedBox(height: 10),

              // Handle 'service' key
              if (data['service'] != null)
                ..._buildExpandableContainers(
                    data['service'], 'service', "$encodedCategory"),

              // Handle 'utility' key
              if (data['utility'] != null)
                _buildExpandableContainer(
                    data['utility'], 'utility', "$encodedCategory"),

              if (data['insurance'] != null)
                _buildExpandableContainer(
                    data['insurance'], 'insurance', "$encodedCategory"),

              // Handle 'toppicks' key
              if (data['toppicks'] != null)
                _buildExpandableContainer(
                    data['toppicks'], 'toppicks', "$encodedCategory"),

              SizedBox(height: 20),
              Center(
                child: CarouselSliderWidget(
                  images: _getImageList(data['otherService']),
                  screensOrLinks: _getScreensOrLinks(data['otherService']),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getImageList(dynamic data) {
    if (data == null || data['data'] == null) return [];
    return (data['data'] as List<dynamic>? ?? [])
        .map<String>(
            (item) => (item as Map<String, dynamic>)['image'] as String? ?? '')
        .toList();
  }

  List<String> _getScreensOrLinks(dynamic data) {
    if (data == null || data['data'] == null) return [];
    return (data['data'] as List<dynamic>? ?? [])
        .map<String>(
            (item) => (item as Map<String, dynamic>)['link'] as String? ?? '')
        .toList();
  }

  List<Widget> _buildExpandableContainers(
      Map<dynamic, dynamic> data, String groupType, String encodedCategory) {
    List<Widget> containers = [];
    data.forEach((key, value) {
      if (value is Map<dynamic, dynamic> && value['isLabelShow'] == true) {
        containers.add(
          _buildExpandableContainer(value, groupType, encodedCategory),
        );
      }
    });
    return containers;
  }

  Widget _buildExpandableContainer(
      Map<dynamic, dynamic> data, String groupType, String encodedCategory) {
    final List<String> images = _getImageListForType(data, groupType);
    final List<String> titles = (data['data'] as List<dynamic>? ?? [])
        .map<String>((item) =>
            (item as Map<String, dynamic>)['service_name'] as String? ??
            (item as Map<String, dynamic>)['category_name'] as String? ??
            (item as Map<String, dynamic>)['name'] as String? ??
            '')
        .toList();
    final List<String> screensOrLinks = (data['data'] as List<dynamic>? ?? [])
        .map<String>((item) =>
            (item as Map<String, dynamic>)['link'] as String? ??
            (item as Map<String, dynamic>)['mode'] as String? ??
            '')
        .toList();

    // Debug the links
    screensOrLinks.forEach((link) {});

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: ExpandableContainer(
        title: data['label'] as String? ?? '',
        images: images,
        titles: titles,
        screensOrLinks: screensOrLinks,
        encodedCategory: '$encodedCategory',
        data: widget.data['data'],
      ),
    );
  }

  List<String> _getImageListForType(
      Map<dynamic, dynamic> data, String groupType) {
    if (data['data'] == null) return [];
    switch (groupType) {
      case 'utility':
        final images = (data['data'] as List<dynamic>? ?? [])
            .map<String>((item) =>
                (item as Map<String, dynamic>)['image'] as String? ?? '')
            .toList();
        return images;
      case 'insurance':
        final images = (data['data'] as List<dynamic>? ?? [])
            .map<String>((item) =>
                (item as Map<String, dynamic>)['image'] as String? ?? '')
            .toList();
        return images;
      case 'service':
        final images = (data['data'] as List<dynamic>? ?? [])
            .map<String>((item) =>
                (item as Map<String, dynamic>)['logo'] as String? ??
                (item as Map<String, dynamic>)['image'] as String? ??
                '')
            .toList();
        return images;
      default:
        final images = (data['data'] as List<dynamic>? ?? [])
            .map<String>((item) =>
                (item as Map<String, dynamic>)['image'] as String? ?? '')
            .toList();
        return images;
    }
  }
}

class ExpandableContainer extends StatelessWidget {
  final String title;
  final List<String> images;
  final List<String> titles;
  final List<String> screensOrLinks;
  final String encodedCategory;
  final Map<dynamic, dynamic> data;

  const ExpandableContainer({
    Key? key,
    required this.data,
    required this.title,
    required this.images,
    required this.titles,
    required this.screensOrLinks,
    required this.encodedCategory,
  }) : super(key: key);

  void _navigateToScreen(
    BuildContext context,
    String serviceName,
    String encodedCategory,
    String decoded,
    String link,
  ) {
    if (serviceName == 'Domestic Money Transfer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DmtLoginFormScreen()),
      );
    } else if (serviceName == 'Fund Transfer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FundTranferLoginFormScreen()),
      );
    } else if (serviceName == 'Credit Card Bill Payment') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreditCardLoginScreen()),
      );
    } else if (serviceName == 'Dth Recharge') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RechargeDthScreen()),
      );
    } else if (serviceName == 'Mobile Recharge') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RechargePrepaidMobileScreen(
            Amount: '',
            Operator: '',
            phoneNumber: '',
          ),
        ),
      );
          } else if (serviceName == 'AePS') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dummyaeps()
        ),
      );
    } else if (serviceName == 'Broadband Postpaid' || serviceName == 'Electricity' || serviceName == 'Gas' || serviceName == 'LPG GAS' || serviceName == 'Mobile Postpaid' || serviceName == 'Water') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BroadbandScreen(
              encodedCategory: encodedCategory, mode: serviceName),
        ),
      );
    } else {
      _launchURL(link);
    }
  }

  void _navigateToMore(BuildContext context, String groupType) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BbpsScreen(
              encodedCategory: encodedCategory, mode: '', data: data!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int itemsCount = images.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 240, 37, 37),
                ),
              ),
              if (title ==
                  'Utility') // Check for 'Utility' title to show 'View More'
                TextButton(
                  onPressed: () => _navigateToMore(context, 'utility'),
                  child: Row(
                    children: [
                      Text(
                        'View More',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true, // To avoid scrolling inside the GridView
          physics:
              NeverScrollableScrollPhysics(), // Disable scrolling in GridView
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of items per row
            crossAxisSpacing: 7.0, // Space between items
            mainAxisSpacing: 10.0, // Space between rows
          ),
          itemCount: itemsCount,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                String serviceName = titles[index];
                String link = screensOrLinks[index];
                _navigateToScreen(
                    context,
                    serviceName,
                    encodedCategory, // Pass encoded category name
                    screensOrLinks[index],
                    link);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: images[index].endsWith('.svg')
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.network(
                              images[index],
                              fit: BoxFit.contain,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }
}

class ContinuousTextAnimation extends StatefulWidget {
  @override
  _ContinuousTextAnimationState createState() =>
      _ContinuousTextAnimationState();
}

class _ContinuousTextAnimationState extends State<ContinuousTextAnimation> {
  double _position = 0.0;
  Timer? _timer;
  final double _containerWidth = 431.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    const duration = Duration(milliseconds: 16);
    const textWidth = 263.0;
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        _position -= 1;
        if (_position <= -textWidth) {
          _position = _containerWidth;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _containerWidth,
      height: 37,
      decoration: BoxDecoration(color: Color(0xFFC63F3F)),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 0),
        transform: Matrix4.translationValues(_position, 0, 0),
        child: Center(
          child: Text(
            'Welcome to DotMik Software !',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselSliderWidget extends StatelessWidget {
  final List<String> images;
  final List<dynamic> screensOrLinks;

  const CarouselSliderWidget({
    super.key,
    required this.images,
    required this.screensOrLinks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = images[index];
            final destination =
                screensOrLinks.isNotEmpty ? screensOrLinks[index] : null;

            return GestureDetector(
              onTap: () {
                if (destination != null) {
                  if (destination is Widget) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => destination),
                    );
                  } else if (destination is String) {
                    _launchURL(destination);
                  }
                }
                // If destination is null or empty, do nothing on tap
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.fill, // Changed to cover
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 175,
            aspectRatio: 16 / 9, // Changed to 16/9
            viewportFraction: 1.0, // Changed to full width
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false, // Changed to false
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {},
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return screensOrLinks.isEmpty
                ? Container(
                    width: entry.key == entry.key ? 16 : 32,
                    height: 8,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: ShapeDecoration(
                      color: entry.key == entry.key
                          ? Color(0xFFC63F3F)
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 10,
                  );
          }).toList(),
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }
}
