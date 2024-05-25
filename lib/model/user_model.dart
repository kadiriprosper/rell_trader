class UserModel {
  UserModel({
    required this.email,
    required this.token,
  });
  String email;
  String token;

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'],
      token: data['token'],
    );
  }
}
