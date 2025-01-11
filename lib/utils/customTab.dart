import 'package:dotmik_app/screen/transaction_report_screen.dart';
import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final List<TabItem> items;
  final Function(int) onPress;
  final int selectedIndex;

  const CustomTab({
    Key? key,
    required this.items,
    required this.onPress,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => onPress(index),
          child: Container(
            width: 108,
            height: 32,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: index == selectedIndex ? Colors.red : Color(0xFFC63F3F),
                ),
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  child: Icon(item.icon, color: index == selectedIndex ? Colors.red : Colors.black),
                ),
                SizedBox(width: 8),
                Text(
                  item.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: index == selectedIndex ? Colors.red : Colors.black,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0.10,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
