import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:flutter_web_bluetooth/js_web_bluetooth.dart';

import '../../providers/streams/web/bluetooth_available_notifier.dart';
import '../../router/app_router.gr.dart';
import '../../widgets/browser_not_supported_alert_widget.dart';
import 'web_device_list_page.dart';

class WebHomePage extends ConsumerStatefulWidget {
  const WebHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends ConsumerState<WebHomePage> {

  @override
  Widget build(BuildContext context) {
    final bluetoothState = ref.watch(isBluetoothAvailableStream);
    return Scaffold(
      appBar: AppBar(
        title: const SelectableText('Bluetooth'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (!FlutterWebBluetooth.instance.isBluetoothApiSupported) {
                BrowserNotSupportedAlertWidget.showCustomDialog(context);
              } else {
                try {
                  final device = await FlutterWebBluetooth.instance
                      .requestDevice(RequestOptionsBuilder.acceptAllDevices(
                      optionalServices: BluetoothDefaultServiceUUIDS.VALUES
                          .map((e) => e.uuid)
                          .toList()));
                  debugPrint("Device got! ${device.name}, ${device.id}");
                } on BluetoothAdapterNotAvailable {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(
                      content: const Text('No bluetooth adapter available'),
                    ),
                  );
                } on UserCancelledDialogError {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(
                      content: const Text('User canceled the dialog'),
                    ),
                  );
                } on DeviceNotFoundError {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(
                      content: const Text('No devices found'),
                    ),
                  );
                }
              }
            },
            child: const Icon(Icons.search),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(
              'Refresh',
            ),
          ),
        ],
      ),
      body: bluetoothState.when(
        data: (data) {
          return DeviceListPage(
            isBluetoothAvailable: data,
          );
        },
        error: (error, _) {
          return const Center(
            child: Text('Error'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
