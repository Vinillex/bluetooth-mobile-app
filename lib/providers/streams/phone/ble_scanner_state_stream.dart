import 'package:bluetooth_app/providers/futures/phone/ble_scanner_notifier.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ble/ble_scanner.dart';
import '../../../get_its.dart';


final bleScannerStateStream = StreamProvider<BleScannerState>((ref) {
  final bleScannerState = ref.watch(bleScanner);
  return bleScannerState.state;
});