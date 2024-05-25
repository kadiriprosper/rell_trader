import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/user_controller.dart';
import 'package:rell_trader/view/auth/login_screen.dart';
import 'package:rell_trader/view/main_screens/account_set_up.dart';
import 'package:rell_trader/view/widget/custom_auth_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obscureText = true;
  bool obscureConfirmText = true;
  final formKey = GlobalKey<FormState>();
  late TapGestureRecognizer onTapLogin;

  @override
  void initState() {
    onTapLogin = TapGestureRecognizer()
      ..onTap = () {
        Get.to(() => const LoginScreen());
      };
    super.initState();
  }

  @override
  void dispose() {
    onTapLogin.dispose();
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
                'CREATE AN ACCOUNT',
                style: TextStyle(
                  color: Colors.black,
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
                      text: 'Register for free and explore ',
                    ),
                    TextSpan(
                      text: 'RellTrader',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomAuthTextField(
                      textController: fullNameController,
                      hintText: 'enter your name',
                      textInputType: TextInputType.name,
                      label: 'Full Name',
                      prefixIcon: const Icon(Icons.email_outlined),
                      validater: (value) {
                        if (value != null && value.length > 3) {
                          return null;
                        }
                        return 'Enter valid name';
                      },
                    ),
                    const SizedBox(height: 14),
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
                    const SizedBox(height: 14),
                    CustomAuthTextField(
                      textController: confirmPasswordController,
                      hintText: 'confirm your password',
                      textInputType: TextInputType.visiblePassword,
                      label: 'Confirm password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      obscureText: obscureConfirmText,
                      onSuffixIconClick: () {
                        setState(() {
                          obscureConfirmText = !obscureConfirmText;
                        });
                      },
                      validater: (value) {
                        if (value != null && value == passwordController.text) {
                          return null;
                        }
                        return 'password does not match';
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              MaterialButton(
                onPressed: () async {
                  UserController userController = Get.put(UserController());
                  if (formKey.currentState?.validate() == true) {
                    bool response = await Get.showOverlay(
                      asyncFunction: () async => userController.userSignUp(
                        email: emailController.text,
                        password: passwordController.text,
                        fullName: fullNameController.text,
                      ),
                      loadingWidget: const Center(
                        child: SpinKitWave(
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    );
                    if (response) {
                      Get.to(() => const AccountSetUpScreen());
                    } else {
                      Get.snackbar(
                        'Error',
                        'Error registering you',
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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Already have an account? ',
                      ),
                      TextSpan(
                        text: 'Login',
                        recognizer: onTapLogin,
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
