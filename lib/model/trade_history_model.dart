import 'package:intl/intl.dart';
import 'package:rell_trader/model/trade_model.dart';

class TradeHistoryModel {
  TradeHistoryModel({
    required this.createdAt,
    required this.id,
    required this.response,
    required this.symbol,
    required this.stopLoss,
    required this.takeProfit,
    required this.price,
    required this.tradeCondition,
  });
  String createdAt;
  String response;
  String symbol;
  double stopLoss;
  int id;
  double takeProfit;
  double price;
  TradeCondition tradeCondition;

  get currentTradeCondition =>
      tradeCondition == TradeCondition.buy ? 'BUY' : 'SELL';
  String get createdDate {
    try {
      return '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.parse(createdAt))}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.parse(createdAt))}';
    } catch (_) {
      return 'error';
    }
  }

  factory TradeHistoryModel.fromMap(Map<String, dynamic> data) {
    return TradeHistoryModel(
      createdAt: data['created_at'],
      symbol: data['symbol'],
      response: data['result'],
      id: data['id'],
      stopLoss: data['stop_loss'],
      takeProfit: data['take_profit'],
      price: data['price'],
      tradeCondition:
          data['type'] == 'SELL' ? TradeCondition.sell : TradeCondition.buy,
    );
  }

  @override
  String toString() {
    return {
      'Created At': createdDate,
      'Symbol': symbol,
      'Stop Loss': stopLoss.toStringAsFixed(2),
      'Take Profit': takeProfit.toStringAsFixed(2),
      'Price': price.toStringAsFixed(2),
      'ID': id,
      'Trade Result': response,
      'Trade Condition': currentTradeCondition,
    }.toString();
  }
}
