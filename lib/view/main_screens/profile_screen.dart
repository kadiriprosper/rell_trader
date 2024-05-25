import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/main_screens/payment_page.dart';
import 'package:rell_trader/view/main_screens/widgets/base_main_screen.dart';

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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return BaseMainScreen(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: const Color.fromARGB(255, 17, 165, 22),
              child: Text(
                'User001',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            // const SizedBox(height: 10),
            // const Text(
            //   'Current Trading Pair',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,
            //   ),
            // ),
            // const SizedBox(height: 10),
            // DropdownMenu(
            //   controller: selectedPairController,
            //   initialSelection: Text(tradingPair.first),
            //   hintText: 'Trading Pair',
            //   textStyle: const TextStyle(
            //     fontWeight: FontWeight.w500,
            //   ),
            //   onSelected: (value) {
            //     print(value);
            //   },
            //   inputDecorationTheme: const InputDecorationTheme(
            //     border: UnderlineInputBorder(),
            //     focusedBorder: UnderlineInputBorder(
            //       borderSide: BorderSide(
            //         color: Colors.green,
            //       ),
            //     ),
            //   ),
            //   width: MediaQuery.of(context).size.width - 20,
            //   dropdownMenuEntries: tradingPair
            //       .map(
            //         (e) => DropdownMenuEntry(
            //           value: Text(e),
            //           label: e,
            //         ),
            //       )
            //       .toList(),
            // ),
            // const SizedBox(height: 30),
            // const Text(
            //   'Select Duration',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,
            //   ),
            // ),
            // const SizedBox(height: 10),
            // DropdownMenu(
            //   controller: selectedDurationController,
            //   initialSelection: Text(tradingPair.first),
            //   hintText: 'Duration',
            //   textStyle: const TextStyle(
            //     fontWeight: FontWeight.w500,
            //   ),
            //   onSelected: (value) {
            //     print(value);
            //   },
            //   inputDecorationTheme: const InputDecorationTheme(
            //     border: UnderlineInputBorder(),
            //     focusedBorder: UnderlineInputBorder(
            //       borderSide: BorderSide(
            //         color: Colors.green,
            //       ),
            //     ),
            //   ),
            //   width: MediaQuery.of(context).size.width - 20,
            //   dropdownMenuEntries: timeFrame
            //       .map(
            //         (e) => DropdownMenuEntry(
            //           value: Text(e),
            //           label: e,
            //         ),
            //       )
            //       .toList(),
            // ),
          ],
        ),
      ),
    );
  }
}
