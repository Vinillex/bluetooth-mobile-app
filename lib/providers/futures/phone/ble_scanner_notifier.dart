import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ble/ble_scanner.dart';
import '../../../get_its.dart';

final bleScanner =
StateProvider<BleScanner>((ref) {
  return BleScanner(ble: ble, logMessage: bleLogger.addToLog);
});