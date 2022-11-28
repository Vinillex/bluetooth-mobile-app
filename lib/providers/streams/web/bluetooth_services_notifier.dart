import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';

import '../../futures/selected_bluetooth_device_notifier.dart';
import '../../futures/selected_bluetooth_device_notifier.dart';

final bluetoothServicesStream = StreamProvider<List<BluetoothService>>((ref) {
  final device = ref.watch(selectedBluetoothDevice)!;
  return device.services;
});