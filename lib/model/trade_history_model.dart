import 'package:intl/intl.dart';
import 'package:rell_trader/model/trade_model.dart';

class TradeHistoryModel extends TradeSignalModel {
  TradeHistoryModel({
    required super.createdAt,
    required this.id,
    required super.response,
    required super.symbol,
    required super.stopLoss,
    required super.takeProfit,
    required super.openPrice,
    required super.tradeCondition,
  });
  int id;

  // get currentTradeCondition =>
  //     tradeCondition == TradeCondition.buy ? 'BUY' : 'SELL';
  @override
  String get createdAt {
    try {
      return '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.parse(super.createdAt))}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.parse(super.createdAt))}';
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
      openPrice: data['price'],
      tradeCondition: (data['type'] as String).toUpperCase(),
    );
  }

  @override
  String toString() {
    return {
      'Created At': createdAt,
      'Symbol': symbol,
      'Stop Loss': stopLoss.toStringAsFixed(2),
      'Take Profit': takeProfit.toStringAsFixed(2),
      'Price': openPrice.toStringAsFixed(2),
      'ID': id,
      'Trade Result': response,
      'Trade Condition': tradeCondition,
    }.toString();
  }
}
