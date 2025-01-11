import 'package:dotmik_app/screen/notification_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final VoidCallback? onBackPress;
  final VoidCallback? onNotificationPress;

  const CustomAppBar({
    Key? key,
    required this.titleText,
    this.onBackPress,
    this.onNotificationPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4,
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: IconButton(
          icon: Image.asset('assets/intro/back.png', fit: BoxFit.fill),
          onPressed: onBackPress ?? () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        titleText,
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
            icon: Image.asset('assets/intro/bell.png', fit: BoxFit.fill),
            onPressed: onNotificationPress ??
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
