import 'dart:convert';
import 'package:dotmik_app/api/profileService.dart';
import 'package:flutter/material.dart';

class CommissionScreen extends StatefulWidget {
  const CommissionScreen({Key? key}) : super(key: key);

  @override
  _CommissionScreenState createState() => _CommissionScreenState();
}

class _CommissionScreenState extends State<CommissionScreen> {
  final Profileservice _profileService = Profileservice();
  bool _isLoading = true;
  List<dynamic> _commissionPlans = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await _profileService.fetchComission(context);
      if (response is Map<String, dynamic>) {
        final commissionPlans = response['data']['commissionPlan'];
        if (commissionPlans is List) {
          setState(() {
            _commissionPlans = commissionPlans;
            _isLoading = false;
          });
        } else {
          throw Exception(
              'Unexpected type for commissionPlan: ${commissionPlans.runtimeType}');
        }
      } else {
        throw Exception('Unexpected response format: ${response.runtimeType}');
      }
    } catch (e) {
      print('Error fetching commission plans: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Commission Plans',
          style: TextStyle(
            color: Color(0xFF23303B),
            fontSize: 22,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _commissionPlans.length,
              itemBuilder: (context, index) {
                final plan = _commissionPlans[index] as Map<String, dynamic>;
                final headers = plan['headers'] as Map<String, dynamic>;
                
                final data = plan['data'];
                List<Map<String, dynamic>> rows = [];
                if (data is List) {
                  rows = data.map((item) {
                    if (item is Map<String, dynamic>) {
                      return item;
                    }
                    return <String, dynamic>{};
                  }).toList();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan['label'] ?? '',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: MaterialStateProperty.all(Colors.blueAccent),
                          headingTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          dataTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          columns: headers.entries.map((entry) {
                            return DataColumn(
                              label: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(entry.value as String),
                              ),
                            );
                          }).toList(),
                          rows: rows.map((row) {
                            return DataRow(
                              cells: headers.keys.map((key) {
                                return DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(row[key]?.toString() ?? 'N/A'),
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
    );
  }
}
