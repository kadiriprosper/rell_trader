import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/main_screens/main_screen.dart';

const tradingPair = [
  'USDBTC',
  'USDNGN',
  'XRPETH',
  'USDBNB',
  'BTCETH',
  'LTCNGN',
];

const timeFrame = [
  '5mins',
  '10mins',
  '15mins',
  '20mins',
  '25mins',
  '30mins',
];

class AccountSetUpScreen extends StatefulWidget {
  const AccountSetUpScreen({super.key});

  @override
  State<AccountSetUpScreen> createState() => _AccountSetUpState();
}

class _AccountSetUpState extends State<AccountSetUpScreen> {
  TextEditingController selectedPairController = TextEditingController();
  TextEditingController selectedDurationController = TextEditingController();

  @override
  void dispose() {
    selectedPairController.dispose();
    selectedDurationController.dispose();
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
                'Set up account',
                style: TextStyle(
                  color: Color.fromARGB(255, 42, 120, 44),
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 116, 196, 119),
                thickness: .5,
              ),
              const Divider(
                color: Color.fromARGB(255, 35, 99, 37),
                thickness: 1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              const Text(
                'Select Trading Pair',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              DropdownMenu(
                controller: selectedPairController,
                initialSelection: Text(tradingPair.first),
                hintText: 'Trading Pair',
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                onSelected: (value) {
                  print(value);
                },
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
              const SizedBox(height: 30),
              const Text(
                'Select Duration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              DropdownMenu(
                controller: selectedDurationController,
                initialSelection: Text(tradingPair.first),
                hintText: 'Duration',
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                onSelected: (value) {
                  print(value);
                },
                inputDecorationTheme: const InputDecorationTheme(
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                width: MediaQuery.of(context).size.width - 20,
                dropdownMenuEntries: timeFrame
                    .map(
                      (e) => DropdownMenuEntry(
                        value: Text(e),
                        label: e,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 60),
              MaterialButton(
                onPressed: () {
                  Get.to(() => const DashboardScreen());
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
      ),
    );
  }
}
