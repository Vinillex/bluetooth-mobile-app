import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';

final bluetoothDevicesStream = StreamProvider<Set<BluetoothDevice>>((ref) {
  return FlutterWebBluetooth.instance.devices;
});