import 'package:flutter/material.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/main_screens/widgets/symbol_row_widget.dart';

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
    this.symbol,
    required this.dateCreated,
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
  final String? symbol;
  final String dateCreated;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Created On',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  dateCreated,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trade Condition',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  condition == TradeCondition.buy ? 'BUY' : 'SELL',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: condition == TradeCondition.buy
                        ? Colors.green
                        : Colors.red,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            SymbolRowWidget(
              label: 'Symbol',
              size: symbol ?? 'XAUUSD',
            ),
            const SizedBox(height: 10),
            SymbolRowWidget(
              label: 'Open price',
              size: currentPrice,
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
              isHigher: true,
            ),
          ],
        ),
      ),
    );
  }
}
