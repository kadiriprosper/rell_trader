import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/user_controller.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/widget/custom_auth_text_field.dart';

class MetaTraderAccountPage extends StatefulWidget {
  const MetaTraderAccountPage({super.key, required this.fromAccountSetup});

  final bool fromAccountSetup;

  @override
  State<MetaTraderAccountPage> createState() => _MetaTraderAccountPageState();
}

class _MetaTraderAccountPageState extends State<MetaTraderAccountPage> {
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController selectedPairController = TextEditingController();
  TextEditingController selectedServerController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  List<String> serverList = [
    'MetaQuotes-Demo',
  ];
  List<String> tradingPair = [
    'XAUUSD',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Link MetaTrader Account'),
        automaticallyImplyLeading: false,
        //If this page is called from the sign up page, then don't show the back button

        leading: widget.fromAccountSetup
            ? null
            : IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close),
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meta Trader account',
              style: TextStyle(
                color: Color.fromARGB(255, 42, 120, 44),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAuthTextField(
                    textController: accountNumberController,
                    hintText: '930xxxxxxx',
                    label: 'MetaTrader Account Number',
                    prefixIcon: const Icon(Icons.person),
                    validater: (value) {
                      if (value == null) {
                        return 'Please input a valid account number';
                      }
                      return null;
                    },
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CustomAuthTextField(
                    textController: passwordController,
                    hintText: 'xxxxxxxx',
                    label: 'MetaTrader Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    validater: (value) {
                      if (value == null) {
                        return 'Please input a valid password';
                      }
                      return null;
                    },
                    obscureText: obscureText,
                    onSuffixIconClick: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    textInputType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Server',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownMenu(
                    controller: selectedServerController,
                    initialSelection: Text(serverList.first),
                    errorText: 'Select an option',
                    hintText: 'Server',
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    dropdownMenuEntries: serverList
                        .map(
                          (e) => DropdownMenuEntry(
                            value: Text(e),
                            label: e,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Trading Pair',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownMenu(
                    controller: selectedPairController,
                    initialSelection: Text(tradingPair.first),
                    errorText: 'Select an option',
                    hintText: 'Trading Pair',
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    dropdownMenuEntries: tradingPair
                        .map(
                          (e) => DropdownMenuEntry(
                            value: Text(e),
                            label: e,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            MaterialButton(
              onPressed: () async {
                UserController userController = Get.put(UserController());
                if (formKey.currentState?.validate() == true) {
                  bool response = await Get.showOverlay(
                    asyncFunction: () async =>
                        await userController.connectMT5Account(
                      accountNumber: int.parse(accountNumberController.text),
                      password: passwordController.text,
                      server: selectedServerController.text,
                      pair: selectedPairController.text,
                    ),
                    loadingWidget: const Center(
                      child: SpinKitWave(
                        color: Colors.purple,
                        size: 42,
                      ),
                    ),
                  );
                  if (response) {
                    Get.offUntil(
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                      (route) => false,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Error connecting MT5 Account',
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
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
