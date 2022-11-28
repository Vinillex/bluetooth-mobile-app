import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_app/ble/ble_device_connector.dart';
import 'package:bluetooth_app/ble/ble_scanner.dart';
import 'package:bluetooth_app/providers/streams/phone/ble_scanner_state_stream.dart';
import 'package:bluetooth_app/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../get_its.dart';
import '../../providers/futures/phone/ble_scanner_notifier.dart';

class PhoneDeviceListScreen extends ConsumerStatefulWidget {
  const PhoneDeviceListScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PhoneDeviceListScreen> createState() =>
      _PhoneDeviceListScreenState();
}

class _PhoneDeviceListScreenState extends ConsumerState<PhoneDeviceListScreen> {
  late TextEditingController _uuidController;

  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    scanner.stopScan();
    _uuidController.dispose();
    super.dispose();
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }

  void _startScanning() {
    final text = _uuidController.text;
    scanner.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
  }

  @override
  Widget build(BuildContext context) {
    //final scanner = ref.watch(bleScanner);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan for devices'),
        actions: [
          ElevatedButton(
            onPressed: () {
              context.router.push(WebsiteViewRoute());
            },
            child: Text(
              'Browser',
            ),
          ),
        ],
      ),
      body: StreamBuilder<BleScannerState>(
          initialData: BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
          stream: scanner.state,
          builder: (context, snapshot) {
            final data = snapshot.data;
            return Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text('Service UUID (2, 4, 16 bytes):'),
                      TextField(
                        controller: _uuidController,
                        enabled: !data!.scanIsInProgress,
                        decoration: InputDecoration(
                            errorText: (_uuidController.text.isEmpty ||
                                _isValidUuidInput())
                                ? null
                                : 'Invalid UUID format'),
                        autocorrect: false,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed:
                            (!data.scanIsInProgress && _isValidUuidInput())
                                ? () {
                              final text = _uuidController.text;
                              scanner.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
                            }
                                : null,
                            child: const Text('Scan'),
                          ),
                          ElevatedButton(
                            child: const Text('Stop'),
                            onPressed:
                            data.scanIsInProgress ? scanner.stopScan : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(!data.scanIsInProgress
                                ? 'Enter a UUID above and tap start to begin scanning'
                                : 'Tap a device to connect to it'),
                          ),
                          if (data.scanIsInProgress ||
                              data.discoveredDevices.isNotEmpty)
                            Padding(
                              padding:
                              const EdgeInsetsDirectional.only(start: 18.0),
                              child:
                              Text('count: ${data.discoveredDevices.length}'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView(
                    children: data.discoveredDevices
                        .map(
                          (device) => ListTile(
                        title: Text(device.name),
                        subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                        onTap: () async {
                          await scanner.stopScan();
                          context.router.push(PhoneDeviceDetailRoute(device: device));

                        },
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
