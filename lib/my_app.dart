import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_app/pages/home_screen.dart';
import 'package:bluetooth_app/services/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_app/router/app_router.gr.dart';
import 'package:http/http.dart' as http;

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppRouter appRouter;

  String serverToken =
      'AAAAOgjXn0E:APA91bEXNQDt-B6nCgyuleHx-5L-t1ri9Pli-tXLOSBoTl3bBnK-psw2LTgvwRhvmniQNPWw1T66Z7srDHki-IjSm3-0IuXa3UbwZBt2o_TWFLJ8Y-VDEhWDygEaGh1IAWiQakxbC4NS';

  String constructFCMPayload() {
    return jsonEncode({
      'to': "/topics/all",
      'data': {
        'via': 'Cloud Messaging!!!',
        'route': 'something',
      },
      'notification': {
        'title': 'Thank for registering!',
        'body': 'created via FCM!',
      },
    });
  }

  Future<void> sendPushMessage() async {
    try {
      final result = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: constructFCMPayload(),
      );
      print(constructFCMPayload());
      print(result.statusCode.toString() +
          result.headers.toString() +
          result.request!.method);
      print('FCM request for sent!');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // FirebaseMessaging.instance.subscribeToTopic('all');

    // Gives initial message when user taps on screen
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.data.toString());
      }
    });

    //App in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    //App in background but open
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.notification!.title);
    });
    print('My App');
    appRouter = AppRouter();

    Timer(Duration(seconds: 5), () {
      FirebaseMessaging.instance
          .subscribeToTopic('all')
          .then((value) => sendPushMessage());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [
          // FirebaseAnalyticsObserver(
          //   analytics: FirebaseAnalytics.instance,
          // ),
        ],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
    );
  }
}
