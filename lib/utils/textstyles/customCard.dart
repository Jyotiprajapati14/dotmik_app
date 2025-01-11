import 'package:flutter/material.dart';

class CustomCard {
  final String text;
  final int operatorId;
  final String operatorCode;

  CustomCard({
    required this.text,
    required this.operatorId,
    required this.operatorCode, required String imageUrl,
  });
}

class CustomCardWidget extends StatelessWidget {
  final List<CustomCard> items;
  final void Function(CustomCard) onTap;

  CustomCardWidget({
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: items.map((item) {
        return GestureDetector(
          onTap: () => onTap(item),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                   Color.fromARGB(255, 138, 174, 236), Color.fromARGB(255, 170, 222, 246)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 82, 157, 218),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Icon(
                      Icons.star_rate_outlined,
                      color: Colors.white,
                    )),
                  ),
                  SizedBox(height: 10),
                  Text(
                    item.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
