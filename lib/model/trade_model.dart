enum TradeCondition {
  buy,
  sell,
}

class TradeModel {
  TradeModel({
    required this.status,
    required this.condition,
    required this.rsi,
    required this.sma,
    required this.currentPrice,
  });
  bool status;
  TradeCondition condition;
  double rsi;
  double sma;
  double currentPrice;

  factory TradeModel.fromMap(Map<String, dynamic> data) {
    return TradeModel(
      status: data['status'],
      condition:
          data['condition'] == 'buy' ? TradeCondition.buy : TradeCondition.sell,
      rsi: data['RSI'],
      sma: data['14 SMA'],
      currentPrice: data['Current Price'],
    );
  }
}
