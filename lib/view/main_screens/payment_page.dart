import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/view/main_screens/main_screen.dart';
import 'package:rell_trader/view/main_screens/premium_screen.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 219, 189),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 188, 219, 189),
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Payment Page\nTerms of use for the premium',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: MaterialButton(
                  onPressed: () {
                    Get.bottomSheet(
                      const RiskAmountBottomSheet(),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 60,
                  color: Colors.green,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    'Select Max Risk',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiskAmountBottomSheet extends StatefulWidget {
  const RiskAmountBottomSheet({
    super.key,
  });

  @override
  State<RiskAmountBottomSheet> createState() => _RiskAmountBottomSheetState();
}

class _RiskAmountBottomSheetState extends State<RiskAmountBottomSheet> {
  late TextEditingController riskController;
  double selectedMaxRisk = 0;
  TradeController tradeController = Get.put(TradeController());

  @override
  void initState() {
    riskController = TextEditingController(
        text: tradeController.selectedMaximumRisk.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ).copyWith(bottom: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Maximum Risk',
              style: TextStyle(
                color: Color.fromARGB(255, 42, 120, 44),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  child: TextField(
                    controller: riskController,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 42, 120, 44),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        riskController.text = value;
                        if (double.tryParse(value) != null &&
                            double.tryParse(value)! > 100) {
                          riskController.text = 100.toStringAsFixed(1);
                        }
                        // if (double.tryParse(value) == null) {
                        //   riskController.text = 0.toStringAsFixed(1);
                        // }
                      });
                    },
                  ),
                ),
                const Text('%')
              ],
            ),
            const SizedBox(height: 15),
            Slider(
              min: 0,
              max: 100,
              activeColor: Colors.green,
              label: riskController.text,
              value: double.tryParse(riskController.text) ?? 0.0,
              onChanged: (value) => setState(() {
                // tradeController.selectedMaximumRisk = value;
                riskController.text = value.toStringAsFixed(1);
              }),
            ),
            const SizedBox(height: 10),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  height: 50,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                MaterialButton(
                  onPressed: () {
                    tradeController.selectedMaximumRisk =
                        double.tryParse(riskController.text)!;
                    if (double.tryParse(riskController.text)! > 0) {
                      Get.to(() => const PremiumScreen());
                    } else {
                      Get.snackbar(
                        'Error',
                        'Maximum risk cannot be 0',
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(10),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                        isDismissible: true,
                      );
                    }
                  },
                  height: 50,
                  minWidth: 100,
                  color: Colors.green,
                  child: const Text('Continue'),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
