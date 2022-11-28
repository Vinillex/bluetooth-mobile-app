import 'package:bluetooth_app/get_its.dart';
import 'package:bluetooth_app/pages/phone/phone_device_interaction_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../ble/ble_device_connector.dart';

class PhoneDeviceDetailScreen extends StatefulWidget {
  final DiscoveredDevice device;

  const PhoneDeviceDetailScreen({required this.device, Key? key}) : super(key: key);

  @override
  State<PhoneDeviceDetailScreen> createState() => _PhoneDeviceDetailScreenState();
}

class _PhoneDeviceDetailScreenState extends State<PhoneDeviceDetailScreen> {

  BleDeviceConnector bleDeviceConnector = BleDeviceConnector(ble: ble, logMessage: bleLogger.addToLog);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bleDeviceConnector.disconnect(widget.device.id);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.device.name),
        ),
        body: StreamBuilder<ConnectionStateUpdate>(
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
          stream: bleDeviceConnector.state,
          builder: (context, snapshot) {
            return DeviceInteractionTab(
              connectionStatus: snapshot.data!.connectionState,
              deviceConnector: bleDeviceConnector,
              deviceId: widget.device.id,
              discoverServices: () => serviceDiscoverer.discoverServices(widget.device.id),
            );
          },
        ),
      ),
    );
  }
}
