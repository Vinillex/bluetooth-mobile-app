import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initializeApp() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));

    _notificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {

    try{
      final id = DateTime.now().millisecondsSinceEpoch / 1000;

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'android_notification_id',
          'android_notification',
          priority: Priority.high,
          importance: Importance.max,
        ),
      );
      await _notificationsPlugin.show(
        id.round(),
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        //payload: message.data['route'],
      );
    } on Exception catch (e){
      print(e.toString());
    }
  }
}
