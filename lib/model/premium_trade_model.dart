class PremiumTradeModel {
  PremiumTradeModel({
    required this.status,
    required this.message,
  });
  String status;
  String message;

  factory PremiumTradeModel.fromMap(Map<String, dynamic> data) {
    return PremiumTradeModel(
      status: data['status'],
      message: data['message'],
    );
  }
}
