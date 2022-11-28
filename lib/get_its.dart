import 'package:bluetooth_app/services/remote_config_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';

import 'ble/ble_device_connector.dart';
import 'ble/ble_device_interactor.dart';
import 'ble/ble_logger.dart';
import 'ble/ble_scanner.dart';
import 'ble/ble_status_monitor.dart';

final GetIt getIt = GetIt.instance;

void registerDependencies() {
  getIt.registerSingleton<GlobalKey>(GlobalKey<ScaffoldMessengerState>());
  getIt.registerSingleton<FlutterReactiveBle>(FlutterReactiveBle());
  getIt.registerSingleton<BleLogger>(BleLogger());
  getIt.registerSingleton<BleScanner>(
      BleScanner(ble: ble, logMessage: bleLogger.addToLog));
  getIt.registerSingleton<BleStatusMonitor>(BleStatusMonitor(ble));
  getIt.registerSingleton<BleDeviceConnector>(BleDeviceConnector(
    ble: ble,
    logMessage: bleLogger.addToLog,
  ));
  getIt.registerSingleton<BleDeviceInteractor>(BleDeviceInteractor(
    bleDiscoverServices: ble.discoverServices,
    readCharacteristic: ble.readCharacteristic,
    writeWithResponse: ble.writeCharacteristicWithResponse,
    writeWithOutResponse: ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: ble.subscribeToCharacteristic,
    logMessage: bleLogger.addToLog,
  ));

  getIt.registerSingleton<RemoteConfigService>(RemoteConfigService());
}

final globalKey = getIt.get<GlobalKey>();
final ble = getIt.get<FlutterReactiveBle>();
final bleLogger = getIt.get<BleLogger>();
final scanner = getIt.get<BleScanner>();
final monitor = getIt.get<BleStatusMonitor>();
final connector = getIt.get<BleDeviceConnector>();
final serviceDiscoverer = getIt.get<BleDeviceInteractor>();
final remoteConfigService = getIt.get<RemoteConfigService>();
// final monitor = getIt.get<BleStatusMonitor>();
