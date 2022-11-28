import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_app/pages/phone/phone_device_list_screen.dart';
import 'package:bluetooth_app/pages/phone/status_screen.dart';
import 'package:bluetooth_app/providers/futures/phone/remote_config_notifier.dart';
import 'package:bluetooth_app/providers/streams/phone/ble_status_stream.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PhoneHomePage extends ConsumerStatefulWidget {
  const PhoneHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends ConsumerState<PhoneHomePage> {
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> discoveredDevice = [];
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    Future.microtask(() async {
      await _initPackageInfo();
      await setUpRemoteConfig();
    });
    super.initState();
  }

  Future setUpRemoteConfig() async {
    await ref.read(remoteConfigNotifier.notifier).getRemoteConfig();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bleStatusState = ref.watch(bleStatusStream);
    ref.listen<AsyncValue<FirebaseRemoteConfig>>(remoteConfigNotifier,
        (previous, next) {
      next.whenData(
        (value) => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New update is available'),
              content: Text('You are currently at app version : ' +
                  _packageInfo.version +
                  '. New app version is available : ' +
                  value.getString('appVersion')),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Update later')),
                ElevatedButton(onPressed: () {}, child: Text('Update Now')),
              ],
            );
          },
        ),
      );
    });

    return Scaffold(
      body: bleStatusState.when(data: (data) {
        if (data == BleStatus.ready) {
          return PhoneDeviceListScreen();
        } else {
          return BleStatusScreen(
            status: data,
          );
        }
      }, error: (e, _) {
        return Center(
          child: Text(
            'Error',
          ),
        );
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
