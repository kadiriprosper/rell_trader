import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/user_controller.dart';
import 'package:rell_trader/view/auth/sign_up_screen.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/main_screens/main_screen.dart';
import 'package:rell_trader/view/widget/custom_auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  late TapGestureRecognizer onTapCreateAccount;

  @override
  void initState() {
    onTapCreateAccount = TapGestureRecognizer()
      ..onTap = () {
        Get.to(() => const SignUpScreen());
      };
    super.initState();
  }

  @override
  void dispose() {
    onTapCreateAccount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              const Text(
                'WELCOME BACK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Login to your ',
                    ),
                    TextSpan(
                      text: 'RellTrader ',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'account',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAuthTextField(
                      textController: emailController,
                      hintText: 'enter your email',
                      textInputType: TextInputType.emailAddress,
                      label: 'Email address',
                      prefixIcon: const Icon(Icons.email_outlined),
                      validater: (value) {
                        if (value != null && value.isEmail) {
                          return null;
                        }
                        return 'Enter valid email';
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomAuthTextField(
                      textController: passwordController,
                      hintText: 'enter your password',
                      textInputType: TextInputType.visiblePassword,
                      label: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      obscureText: obscureText,
                      onSuffixIconClick: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      validater: (value) {
                        if (value != null && value.length > 6) {
                          return null;
                        }
                        return 'Password must be greater than 6';
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              MaterialButton(
                onPressed: () async {
                  UserController userController = Get.put(UserController());
                  if (formKey.currentState?.validate() == true) {
                    bool response = await Get.showOverlay(
                      asyncFunction: () async => await userController.userLogin(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                      loadingWidget: const Center(
                        child: SpinKitWave(
                          color: Colors.purple,
                          size: 42,
                        ),
                      ),
                    );
                    if (response) {
                      Get.to(() => const DashboardScreen());
                    } else {
                      Get.snackbar(
                        'Error',
                        'Error logging you in',
                        margin: const EdgeInsets.all(20),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                        isDismissible: true,
                      );
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 60,
                color: Colors.green,
                minWidth: MediaQuery.of(context).size.width,
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Do not have an account with us? ',
                      ),
                      TextSpan(
                        text: 'Create an account',
                        recognizer: onTapCreateAccount,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
