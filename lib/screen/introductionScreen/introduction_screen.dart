import 'package:dotmik_app/screen/introductionScreen/intro_content.dart';
import 'package:dotmik_app/utils/circular_progressor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntroScreenOnboarding extends StatefulWidget {
  final List<Introduction>? introductionList;
  final Color? backgroudColor;
  final Color? foregroundColor;
  final TextStyle? skipTextStyle;
  final Function()? onTapSkipButton;

  IntroScreenOnboarding({
    Key? key,
    this.introductionList,
    this.onTapSkipButton,
    this.backgroudColor,
    this.foregroundColor,
    this.skipTextStyle,
  }) : super(key: key);

  @override
  _IntroScreenOnboardingState createState() => _IntroScreenOnboardingState();
}

class _IntroScreenOnboardingState extends State<IntroScreenOnboarding> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;
    final isDarkMode = systemBrightness == Brightness.dark;

    Color backgroundColor = isDarkMode ? Colors.black87 : Colors.white;
    Color contentColor = isDarkMode ? Colors.white : Colors.black;

    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          color: widget.backgroudColor ?? backgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: widget.onTapSkipButton,
                        child: Text(
                          'Skip',
                          style: widget.skipTextStyle ??
                              TextStyle(
                                  fontSize: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: widget.introductionList!,
                  ),
                ),
                LinearDotProgressIndicator(
                  currentPage: _currentPage,
                  totalPages: widget.introductionList!.length,
                  indicatorColor: widget.foregroundColor ??
                      (isDarkMode ? Colors.white : Colors.red),
                ),
                SizedBox(height: 20),
                _customProgress(isDarkMode, contentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customProgress(bool isDarkMode, Color contentColor) {
    final double circleSize = MediaQuery.of(context).size.width * 0.2;
    final double iconSize = circleSize * 0.425;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          child: CircleProgressBar(
            backgroundColor: widget.foregroundColor ??
                (isDarkMode ? Colors.white : Colors.red),
            foregroundColor: isDarkMode ? Colors.red : Colors.black,
            value: ((_currentPage + 1) * 1.0 / widget.introductionList!.length),
          ),
        ),
        Container(
          height: circleSize * 0.7875,
          width: circleSize * 0.7875,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.foregroundColor ??
                (isDarkMode ? Colors.white : Colors.red),
          ),
          child: Center(
            child: IconButton(
              onPressed: () {
                _currentPage != widget.introductionList!.length - 1
                    ? _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      )
                    : widget.onTapSkipButton!();
              },
              icon: Icon(
                Icons.check,
                color: isDarkMode ? Colors.red : Colors.white,
              ),
              iconSize: iconSize,
            ),
          ),
        )
      ],
    );
  }
}

class LinearDotProgressIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color? indicatorColor;

  LinearDotProgressIndicator({
    required this.currentPage,
    required this.totalPages,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;
    final isDarkMode = systemBrightness == Brightness.dark;

    Color defaultColor = isDarkMode ? Colors.white : Colors.black;
    Color activeColor = Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          width: index == currentPage
              ? MediaQuery.of(context).size.width * 0.05
              : MediaQuery.of(context).size.width * 0.03,
          height: MediaQuery.of(context).size.height * 0.01,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(50),
            color: index == currentPage ? activeColor : defaultColor,
          ),
        ),
      ),
    );
  }
}
