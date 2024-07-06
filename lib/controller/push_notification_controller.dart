import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/main_screen_navigation_controller.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:http/http.dart' as http;

// const notificationRegistrationAPI =
//     'http://81.0.249.14:80/notif/register_notification/';

const tempNotificationRegistrationUrl =
    'https://strangely-cheerful-lion.ngrok-free.app/notif/register_notification/';

class PushNotificationController extends GetxController {
  //Creates an instance of the firebase messaging application
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  MainScreenNavigationController mainScreenNavigationController =
      Get.put(MainScreenNavigationController());

  //function to init notifications
  Future<void> initNotifications({required String authToken}) async {
    await firebaseMessaging.requestPermission();
    final fMToken = await firebaseMessaging.getToken();
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse(tempNotificationRegistrationUrl),
        body: {
          "token": fMToken,
          "type": "android",
        },
        headers: {
          'Authorization': authToken,
        },

      );
      print('token: $fMToken');
      print(response.body);
    } catch (e) {
      print(e);
    }
    
  }

  Future<void> handleNotification(RemoteMessage? message) async {
    if (message == null) {
      return;
    } else {
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
