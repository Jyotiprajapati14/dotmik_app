
import 'package:dotmik_app/api/apiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotmik_app/complete_screen.dart';
import 'package:dotmik_app/utils/appColors.dart';
import 'package:dotmik_app/utils/customTextFied.dart';
import 'package:dotmik_app/utils/custome_button.dart';
import 'login_screen.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final ApiService apiService = ApiService();

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

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.only(top: screenHeight * 0.10), // Padding to avoid content touching status bar
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Container(
                        margin: EdgeInsetsDirectional.only(
                            start: screenWidth * 0.05),
                        height: screenHeight * 0.2,
                        width: screenHeight * 0.3,
                        child: Image.asset(
                          'assets/intro/20602852_6333050 1.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : AppColors.red,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Text(
                      'Hi Welcome !',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poller One',
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: firstNameController,
                      hintText: 'Enter your Name',
                      icon: Icons.person_2_outlined,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: lastNameController,
                      hintText: 'Enter your LastName',
                      icon: Icons.lock_outline,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Enter your Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Enter your PhoneNumber',
                      icon: Icons.lock_outline,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Enter your Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20,),
                    CustomTextField(
                        controller: confirmPasswordController,
                        hintText: 'Enter Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword),
                    const SizedBox(height: 20),
                    CustomImageButton(
                      color: Colors.black,
                      text: 'Sign Up',
                      imagePath: 'assets/intro/chevron-right.png',
                      onPressed: () async {
                        if (firstNameController.text.isEmpty ||
                            lastNameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all the fields')),
                          );
                          return;
                        }

                        if (passwordController.text != confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }

                        try {
                          await apiService.signUp(
                             firstNameController.text,
                             lastNameController.text,
                             emailController.text,
                             phoneController.text,
                             passwordController.text,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CompleteScreen()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already Have an Account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFFFFD96E),
                              fontSize: 18,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

