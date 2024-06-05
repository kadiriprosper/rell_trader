enum TradeCondition {
  buy,
  sell,
}

class TradeModel {
  TradeModel({
    required this.status,
    required this.condition,
    required this.rsi,
    required this.sl,
    required this.tp,
    required this.currentPrice,
  });
  bool status;
  TradeCondition condition;
  double rsi;
  double sl;
  double tp;
  double currentPrice;

  factory TradeModel.fromMap(Map<String, dynamic> data) {
    return TradeModel(
      status: data['status'],
      condition: data['condition'].toString().toUpperCase() == 'BUY'
          ? TradeCondition.buy
          : TradeCondition.sell,
      rsi: data['RSI'],
      sl: data['SL'],
      tp: data['TP'],
      currentPrice: data['Current Price'],
    );
  }
}
