import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/view/main_screens/widgets/base_main_screen.dart';
import 'package:rell_trader/view/main_screens/widgets/signal_card_widget.dart';

class TradeHistoryScreen extends StatefulWidget {
  const TradeHistoryScreen({super.key});

  @override
  State<TradeHistoryScreen> createState() => _TradeHistoryScreenState();
}

class _TradeHistoryScreenState extends State<TradeHistoryScreen> {
  TradeController tradeController = Get.put(TradeController());

  Future<bool> _getTradingHistory() async {
    return tradeController.getTradeHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BaseMainScreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Latest Signals'),
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            try {
              await _getTradingHistory();
            } catch (err) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to refresh: $err'),
                ),
              );
            }
          },
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          backgroundColor: Colors.green,
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 0).copyWith(top: 12),
            child: FutureBuilder(
              future: _getTradingHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (tradeController.tradeHistoryList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Trade History Yet',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  } else {
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: tradeController.tradeHistoryList.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 6,
                      ),
                      itemBuilder: (context, index) {
                        final currentTrade =
                            tradeController.tradeHistoryList[index];
                        return FreeSignalCardWidget(
                          tradingPair: currentTrade.symbol,
                          condition: currentTrade.tradeCondition,
                          dateCreated: currentTrade.createdAt,
                          rsi: '',
                          result: currentTrade.response,
                          symbol: currentTrade.symbol,
                          sma: currentTrade.stopLoss.toStringAsFixed(2),
                          tp: currentTrade.takeProfit.toStringAsFixed(2),
                          currentPrice:
                              currentTrade.openPrice.toStringAsFixed(2),
                        );
                      },
                    );
                  }
                } else {
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
                        'Retrieving Trade History',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
