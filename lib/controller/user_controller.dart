import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rell_trader/controller/push_notification_controller.dart';
import 'package:rell_trader/model/user_model.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/main_screens/meta_trader_account_page.dart';

//TODO: Carry all the api to env file

// const String loginURL = 'http://81.0.249.14/auth/login/';
// const String registerURL = 'http://81.0.249.14/auth/register/';

//TODO: Remember to change this back

const String serverUrl = String.fromEnvironment('baseUrl');
const String loginUrl = '$serverUrl/auth/login/';
const String registrationUrl = '$serverUrl/auth/register/';
const String mt5ConnectionUrl = '$serverUrl/auth/connect/';
const String getUserUrl = '$serverUrl/auth/user/';
const String updateUserUrl = '$serverUrl/auth/update-user/';

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
        Uri.parse(loginUrl),
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
        print('tokn: $token');
        //TODO: Find a better place to put this guy
        await getUserDetails();
        PushNotificationController pushNotificationController =
            Get.put(PushNotificationController());
        await pushNotificationController.initNotifications(authToken: token);
        if (currentUser.accountNumber == null) {
          Get.offUntil(
            MaterialPageRoute(
              builder: (context) =>
                  const MetaTraderAccountPage(fromAccountSetup: true),
            ),
            (route) => false,
          );
        } else {
          Get.offUntil(
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
            (route) => false,
          );
        }
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
    required String firstName,
    required String lastName,
  }) async {
    http.Response? response;

    try {
      response = await http.post(Uri.parse(registrationUrl), body: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
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

  Future<bool> connectMT5Account({
    required int accountNumber,
    required String password,
    required String server,
    required String pair,
  }) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse(mt5ConnectionUrl),
        body: {
          'account': accountNumber.toString(),
          'password': password,
          'server': server,
          'pair': pair,
        },
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 205) {
        print(jsonDecode(response.body));
        return true;
      } else {
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getUserDetails() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(getUserUrl),
        headers: {
          'Authorization': token,
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 205) {
        print(response.body);
        currentUser = UserModel.fromMap(
          jsonDecode(response.body),
        );
        print(response.body);
        return true;
      } else {
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUserDetails({
    required String firstName,
    required String lastName,
  }) async {
    http.Response? response;
    try {
      response = await http.put(
        Uri.parse(updateUserUrl),
        body: {
          'first_name': firstName,
          'last_name': lastName,
        },
        headers: {
          'Authorization': token,
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 205) {
        print(response.body);
        return await getUserDetails();
      } else {
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
