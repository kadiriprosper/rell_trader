import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rell_trader/model/user_model.dart';

const String loginURL = 'http://81.0.249.14/auth/login/';
const String registerURL = 'http://81.0.249.14/auth/register/';

class UserController extends GetxController {
  late UserModel currentUser;

  final secureStorage = const FlutterSecureStorage();

  String token = '';

  Future<bool> userLogin({
    required String email,
    required String password,
  }) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse(loginURL),
        body: {
          'email': email,
          'password': password,
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // currentUser = UserModel.fromMap(
        //   jsonDecode(response.body),
        // );
        //TODO: save the user details for auto login
        secureStorage.write(key: 'email', value: email);
        secureStorage.write(key: 'password', value: password);
        token = jsonDecode(response.body)['token'];
        return true;
      } else {
        print('Registration Error - ${jsonDecode(response.body)['detail']}');
        return false;
      }
    } catch (e) {
      print('Registration error - $e');
      return false;
    }
  }

  Future<bool> userSignUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    http.Response? response;
    try {
      response = await http.post(Uri.parse(registerURL), body: {
        'email': email,
        'password': password,
        'fullname': fullName,
      });

      if (response.statusCode >= 200 && response.statusCode < 205) {
        return await userLogin(email: email, password: password);
      } else {
        print(jsonDecode(response.body)['detail']);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
