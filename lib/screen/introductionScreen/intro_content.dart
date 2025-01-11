import 'package:dotmik_app/utils/textstyles/textstyle.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class Introduction extends StatefulWidget {
  final String imageUrl;
  final String detail;
  final String title;
  final String subTitle;
  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;

  const Introduction({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.detail,
    this.titleTextStyle = const TextStyle(fontSize: 30),
    this.subTitleTextStyle = const TextStyle(fontSize: 20),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new IntroductionState();
  }
}

class IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return ui.Gradient.linear(
                Offset(0, bounds.top),
                Offset(0, bounds.bottom),
                [Colors.black, Color(0xFFC63F3F)],
              );
            },
            child: Text(
              widget.title,
              textAlign: TextAlign.start,
              style: IntroductionUtils.getTitleTextStyle(context),
            ),
          ),
          Text(
            widget.subTitle,
            textAlign: TextAlign.start,
            style: IntroductionUtils.getSubTitleTextStyle(context),
          ),
          SizedBox(
            width: 0.6 * screenWidth,
            child: Text(
              widget.detail,
              textAlign: TextAlign.start,
              style: IntroductionUtils.getDetailTextStyle(context),
            ),
          ),
          SizedBox(
            height: screenWidth * 0.8, 
            width: screenWidth * 0.6,
            child: Padding(
              padding: const EdgeInsets.only( left:18),
              child: Center(
                child: Image(
                  image: AssetImage(widget.imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
