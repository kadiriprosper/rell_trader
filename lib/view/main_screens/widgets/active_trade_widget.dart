import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rell_trader/model/active_trade_model.dart';
import 'package:rell_trader/view/main_screens/widgets/symbol_row_widget.dart';

class ActiveTradeWidget extends StatefulWidget {
  const ActiveTradeWidget({
    super.key,
    required this.activeTrade,
  });

  final ActiveTradeModel? activeTrade;

  @override
  State<ActiveTradeWidget> createState() => _ActiveTradeWidgetState();
}

class _ActiveTradeWidgetState extends State<ActiveTradeWidget> {
  bool isExtended = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExtended = !isExtended;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        color: const Color.fromARGB(255, 7, 27, 44),
        child: isExtended
            ? Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.activeTrade!.symbol,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now())}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const SymbolRowWidget(
                    label: 'Trade Status',
                    size: 'Active',
                    isHigher: true,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Trade Condition',
                    size: widget.activeTrade!.tradeType.toUpperCase(),
                    isHigher:
                        widget.activeTrade!.tradeType.toUpperCase() == 'BUY'
                            ? true
                            : false,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Open Price',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.activeTrade!.openPrice.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Price',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.activeTrade!.currentPrice.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  SymbolRowWidget(
                    label: 'Stop Loss',
                    size: widget.activeTrade!.stopLoss.toStringAsFixed(2),
                    isHigher: false,
                  ),
                  const SizedBox(height: 10),
                  SymbolRowWidget(
                    label: 'Take Profit',
                    size: widget.activeTrade!.takeProfit.toStringAsFixed(2),
                    isHigher: true,
                  ),
                  // const SizedBox(height: 10),
                  // SymbolRowWidget(
                  //   label: 'Lot Size',
                  //   size: widget.activeTrade!.lotSize.toStringAsFixed(2),
                  //   isHigher: false,
                  // ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.activeTrade!.symbol,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now())}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Active',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  // Text(widget.activeTrade!.lotSize.toStringAsFixed(2)),
                  Text(
                    widget.activeTrade!.tradeType.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          widget.activeTrade!.tradeType.toUpperCase() == 'BUY'
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
