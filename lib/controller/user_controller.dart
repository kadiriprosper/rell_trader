import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:rell_trader/controller/push_notification_controller.dart';
import 'package:rell_trader/model/user_model.dart';
import 'package:rell_trader/view/auth/login_screen.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/main_screens/meta_trader_account_page.dart';

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

  Future<void> userLogout() async {

    // Delete all the user's details from storage
    secureStorage.delete(key: 'email');
    secureStorage.delete(key: 'password');

    //Make token and current user empty
    token = '';
    currentUser = UserModel(
      email: '',
      firstName: '',
      lastName: '',
    ); 

    await PushNotificationController().revokeNotification();

    //Go to the login screen
    Get.offUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

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
        //Saves the user details for auto login using the package FlutterSecureStorage
        secureStorage.write(key: 'email', value: email);
        secureStorage.write(key: 'password', value: password);

        //Gets the token from the api response and stores it in the controller
        token = jsonDecode(response.body)['token'];

        await getUserDetails();
        
        await PushNotificationController().initNotifications(authToken: token);

        //If the current account number for the user is null, then the user has not linked their mt5 account
        if (currentUser.accountNumber == null) {
          //Go to the account linking page
          Get.offUntil(
            MaterialPageRoute(
              builder: (context) =>
                  const MetaTraderAccountPage(fromAccountSetup: true),
            ),
            (route) => false,
          );
        } else {
          // If the user has linked the account, go to the dashboard screen
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
        //If the registration is successful, go on to login the user
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
        
        // Once the user details is gotten from the server, then store the current user's details
        currentUser = UserModel.fromMap(
          jsonDecode(response.body),
        );
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
