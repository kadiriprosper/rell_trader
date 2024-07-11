import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';

const tempNotificationRegistrationUrl =
    '$serverUrl/notif/register_notification/';

class PushNotificationController extends GetxController {
  //Creates an instance of the firebase messaging application
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  ///Requests permission to receive notfications on the phone
  ///and sends the FCM token to the server
  ///- [authToken] is required
  Future<void> initNotifications({required String authToken}) async {
    //Reques permission to receive push notifications on the devicw
    await firebaseMessaging.requestPermission();

    //Gets the FCM token
    final fMToken = await firebaseMessaging.getToken();

    try {
      await http.post(
        Uri.parse(tempNotificationRegistrationUrl),
        body: {
          "token": fMToken,
          "type": "android",
        },
        headers: {
          'Authorization': authToken,
        },
      );
    } catch (_) {}
  }

  ///Destroy access to the former FCM token
  ///
  ///Server requests to this token would be void
  Future<void> revokeNotification() async {
    print('Revoke Authorized');
    //Render the FCM token sent previously as useless
    await firebaseMessaging.deleteToken();
  }

  Future<void> handleNotification(RemoteMessage? message) async {
    //If there is no message sent, don't do anything
    if (message == null) {
      return;
    } else {
      //Go to the dashboard screen on message clicked
      Get.to(() => const DashboardScreen());
    }
  }

  Future initPushNotification() async {
    //Handle notification if the application is closed
    await firebaseMessaging.getInitialMessage().then(handleNotification);

    // attach event listeners for when a notification opens the application
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
  }
}
