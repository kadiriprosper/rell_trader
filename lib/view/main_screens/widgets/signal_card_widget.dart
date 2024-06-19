import 'package:flutter/material.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/main_screens/widgets/symbol_row_widget.dart';

abstract class SignalCardWidget extends StatefulWidget {
  const SignalCardWidget({super.key});
}

class FreeSignalCardWidget extends SignalCardWidget {
  const FreeSignalCardWidget({
    super.key,
    // required this.lotSize,
    required this.tradingPair,
    required this.condition,
    required this.rsi,
    required this.sma,
    required this.tp,
    required this.currentPrice,
    this.symbol,
    this.result,
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
  final String condition;
  final String rsi;
  final String sma;
  final String tp;
  final String currentPrice;
  final String? symbol;
  final String? result;
  final String dateCreated;

  @override
  State<FreeSignalCardWidget> createState() => _FreeSignalCardWidget();
}

class _FreeSignalCardWidget extends State<FreeSignalCardWidget> {
  bool isExtended = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 12),
      // color: const Color.fromARGB(255, 7, 27, 44),
      // elevation: 2,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(12).copyWith(left: 14),
        child: isExtended
            ? Column(
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
                        widget.dateCreated,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
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
                        widget.condition,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: widget.condition == 'BUY'
                              ? Colors.green
                              : Colors.red,
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
                        'Trade Result',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.result!.toUpperCase() == 'PROFIT'
                            ? 'TAKE PROFIT'
                            : 'STOP LOSS',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: widget.result!.toUpperCase() == 'LOSS'
                              ? Colors.red
                              : Colors.green,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Symbol',
                    size: widget.symbol ?? 'XAUUSD',
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Open price',
                    size: widget.currentPrice,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Stop loss',
                    size: widget.sma,
                    isHigher: false,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Take Profit',
                    size: widget.tp,
                    isHigher: true,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tradingPair,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.dateCreated,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.result!.toUpperCase() == 'PROFIT'
                        ? 'Take Profit'
                        : 'Stop Loss',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.result!.toUpperCase() == 'PROFIT'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Text(
                    widget.condition,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          widget.condition == 'BUY' ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class PremiumSignalCardWidget extends SignalCardWidget {
  const PremiumSignalCardWidget({
    super.key,
    // required this.lotSize,

    required this.dateCreated,
    required this.tradingPair,
    required this.result,
    required this.currentPhase,
    required this.currentStep,
    required this.takeProfit,
    required this.stopLoss,
    required this.lotSize,
    required this.newAccountBalance,
    required this.tradeType,
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
  final String result;
  final String currentPhase;
  final String currentStep;
  final String takeProfit;
  final String stopLoss;
  final String lotSize;
  final String dateCreated;
  final String newAccountBalance;
  final String tradeType;

  @override
  State<PremiumSignalCardWidget> createState() => _PremiumSignalCardWidget();
}

class _PremiumSignalCardWidget extends State<PremiumSignalCardWidget> {
  bool isExtended = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 12),
      // color: const Color.fromARGB(255, 7, 27, 44),
      // elevation: 2,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(12).copyWith(left: 14),
        child: isExtended
            ? Column(
                children: [
                  SymbolRowWidget(
                    label: 'Symbol',
                    size: widget.tradingPair,
                  ),
                  const SizedBox(height: 10),
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
                        widget.dateCreated,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
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
                        'Trade Result',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.result.toUpperCase() == 'PROFIT'
                            ? 'TAKE PROFIT'
                            : 'STOP LOSS',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: widget.result == 'loss'
                              ? Colors.red
                              : Colors.green,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Current Phase',
                    size: widget.currentPhase,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Current Step',
                    size: widget.currentStep,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Lot Size',
                    size: widget.lotSize,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Stop loss',
                    size: widget.stopLoss,
                    isHigher: false,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Take Profit',
                    size: widget.takeProfit,
                    isHigher: true,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'New A/C Balance',
                    size: widget.newAccountBalance,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tradingPair,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.dateCreated,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.result.toUpperCase() == 'PROFIT'
                        ? 'Take Profit'
                        : 'Stop Loss',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.result.toUpperCase() == 'PROFIT'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Text(widget.lotSize),
                  Text(
                    widget.tradeType.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: widget.tradeType.toUpperCase() == 'BUY'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
