import 'package:flutter/material.dart';

class CustomDropdownListItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomDropdownListItem({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 312,
        height: 48,
        color: isSelected ? Color(0xEEFFEEEE) : Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: 16),
            Radio(
              value: isSelected,
              groupValue: true, // Change this based on your implementation
              onChanged: (value) {}, // Change this based on your implementation
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Color(0xFF2E2E2E),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdownList extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final Function(String) onChanged;

  const CustomDropdownList({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 312,
          height: 49,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Color(0xFFD8D7DD),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              // Handle dropdown tap
              // You can open a dropdown menu here
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedItem,
                    style: TextStyle(
                      color: Color(0xFF2E2E2E),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.50,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 1),
        Container(
          width: 312,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Color(0xFFD8D7DD),
              ),
            ),
          ),
        ),
        Column(
          children: items.map((item) {
            final bool isSelected = item == selectedItem;
            return CustomDropdownListItem(
              text: item,
              isSelected: isSelected,
              onTap: () {
                onChanged(item);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
