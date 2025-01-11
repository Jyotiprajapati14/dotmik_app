import 'package:flutter/material.dart';

class TransactionData {
  final String profileImageUrl;
  final String name;
  final String details;

  TransactionData({
    required this.profileImageUrl,
    required this.name,
    required this.details,
  });
}

class TransactionUtils {
  static List<TransactionData> getTransactions() {
    return [
      TransactionData(
        profileImageUrl: "assets/images/Mobile Tick.png",
        name: "Payout Successful",
        details: "Your Payout Was Succeed , Thank You",
      ),
      TransactionData(
        profileImageUrl: "assets/images/E Wallet.png",
        name: "E-Wallet Connected To Account",
        details: "E-Wallet has connected to Account",
      ),
      TransactionData(
        profileImageUrl: "assets/images/Free Cancellation.png",
        name: "Recharge Failed ❌",
        details: "Mobile recharge of 233 rs. is failed ",
      ),
      TransactionData(
        profileImageUrl: "assets/images/Verification List.png",
        name: "2 Step Verification Done ✅",
        details: "Your Account has been verified by 2 steps ",
      ),
      // Add more TransactionData objects here as needed
    ];
  }
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late String _selectedTab;
  late List<TabItem> _tabs;
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    _tabs = [
      TabItem(
          text: 'All',
          icon: Icons.lock_clock_outlined,
          dropdownItems: ['Option 1', 'Option 2', 'Option 3']),
      TabItem(
          text: 'Date',
          icon: Icons.message_outlined,
          dropdownItems: ['Option 4', 'Option 5', 'Option 6']),
      TabItem(
          text: 'Service',
          icon: Icons.message_outlined,
          dropdownItems: ['Option 7', 'Option 8', 'Option 9']),
    ];

    _selectedTab = _tabs[0].text; // Initially select the first tab
    _selectedItem = _tabs[0].dropdownItems![
        0]; // Initially select the first option in the dropdown of the first tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction Reports',
                    style: TextStyle(
                      color: Color(0xFFC63F3F),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                      letterSpacing: 0.10,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showFilter();
                    },
                    icon: Icon(
                      Icons.search_outlined,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomTab(
              items: _tabs,
              selectedTab: _selectedTab,
              onPress: (index) {
                setState(() {
                  _selectedTab = _tabs[index].text;
                });
              },
              onDropdownItemTap: (item) {
                setState(() {
                  _selectedItem = item;
                });
              },
            ),
            SizedBox(height: 20),
            _buildTransactionCards(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCards() {
    final List<TransactionData> transactions =
        TransactionUtils.getTransactions();

    if (transactions.isEmpty) {
      return Text('No transactions found.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$_selectedItem",
          style: TextStyle(
            color: Color(0xFFC63F3F),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            print('Transaction $index: $transaction');
            return _buildTransactionCard(
              profileImageUrl: transaction.profileImageUrl,
              name: transaction.name,
              details: transaction.details,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionCard({
    required String profileImageUrl,
    required String name,
    required String details,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            child: Image.asset(profileImageUrl),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  details,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showFilter() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Text(
                'All Filter ',
                style: TextStyle(
                  color: Color(0xFFC63F3F),
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 394,
                height: 0.50,
                decoration: ShapeDecoration(
                  color: Color(0x7FD9D9D9),
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Sort Results',
                style: TextStyle(
                  color: Color(0xFFC63F3F),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomTab extends StatelessWidget {
  final List<TabItem> items;
  final String selectedTab;
  final Function(int) onPress;
  final Function(String) onDropdownItemTap;

  const CustomTab({
    Key? key,
    required this.items,
    required this.selectedTab,
    required this.onPress,
    required this.onDropdownItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          final isSelected = item.text == selectedTab;
          final index = items.indexOf(item);

          return GestureDetector(
            onTap: () {
              onPress(index);
              // _showDropdown(
              //     context, item.dropdownItems!, onDropdownItemTap, isSelected);
            },
            child: Row(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: ShapeDecoration(
                    color: isSelected ? Color(0xFFC63F3F) : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Color(0xFFC63F3F),
                      ),
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        item.text,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ),
                // Add a SizedBox with a specified width between each tab except the last one
                if (index < items.length - 1) SizedBox(width: 10),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showDropdown(
    BuildContext context,
    List<String> dropdownItems,
    Function(String) onDropdownItemTap,
    bool isSelected,
  ) {
    final RenderBox tabBox = context.findRenderObject() as RenderBox;
    final Offset target = tabBox.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromLTRB(
      target.dx,
      target.dy + tabBox.size.height,
      target.dx + tabBox.size.width,
      target.dy + tabBox.size.height,
    );

    // Calculate the offset based on the selected tab index
    final index = items.indexWhere((item) => item.text == selectedTab);
    final offsetX = tabBox.size.width * index;

    // Adjust the position to make the menu appear below the selected tab
    final adjustedPosition = position.shift(Offset(offsetX, 0.0));

    showMenu<String>(
      context: context,
      position: adjustedPosition,
      items: dropdownItems.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    ).then((String? selectedItem) {
      if (selectedItem != null) {
        onDropdownItemTap(selectedItem);
      }
    });
  }
}

class TabItem {
  final String text;
  final IconData icon;
  final List<String>? dropdownItems;

  TabItem({required this.text, required this.icon, this.dropdownItems});
}



