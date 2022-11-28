import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';

final selectedBluetoothDevice =
StateNotifierProvider<DeviceNotifier, BluetoothDevice?>((ref) {
  return DeviceNotifier();
});

class DeviceNotifier extends StateNotifier<BluetoothDevice?> {
  DeviceNotifier() : super(null);

  Future setDevice(BluetoothDevice bluetoothDevice) async{
    state = bluetoothDevice;
  }
}