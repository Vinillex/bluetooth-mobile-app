import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../get_its.dart';

final bleStatusStream = StreamProvider<BleStatus>((ref) {
  return ble.statusStream;
});