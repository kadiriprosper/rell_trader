class PremiumTradeModel {
  PremiumTradeModel({
    required this.response,
    required this.currentPhase,
    required this.currentStep,
    required this.lotSize,
    required this.newAccountBalance,
    required this.stopLoss,
    required this.takeProfit,
    required this.tradeType,
  });
  String response;
  int currentPhase;
  int currentStep;
  double lotSize;
  double stopLoss;
  double takeProfit;
  double newAccountBalance;
  String tradeType;

  factory PremiumTradeModel.fromMap(Map<String, dynamic> data) {
    return PremiumTradeModel(
      response: data['data']['result'],
      currentPhase: data['data']['current_phase'],
      currentStep: data['data']['current_step'],
      lotSize: data['data']['lot_size'],
      stopLoss: data['data']['stop_loss'],
      takeProfit: data['data']['take_profit'],
      newAccountBalance: data['data']['new_balance'],
      tradeType: data['data']['trade_type'],
    );
  }
}
