import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_app/pages/web/web_device_services_screen.dart';
import 'package:bluetooth_app/providers/futures/selected_bluetooth_device_notifier.dart';
import 'package:bluetooth_app/router/app_router.gr.dart';

import 'package:bluetooth_app/widgets/bluetooth_device_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';

import '../../providers/streams/web/bluetooth_devices_notifier.dart';

class DeviceListPage extends ConsumerStatefulWidget {
  final bool isBluetoothAvailable;

  const DeviceListPage({
    Key? key,
    required this.isBluetoothAvailable,
  }) : super(key: key);

  @override
  ConsumerState<DeviceListPage> createState() => DeviceListPageState();
}

class DeviceListPageState extends ConsumerState<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    final bluetoothDevicesState = ref.watch(bluetoothDevicesStream);
    return Column(children: [
      MainPageHeader(
        isBluetoothAvailable: widget.isBluetoothAvailable,
      ),
      const Divider(),
      Expanded(
        child: bluetoothDevicesState.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final device = data.toList()[index];
                return BluetoothDeviceWidget(
                  bluetoothDevice: device,
                  onTap: () async{
                    context.router.push(WebDeviceServicesRoute(bluetoothDevice: device,),);
                  },
                );
              },
            );
          },
          error: (e, _) {
            return Center(
              child: Text(
                'Error',
              ),
            );
          },
          loading: () {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    ]);
  }
}

class MainPageHeader extends StatelessWidget {
  const MainPageHeader({Key? key, required this.isBluetoothAvailable})
      : super(key: key);

  final bool isBluetoothAvailable;

  @override
  Widget build(BuildContext context) {
    final text = isBluetoothAvailable ? 'supported' : 'unsupported';

    final screenWidth = MediaQuery.of(context).size.width;
    final phoneSize = screenWidth <= 620.0;

    final children = <Widget>[
      SizedBox(
          width: phoneSize ? screenWidth : screenWidth * 0.5,
          child: ListTile(
            title: const SelectableText('Bluetooth api available'),
            subtitle: SelectableText(
                FlutterWebBluetooth.instance.isBluetoothApiSupported
                    ? 'true'
                    : 'false'),
          )),
      SizedBox(
          width: phoneSize ? screenWidth : screenWidth * 0.5,
          child: ListTile(
            title: const SelectableText('Bluetooth available'),
            subtitle: SelectableText(text),
          )),
    ];

    if (phoneSize) {
      children.insert(1, const Divider());
      return Column(
        children: children,
      );
    } else {
      return Row(children: children);
    }
  }
}
