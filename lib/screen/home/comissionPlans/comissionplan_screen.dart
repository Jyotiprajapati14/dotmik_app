import 'package:dotmik_app/utils/Appbar/appbarUtils.dart';
import 'package:flutter/material.dart';

class ComissionScreen extends StatefulWidget {
  const ComissionScreen({Key? key}) : super(key: key);

  @override
  _ComissionScreenState createState() => _ComissionScreenState();
}

class _ComissionScreenState extends State<ComissionScreen> {
  late String _selectedTab;
  late List<TabItem> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      TabItem(
        text: 'Fund Transfer\n(NEFT Charges)\n',
      ),
      TabItem(
        text: 'Fund Transfer\n(IMPS Charges)\n',
      ),
      TabItem(
        text: 'Fund Transfer\n(RTGS Charges)\n',
      ),
      TabItem(
        text: 'Money Transfer\n(NEFT Charges)\n',
      ),
    ];

    _selectedTab = _tabs[0].text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titleText: 'Commission',),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Center(
                    child: Text(
                      'Commission Plans',
                      style: TextStyle(
                        color: Color(0xFFC63F3F),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_outlined,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomTab(
              items: _tabs,
              selectedTab: _selectedTab,
              onPress: (index) {
                setState(() {
                  _selectedTab = _tabs[index].text;
                });
              },
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  border: TableBorder.all(
                      color: Colors.black), // Adding border to DataTable
                  columns: const [
                    DataColumn(
                        label: Text('Beneficiary Name',
                            style: TextStyle(color: Color(0xFFC63F3F)))),
                    DataColumn(
                        label: Text('Account Name',
                            style: TextStyle(color: Color(0xFFC63F3F)))),
                    DataColumn(
                        label: Text('Account No.',
                            style: TextStyle(color: Color(0xFFC63F3F)))),
                    DataColumn(
                        label: Text('IFSC Code',
                            style: TextStyle(color: Color(0xFFC63F3F)))),
                    DataColumn(
                        label: Text('Bank Name',
                            style: TextStyle(color: Color(0xFFC63F3F)))),
                    DataColumn(
                        label: Text('Bank No.',
                            style: TextStyle(color: Color(0xFFC63F3F)))),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('John Doe')),
                      DataCell(Text('Account 1')),
                      DataCell(Text('1234567890')),
                      DataCell(Text('IFSC001')),
                      DataCell(Text('Bank 1')),
                      DataCell(Text('Bank001')),
                    ]),
                    // Add more rows as needed
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final List<TabItem> items;
  final String selectedTab;
  final Function(int) onPress;

  const CustomTab({
    Key? key,
    required this.items,
    required this.selectedTab,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: items.map((item) {
          final isSelected = item.text == selectedTab;
          final index = items.indexOf(item);

          return GestureDetector(
            onTap: () => onPress(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: ShapeDecoration(
                color: isSelected ? Color(0xFFC63F3F) : Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFC63F3F),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Center(
                    child: Text(
                      item.text,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TabItem {
  final String text;

  TabItem({required this.text});
}
