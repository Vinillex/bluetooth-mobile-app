import 'dart:io';

import 'package:bluetooth_app/services/local_notification_service.dart';
import 'package:bluetooth_app/web_helpers/web_helper_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'get_its.dart';
import 'my_app.dart';

const redirect = bool.fromEnvironment('redirectToHttps', defaultValue: false);

Future<void> _firebaseBackGroundHandler(RemoteMessage message) async {
  print(message.notification!.title);
}

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  registerDependencies();

  LocalNotificationService.initializeApp();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackGroundHandler);


  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
