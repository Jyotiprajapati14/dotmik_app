import 'package:dotmik_app/api/reportService.dart';
import 'package:dotmik_app/screen/Reports/transactionDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportDetailScreen extends StatefulWidget {
  final dynamic category;

  ReportDetailScreen({required this.category});

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  String _selectedStatus = 'all';
  bool _isLoading = false;
  List<Map<String, dynamic>> _reportData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _fromDateController.text = currentDate;
    _toDateController.text = currentDate;
  }

  Future<void> _fetchReportData() async {
    setState(() {
      _isLoading = true;
    });

    final reportService = Reportservice();

    try {
      final fetchedData = await reportService.getReportDetail(
        "${widget.category['key']}",
        context,
        page: 1,
        from: _fromDateController.text,
        to: _toDateController.text,
        search: _searchController.text,
        status: _selectedStatus,
      );

      // Debugging: Print the raw fetched data
      print('Fetched Data: $fetchedData');

      // Check if fetchedData is a Map and contains the expected keys
      if (fetchedData is Map<String, dynamic>) {
        final transactionReport = fetchedData['transactionReport'];

        // Debugging: Print transactionReport
        print('Transaction Report: $transactionReport');

        // Check if transactionReport is a Map
        if (transactionReport is Map<String, dynamic>) {
          final transactions = transactionReport['transactions'];

          // Debugging: Print each transaction and its 'request' body
          if (transactions is List<dynamic>) {
            for (var transaction in transactions) {
              if (transaction is Map<String, dynamic>) {
                print('Transaction: $transaction');
                var request = transaction['request'];

                // Print request body
                if (request is Map<String, dynamic>) {
                  var body = request['body'] as Map<String, dynamic>?;
                  print('Request Body: $body');
                } else {
                  print('Request is not a Map');
                }
              } else {
                print('Transaction is not a Map');
              }
            }

            setState(() {
              _reportData = List<Map<String, dynamic>>.from(
                  transactions.map((item) => item as Map<String, dynamic>));
            });
          } else {
            // If transactions is not a List, set _reportData to an empty list
            setState(() {
              _reportData = [];
            });
          }
        } else {
          // If transactionReport is not a Map, set _reportData to an empty list
          setState(() {
            _reportData = [];
          });
        }
      } else {
        // If fetchedData is not a Map, set _reportData to an empty list
        setState(() {
          _reportData = [];
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _reportData = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openFilterDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeFilterDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: IconButton(
            icon: Image.asset('assets/intro/back.png', fit: BoxFit.fill),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          "${widget.category['key']} Report"
              .split('-')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join('-'),
          style: TextStyle(
            color: Color(0xFF23303B),
            fontSize: 22,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(
                Icons.import_export_outlined,
                color: Colors.red,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _openFilterDrawer,
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(color: Colors.red))
                        : _reportData.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text('No data found.',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _reportData.length,
                                itemBuilder: (context, index) {
                                  final transaction = _reportData[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionDetailScreen(
                                                  transaction: transaction),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      margin: EdgeInsets.only(bottom: 12),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.red.shade50,
                                                  child: Text(
                                                    transaction['name']?[0] ??
                                                        'N',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        (transaction['name'] ??
                                                                transaction[
                                                                    'txn_type'] ??
                                                                transaction[
                                                                    'user_remark'] ??
                                                                transaction[
                                                                    'type'] ??
                                                                transaction[
                                                                    'other_user_name'] ??
                                                                transaction[
                                                                    'phone'] ??
                                                                transaction[
                                                                        'biller_name']
                                                                    ?.toString() ??
                                                                " ")
                                                            .toUpperCase(), // Convert to uppercase here
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        _formatDate(transaction[
                                                            'created_at']),
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  transaction['amount'] ??
                                                      transaction['rem_amount'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: _getStatusColor(
                                                        transaction['status'] ??
                                                            transaction[
                                                                'wallet_type'] ??
                                                            ''),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  transaction['mode'] ??
                                                      transaction[
                                                          'bank_name'] ??
                                                      "",
                                                  style: TextStyle(
                                                    color: _getStatusColor(
                                                        transaction['status'] ??
                                                            transaction[
                                                                'wallet_type'] ??
                                                            ''),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  (transaction['status'] ??
                                                          transaction[
                                                              'wallet_type'] ??
                                                          "")
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: _getStatusColor(
                                                        transaction['status'] ??
                                                            transaction[
                                                                'wallet_type'] ??
                                                            ''),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              // From Date Input
              TextField(
                controller: _fromDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'From Date',
                  labelStyle: TextStyle(color: Colors.red),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                onTap: () => _selectDate(context, _fromDateController),
              ),
              SizedBox(height: 16),
              // To Date Input
              TextField(
                controller: _toDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'To Date',
                  labelStyle: TextStyle(color: Colors.red),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                onTap: () =>
                    _selectDate(context, _toDateController, isToDate: true),
              ),
              SizedBox(height: 16),
              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                items: ['all', 'Pending', 'Completed', 'Failed'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                icon: Icon(Icons.arrow_drop_down, color: Colors.red),
                dropdownColor: Colors.red.shade50,
              ),
              SizedBox(height: 16),
              // Search Input
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.red),
                  suffixIcon: Icon(Icons.search, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Search Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 110),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the drawer
                  _fetchReportData();
                },
                child: Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    // Assuming dateString is in the format "yyyy-MM-ddTHH:mm:ss" or similar
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date); // Formats to "07 Sep 2024"
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller,
      {bool isToDate = false}) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Color _getStatusColor(String? status) {
    // Convert the status to lowercase for consistent comparison
    String statusLower = status?.toLowerCase() ?? '';

    switch (statusLower) {
      case 'success':
      case 'credit':
      case 'CREDIT':
      case 'SUCCESS':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
