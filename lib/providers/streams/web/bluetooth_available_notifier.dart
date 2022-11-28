import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';

final isBluetoothAvailableStream = StreamProvider<bool>((ref) {
  return FlutterWebBluetooth.instance.isAvailable;
});