import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_app/pages/phone/phone_home_page.dart';
import 'package:bluetooth_app/pages/phone/testing_phone_home_page.dart';
import 'package:bluetooth_app/pages/web/web_home_page.dart';
import 'package:bluetooth_app/providers/streams/web/bluetooth_available_notifier.dart';
import 'package:bluetooth_app/router/app_router.gr.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:flutter_web_bluetooth/js_web_bluetooth.dart';

import '../widgets/browser_not_supported_alert_widget.dart';
import 'web/web_device_list_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      print('object');
      return WebHomePage();
    }else{
      return PhoneHomePage();
    }
  }
}
