import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/main_screens/payment_page.dart';
import 'package:rell_trader/view/main_screens/profile_screen.dart';
import 'package:rell_trader/view/main_screens/widgets/base_main_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool hasData = false;
  TradeModel? currentTrade;
  List<SignalCardWidget> tradingSignals = [];
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://81.0.249.14:80/ws/check/free'),
  );

  @override
  void initState() {
    channel.sink.add(jsonEncode({"msg": "ping"}));
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseMainScreen(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20).copyWith(bottom: 10, left: 14),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 24, 111, 27),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Welcome Again,',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // const Text(
                  //   'Fund account for trading',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  CustomMainScreenButton(
                    buttonColor: Colors.white,
                    buttonTextColor: const Color.fromARGB(255, 24, 111, 27),
                    label: 'Get funding for trading',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: SizedBox(
            //     height: 200,
            //     width: MediaQuery.of(context).size.width,
            //     child: LineChart(
            //       LineChartData(
            //         backgroundColor: Colors.green,
            //         borderData: FlBorderData(
            //           show: false,
            //         ),
            //         //TODO: Change this based on the requirements
            //         minX: 0,
            //         minY: 0,
            //         maxX: 10,
            //         maxY: 10,
            //         lineBarsData: [
            //           LineChartBarData(
            //             spots:
            //           ),
            //         ]
            //       ),
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Daily signals',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            //TODO-TEST: Test the stream builder here
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                // Future.delayed(
                //   const Duration(minutes: 1),
                //   () => channel.sink.add(jsonEncode({"msg": "ping"})),
                // );

                if (snapshot.hasData) {
                  if (jsonDecode(snapshot.data)['status'] == false &&
                      !hasData) {
                    print({'Current Status': 'False'});
                  } else {
                    print(snapshot.data);

                    if (jsonDecode(snapshot.data)['status'] == true) {
                      currentTrade = TradeModel.fromMap(
                        jsonDecode(snapshot.data),
                      );
                      if (tradingSignals.length > 2) {
                        tradingSignals.removeAt(0);
                      }
                      tradingSignals.add(
                        SignalCardWidget(
                          tradingPair: tradingPair.first,
                          condition: currentTrade!.condition,
                          rsi: currentTrade!.rsi.toStringAsFixed(2),
                          sma: currentTrade!.sl.toStringAsFixed(2),
                          tp: currentTrade!.tp.toStringAsFixed(2),
                          currentPrice:
                              currentTrade!.currentPrice.toStringAsFixed(2),
                        ),
                      );
                    }
                    hasData = true;
                    return ListView.separated(
                      itemCount: tradingSignals.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 6,
                      ),
                      itemBuilder: (context, index) {
                        return tradingSignals[index];
                      },
                    );
                  }
                  //   return SignalCardWidget(
                  //     lotSize: '0.01',
                  //     tradingPair: 'XAUUSD',
                  //     openPrice: '1.0234',
                  //     stopLoss: '1.08204',
                  //     takeProfit: '1.082084',
                  //     expiration: '10mins',
                  //   );
                }

                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 10,
                    ),
                    Text(
                      'Checking Market Conditions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(20).copyWith(bottom: 10, left: 14),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 5, 117, 208),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upgrade to RellTrader Pro,',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    // 'Unlock advanced features and\nmaximize your trading potential\nwith RellTrader Premium',
                    'Get 100% monthly profit guaranteed,\n30 days money back also guaranteed.\nTry for free today.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomMainScreenButton(
                    buttonColor: Colors.white,
                    buttonTextColor: const Color.fromARGB(255, 5, 117, 208),
                    label: 'Upgrade now',
                    onPressed: () {
                      Get.to(() => const PaymentPage());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CustomMainScreenButton extends StatelessWidget {
  const CustomMainScreenButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.buttonColor,
    required this.buttonTextColor,
  });

  final VoidCallback onPressed;
  final String label;
  final Color buttonColor;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: buttonColor,
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: buttonTextColor,
        ),
      ),
    );
  }
}

class SignalCardWidget extends StatelessWidget {
  const SignalCardWidget({
    super.key,
    // required this.lotSize,
    required this.tradingPair,
    required this.condition,
    required this.rsi,
    required this.sma,
    required this.tp,
    required this.currentPrice,
    // required this.openPrice,
    // required this.stopLoss,
    // required this.takeProfit,
    // required this.expiration,
  });
  // final String lotSize;
  final String tradingPair;
  // final String openPrice;
  // final String stopLoss;
  // final String takeProfit;
  // final String expiration;
  final TradeCondition condition;
  final String rsi;
  final String sma;
  final String tp;
  final String currentPrice;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12).copyWith(left: 14),
        child: Column(
          children: [
            Row(
              children: [
                // RichText(
                //   text: TextSpan(
                //     style: const TextStyle(
                //       color: Colors.grey,
                //       fontSize: 12,
                //       fontWeight: FontWeight.w500,
                //     ),
                //     text: 'Lot size: ',
                //     children: [
                //       TextSpan(
                //         text: rsi,
                //         style: const TextStyle(
                //           color: Colors.green,
                //           fontSize: 12,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const Spacer(),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    text: 'Condition Met: ',
                    children: [
                      TextSpan(
                        text: condition == TradeCondition.buy ? 'BUY' : 'SELL',
                        style: TextStyle(
                          color: condition == TradeCondition.buy
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SymbolRowWidget(
              label: 'Symbol',
              size: 'XAUUSD',
            ),
            const SizedBox(height: 10),
            SymbolRowWidget(
              label: 'Open price',
              size: currentPrice,
              isHigher: true,
            ),
            const SizedBox(height: 10),
            SymbolRowWidget(
              label: 'Stop loss',
              size: sma,
              isHigher: false,
            ),
            const SizedBox(height: 10),
            SymbolRowWidget(
              label: 'Take Profit',
              size: tp,
              isHigher: false,
            ),
            // const SizedBox(height: 10),
            // SymbolRowWidget(
            //   label: 'Take profit',
            //   size: takeProfit,
            //   isHigher: true,
            // ),
            // const SizedBox(height: 10),
            // const SymbolRowWidget(
            //   label: 'Expiration',
            //   size: '60 secs',
            // ),
          ],
        ),
      ),
    );
  }
}

/// This is the row of the Symbol Widget.
/// [label] is the label of the row.
/// [size] is the lot size.
/// [isHigher] affects the color. If the size is higher than the chart size,
/// the color would be green, otherwise red
class SymbolRowWidget extends StatelessWidget {
  const SymbolRowWidget({
    super.key,
    required this.label,
    required this.size,
    this.isHigher,
  });

  final String label;
  final String size;
  final bool? isHigher;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          size,
          style: TextStyle(
            color: isHigher == null
                ? Colors.black
                : isHigher == true
                    ? Colors.green
                    : Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
