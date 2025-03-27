import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotmik_app/api/apiService.dart';
import 'package:dotmik_app/screen/registration_screen.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:dotmik_app/utils/customTextFied.dart';
import 'package:dotmik_app/utils/custome_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ApiService apiService = ApiService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                      left: screenWidth * 0.4,
                      top: -screenHeight * 0.3,
                      right: -screenWidth * 0.8,
                      child: Container(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.5,
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100000),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.10,
                          bottom: screenHeight * 0.05),
                      child: Center(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                              start: screenWidth * 0.05),
                          height: screenHeight * 0.3,
                          width: screenHeight * 0.3,
                          child: Image.asset(
                            'assets/loginimage.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[900] : const Color.fromARGB(255, 245, 76, 76),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 30),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'Hi Welcome !',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: 'Poller One',
                                      fontSize: screenWidth * 0.08,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                CustomTextField(
                                  hintText: 'Enter your email Id',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.text,
                                  controller: emailController,
                                ),
                                SizedBox(height: screenHeight * 0.016),
                                CustomTextField(
                                  hintText: 'Enter your password',
                                  icon: Icons.lock_outline,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: passwordController,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                if (isLoading) ...[
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ] else ...[
                                  CustomImageButton(
                                    color: Colors.black,
                                    text: 'Log In',
                                    imagePath: 'assets/intro/chevron-right.png',
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        await 
                                         apiService.logIn(emailController.text,
                                            passwordController.text, context);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('An error occurred'),
                                          ),
                                        );
                                      } finally {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                                  ),
                                ],
                                SizedBox(height: screenHeight * 0.01),
                                Row(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.3,
                                      decoration: const ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            color: Color(0xFFD6D6D6),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.05,
                                    ),
                                    Text(
                                      'Or',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: screenWidth * 0.045,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.05,
                                    ),
                                    Container(
                                      width: screenWidth * 0.3,
                                      decoration: const ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            color: Color(0xFFD6D6D6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: screenWidth * 0.045,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SignScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                          color: const Color(0xFFFFD96E),
                                          fontSize: screenWidth * 0.045,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
