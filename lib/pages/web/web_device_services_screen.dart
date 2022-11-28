import 'package:bluetooth_app/providers/futures/selected_bluetooth_device_notifier.dart';
import 'package:bluetooth_app/providers/streams/web/bluetooth_services_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';

import '../../providers/streams/web/device_availablity_notifier.dart';
import '../../widgets/service_widget.dart';

class WebDeviceServicesScreen extends ConsumerStatefulWidget {
  final BluetoothDevice bluetoothDevice;

  const WebDeviceServicesScreen({Key? key, required this.bluetoothDevice})
      : super(key: key);

  @override
  ConsumerState<WebDeviceServicesScreen> createState() =>
      WebDeviceServicesScreenState();
}

class WebDeviceServicesScreenState extends ConsumerState<WebDeviceServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: widget.bluetoothDevice.connected,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: SelectableText(widget.bluetoothDevice.name ?? 'No name set'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (!widget.bluetoothDevice.hasGATT) {
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      SnackBar(
                        content: const Text('This device has no GATT'),
                      ),
                    );
                    return;
                  }
                  if (snapshot.data!) {
                    widget.bluetoothDevice.disconnect();
                  } else {
                    await widget.bluetoothDevice.connect();
                  }
                },
                child: Text(snapshot.data! ? 'Disconnect' : 'Connect'),
              ),
            ],
          ),
          body: (snapshot.data!)
              ? StreamBuilder<List<BluetoothService>>(
                  stream: widget.bluetoothDevice.services,
                  initialData: [],
                  builder: (context, snapshot) {
                    final list = snapshot.data!;
                    if (list.isEmpty) {
                      return const Center(
                        child: Text('No services found!'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          return ServiceWidget(
                            service: list[i],
                          );
                        },
                      );
                    }
                  },
                )
              : const Center(
                  child: Text('Click connect first'),
                ),
        );
      },
    );
  }
}
