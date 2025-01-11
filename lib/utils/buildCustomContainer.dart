import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget customContainer({
  required List<String> images,
  required List<String> titles,
  required String name,
}) {
  return Container(
    width: 376,
    height: 145,
    decoration: ShapeDecoration(
      color: Color.fromARGB(255, 246, 239, 239),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadows: [
        BoxShadow(
          color: Color(0x3F000000),
          blurRadius: 4,
          offset: Offset(0, 1),
          spreadRadius: 0,
        )
      ],
    ),
    child: Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: List.generate(images.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(images[index]),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: List.generate(titles.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          titles[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 15,
          child: Row(
            children: [
              Text(
                'View All',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.arrow_forward_outlined,
                size: 15,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



