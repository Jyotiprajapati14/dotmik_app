
import 'dart:convert';
import 'package:dotmik_app/api/bbpsService.dart';
import 'package:dotmik_app/screen/home/Broadband/fetchBillFormScreen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';

class BroadbandScreen extends StatefulWidget {
  final String encodedCategory;
  final String mode;

  const BroadbandScreen({
    Key? key,
    required this.encodedCategory,
    required this.mode,
  }) : super(key: key);

  @override
  _BroadbandScreenState createState() => _BroadbandScreenState();
}

class _BroadbandScreenState extends State<BroadbandScreen> {
  List<dynamic> _billers = [];
  List<dynamic> _filteredBillers = [];
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBillers();
    _searchController.addListener(() {
      _filterBillers();
    });
  }

  Future<void> _fetchBillers() async {
    setState(() {
      _isLoading = true; // Show loader
    });

    try {
      Bbpsservice service = Bbpsservice();
      List<dynamic> fetchedBillers = await service.broadbandDataList(context, widget.encodedCategory, widget.mode);
      setState(() {
        _billers = fetchedBillers;
        _filteredBillers = fetchedBillers;
      });
    } catch (e) {
      print("Error fetching billers: $e");
      // Optionally handle errors
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }

  void _filterBillers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBillers = _billers.where((biller) {
        return biller['biller_name'].toLowerCase().contains(query) ||
               biller['biller'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _fetchDetails(String id) async {
    setState(() {
      _isLoading = true; // Show loader
    });

    try {
      Bbpsservice service = Bbpsservice();
      Object result = await service.broadbandIdSend(context, id);

      if (result is Map<String, dynamic>) {
        Map<String, dynamic> details = result;
        int textBoxCount = details['text_box'] ?? 0;
        Map<String, dynamic> formParams = {};
        for (int i = 1; i <= textBoxCount; i++) {
          String paramKey = 'param$i';
          var paramData = details[paramKey];

          if (paramData is String) {
            try {
              var paramMap = jsonDecode(paramData) as Map<String, dynamic>;
              formParams[paramKey] = paramMap;
            } catch (e) {
              print("Error parsing JSON for '$paramKey': $e");
            }
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormScreen(
              formParams: formParams,
              billerId: id,
            ),
          ),
        );
      } else {
        print("Error: Expected a Map<String, dynamic> but received ${result.runtimeType}");
      }
    } catch (e) {
      print("An error occurred while fetching details: $e");
      // Handle errors
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: widget.mode,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _filteredBillers.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _filteredBillers.length,
                        itemBuilder: (context, index) {
                          final biller = _filteredBillers[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            elevation: 4,
                            child: ListTile(
                              title: Text(biller['biller_name']),
                              subtitle: Text(biller['biller'].toString()),
                              leading: Icon(Icons.credit_card),
                              onTap: () {
                                _fetchDetails(biller['id'].toString());
                              },
                            ),
                          );
                        },
                      ),
                if (_isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
