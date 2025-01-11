import 'package:dotmik_app/screen/splash_screen.dart';
import 'package:dotmik_app/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Initialize routes
  await Routes.initializeRoutes();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      debugShowMaterialGrid: false,
      home: SplashScreen(),
      getPages: Routes.pages,
    );
  }
}
