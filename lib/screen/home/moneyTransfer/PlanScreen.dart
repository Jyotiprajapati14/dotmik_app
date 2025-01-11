
import 'package:dotmik_app/screen/home/moneyTransfer/phoneRecharge/rechageform_screen.dart';
import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';
import 'package:dotmik_app/api/mobileService.dart';

class PlansPage extends StatefulWidget {
  final String operatorName;
  final String selectedOperatorCode;
  final String phoneNumber;

  PlansPage({
    required this.operatorName,
    required this.selectedOperatorCode,
    required this.phoneNumber,
  });

  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  bool _loading = true;
  Map<String, dynamic>? _plansData;
  String _searchQuery = '';
  MobileService service = MobileService();

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    final data = await service.getPlans(
        widget.operatorName, widget.selectedOperatorCode, context);
    if (data != null) {
      setState(() {
        _plansData = data;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Plans For ${widget.operatorName}"),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _plansData == null || _plansData!.isEmpty
              ? Center(
                  child: Text('No plans available.',
                      style: Theme.of(context).textTheme.bodyMedium))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: _updateSearchQuery,
                        decoration: InputDecoration(
                          labelText: 'Search by Price',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: PlansList(
                        data: _plansData!['data'],
                        operator: '${widget.operatorName}',
                        phoneNumber: '${widget.phoneNumber}',
                        searchQuery: _searchQuery,
                      ),
                    ),
                  ],
                ),
    );
  }
}


class PlansList extends StatelessWidget {
  final Map<String, dynamic> data;
  final String operator;
  final String phoneNumber;
  final String searchQuery;

  PlansList({
    required this.data,
    required this.operator,
    required this.phoneNumber,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = data['rechargePlans']['tabs'] as List;
    final plans = data['rechargePlans']['plans'] as List;

    // Filter plans based on the search query, matching if the price contains the search digits
    final filteredPlans = searchQuery.isEmpty
        ? plans
        : plans.where((plan) {
            final product = plan['productList'].first;
            return product['price'].toString().contains(searchQuery);
          }).toList();

    // Sort the filtered plans by price
    filteredPlans.sort((a, b) {
      final priceA = (a['productList'].first)['price'];
      final priceB = (b['productList'].first)['price'];
      return priceA.compareTo(priceB);
    });

    if (searchQuery.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: filteredPlans.length,
        itemBuilder: (context, index) {
          final plan = filteredPlans[index]['productList'].first;
          return PlanCard(
            plan: plan,
            Operator: operator,
            phoneNumber: phoneNumber,
          );
        },
      );
    } else {
      return DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            Material(
              color: Colors.blueAccent,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 4.0),
                tabs: tabs.map((tab) => Tab(text: tab['level'])).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: tabs.map((tab) {
                  final plansForTab = filteredPlans
                      .where((plan) => plan['level'] == tab['level'])
                      .expand((plan) => plan['productList'] as List)
                      .toList();
                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: plansForTab.length,
                    itemBuilder: (context, index) {
                      final plan = plansForTab[index];
                      return PlanCard(
                        plan: plan,
                        Operator: operator,
                        phoneNumber: phoneNumber,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
  }
}


class PlanCard extends StatefulWidget {
  final Map<String, dynamic> plan;
  final String Operator;
  final String phoneNumber;

  PlanCard(
      {required this.plan, required this.Operator, required this.phoneNumber});

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final additionalItems = plan['additional'] as List;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PLAN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '₹${plan['price']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VALIDITY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      '${plan['validity']} days',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DATA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      '${plan['data']} GB',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: additionalItems.map((item) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(item['iconUrl']),
                  radius: 15,
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            if (_showDescription)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  plan['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showDescription = !_showDescription;
                    });
                  },
                  child: Text(
                    _showDescription ? 'Hide details' : 'View details',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RechargePrepaidMobileScreen(
                                Amount: "${plan['price']}",
                                Operator: '${widget.Operator}',
                                phoneNumber: "${widget.phoneNumber}")));
                    // Handle buy action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Select',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

