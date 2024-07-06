class UserModel {
  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.accountNumber,
    this.metaServer,
    this.automationActive,
    this.verified,
  });
  String email;
  String firstName;
  String lastName;
  int? accountNumber;
  String? metaServer;
  bool? automationActive;
  bool? verified;

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      email: data['user_data']['email'],
      firstName: data['user_data']['first_name'],
      lastName: data['user_data']['last_name'],
      accountNumber: data['trade_account_data']['account'],
      metaServer: data['trade_account_data']['server_name'],
      automationActive: data['trade_account_data']['activate_automation'],
      verified: data['trade_account_data']['verified'],
    );
  }
}
