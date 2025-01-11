import 'dart:async';
import 'dart:convert';
import 'package:dotmik_app/api/bbpsService.dart';
import 'package:dotmik_app/screen/bbps/billsform.dart';
import 'package:dotmik_app/screen/bbps/cablebillform.dart';
import 'package:dotmik_app/screen/bbps/loanpaymentform.dart';
import 'package:dotmik_app/screen/bbps/waterbillform.dart';
import 'package:dotmik_app/screen/home/Broadband/broadbandPostpaid.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class BbpsScreen extends StatefulWidget {
  final String encodedCategory;
  final String mode;
  final Map<dynamic, dynamic> data;

  const BbpsScreen(
      {Key? key,
      required this.encodedCategory,
      required this.mode,
      required this.data})
      : super(key: key);
  @override
  State<BbpsScreen> createState() => _BBPsScreenState();
}

class _BBPsScreenState extends State<BbpsScreen> {
  Future<List<dynamic>>? _categoryFuture;
  String encodedCategory = '';

  @override
  void initState() {
    super.initState();

    if (widget.data != null && widget.data.isNotEmpty) {
      _categoryFuture = Bbpsservice().fetchCatgoryList(context);
      debugCategorychange(widget.data['data'] as Map<dynamic, dynamic>?);
      print("widget data: ${widget.data}");
    } else {
      print("Widget data is null or empty");
    }
  }

  void debugCategorychange(Map<dynamic, dynamic>? data) {
    if (data != null &&
        data.containsKey('service') &&
        data['service'] is Map &&
        data['service'].containsKey('utility') &&
        data['service']['utility'] is Map &&
        data['service']['utility'].containsKey('data') &&
        data['service']['utility']['data'] is List) {
      List<dynamic> dataList = data['service']['utility']['data'];

      for (var entry in dataList) {
        String categoryName = entry['category_name'] ?? '';
        int categoryId = entry['category_id'] ?? 0;
        String categoryIdStr = categoryId.toString(); // Convert int to String

        setState(() {
          encodedCategory = base64.encode(utf8.encode(categoryIdStr));
          print("the encodedCategory that $encodedCategory");
        });
      }
    } else {
      print("Data is null or missing necessary keys.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'BBPS',
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(child: CarouselSliderWidget()),
            SizedBox(height: 20),
            Text(
              'Bill Payment by BBPS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFC63F3F),
                fontSize: 17,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _categoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final categories = snapshot.data!;
                    return ContainerList(categories: categories, encodedCategory: '$encodedCategory' , );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ContainerList extends StatelessWidget {
//   final List<dynamic> categories;
//   final String encodedCategory ;

//   ContainerList({required this.categories , required this.encodedCategory});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 2,
//         mainAxisSpacing: 10.0,
//         crossAxisSpacing: 10.0,
//       ),
//       padding: EdgeInsets.all(10.0),
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         final color = const Color.fromARGB(255, 134, 186,
//             228); // You can set different colors based on your needs
//         final text = category['category_name'];
//         final logoUrl = category['logo']; // Image URL from the API
        
//         final mode = ''; // You can set this dynamically based on your needs

//         return GestureDetector(
//           onTap: () {
          
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => BroadbandScreen(
//                   encodedCategory: '$encodedCategory',
//                   mode: text,
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             width: 181.6,
//             height: 43,
//             padding: EdgeInsets.all(10.0),
//             decoration: BoxDecoration(
//               color: Color.fromARGB(197, 200, 224, 248),
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: color,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: logoUrl != null && logoUrl.isNotEmpty
//                       ? Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Image.network(
//                             logoUrl,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       : Icon(
//                           Icons
//                               .image, // Placeholder icon if no image URL is available
//                           color: Colors.black,
//                         ),
//                 ),
//                 SizedBox(width: 10.0),
//                 Flexible(
//                   child: Text(
//                     encodedCategory,
//                     style: TextStyle(
//                       color: const Color.fromARGB(255, 41, 41, 41),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }


class ContainerList extends StatelessWidget {
  final List<dynamic> categories;
  final String encodedCategory;

  ContainerList({required this.categories, required this.encodedCategory});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      padding: EdgeInsets.all(10.0),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final color = const Color.fromARGB(255, 134, 186, 228); // Category box color
        final categoryName = category['category_name']; // Fetch the category name
        final logoUrl = category['logo']; // Fetch the image URL
        final categoryId = category['category_id']; // Fetch the category ID
        final categoryIdStr = categoryId.toString(); // Convert ID to string
        final encodedCategoryId = base64.encode(utf8.encode(categoryIdStr)); // Encode the category ID

        return GestureDetector(
          onTap: () {
            // Navigate to the next screen with the encoded category ID and mode
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BroadbandScreen(
                  encodedCategory: encodedCategoryId, // Pass the encoded category ID
                  mode: categoryName, // Pass the category name or mode
                ),
              ),
            );
          },
          child: Container(
            width: 181.6,
            height: 43,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(197, 200, 224, 248),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: logoUrl != null && logoUrl.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            logoUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.image, // Placeholder icon if no image URL is available
                          color: Colors.black,
                        ),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    categoryName, // Display the category name
                    style: TextStyle(
                      color: const Color.fromARGB(255, 41, 41, 41),
                      fontWeight: FontWeight.bold,
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

  Widget _getFormScreen(String categoryName) {
    switch (categoryName) {
      case 'Cable TV':
        return CableBillsFormScreen();
      case 'Loan Payment':
        return LoanBillsFormScreen();
      case 'Gas Bill':
        return GasBillsFormScreen();
      case 'Water Bill':
        return WaterBillsFormScreen();
      default:
        return Container(); // Default empty container for unknown categories
    }
  }

  void _launchURL() async {
    final Uri url = Uri.parse('https://b2b.shantipe.com/user/insurance/index');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

class CarouselSliderWidget extends StatefulWidget {
  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final List<String> images = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 145,
            aspectRatio: 2.6,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: images.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.fill,
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
                      )
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return Container(
              width: _current == entry.key ? 16 : 32,
              height: 8,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: ShapeDecoration(
                color: _current == entry.key ? Color(0xFFC63F3F) : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
