import 'package:dotmik_app/screen/Reports/reportDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:dotmik_app/api/reportService.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<dynamic>> _reportCategories;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _reportCategories = _fetchReportCategories();
  }

  Future<List<dynamic>> _fetchReportCategories() async {
    final Reportservice reportService = Reportservice();
    try {
      final categories = await reportService.fetchCatgoryList(context);
      setState(() {
        _isLoading = false;
      });
      return categories;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return [];
    }
  }

  Future<void> _refreshCategories() async {
    setState(() {
      _isLoading = true;
      _reportCategories = _fetchReportCategories();
    });
    await _reportCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshCategories,
              child: FutureBuilder<List<dynamic>>(
                future: _reportCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No categories found.'));
                  } else {
                    final categories = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1 / 1,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportDetailScreen(
                                    category: category,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      category['value'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
