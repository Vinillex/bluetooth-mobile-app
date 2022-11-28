import 'dart:async';
import 'dart:io' show Platform;

//import 'package:location_permissions/location_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class TestingHomePage extends StatefulWidget {
  const TestingHomePage({Key? key}) : super(key: key);

  @override
  _TestingHomePageState createState() => _TestingHomePageState();
}

class _TestingHomePageState extends State<TestingHomePage> {
// Some state management stuff
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;
  List<DiscoveredDevice> discoveredList = [];

// Bluetooth related variables
  late DiscoveredDevice _ubiqueDevice;
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _rxCharacteristic;

// These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse("75C276C3-8F97-20BC-A143-B354244886D4");
  final Uuid characteristicUuid =
      Uuid.parse("6ACF4F08-CC9D-D495-6B41-AA7E60C4E8A6");

  void _startScan() async {
// Platform permissions handling stuff
    bool permGranted = true;
    setState(() {
      _scanStarted = true;
    });
    // PermissionStatus permission;
    // if (Platform.isAndroid) {
    //   permission = await LocationPermissions().requestPermissions();
    //   if (permission == PermissionStatus.granted) permGranted = true;
    // } else if (Platform.isIOS) {
    //   permGranted = true;
    // }
// Main scanning logic happens here ⤵️
    if (permGranted) {
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        // Change this string to what you defined in Zephyr
        if (discoveredList
            .where((element) => element.id == device.id)
            .toList()
            .isEmpty) {
          discoveredList.add(device);
          setState(() {});
          print(device.id + device.name);
        }

        if (device.name == 'UBIQUE') {
          setState(() {
            _ubiqueDevice = device;
            _foundDeviceWaitingToConnect = true;
          });
        }
      });
    }
  }

  void _connectToDevice(String deviceID) {
    // We're done scanning, we can cancel it
    _scanStream.cancel();
    // Let's listen to our connection so we can make updates on a state change
    Stream<ConnectionStateUpdate> _currentConnectionStream = flutterReactiveBle
        .connectToAdvertisingDevice(
            id: deviceID,
            prescanDuration: const Duration(seconds: 1),
            withServices: []);
    _currentConnectionStream.listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            print('Connected');
            // _rxCharacteristic = QualifiedCharacteristic(
            //     serviceId: serviceUuid,
            //     characteristicId: characteristicUuid,
            //     deviceId: event.deviceId);
            setState(() {
              _foundDeviceWaitingToConnect = false;
              _connected = true;
            });
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            print('DisConnected');
            break;
          }

        case DeviceConnectionState.connecting:
          {
            print('Connecting');
            break;
          }
        default:
      }
    });
  }

  void _partyTime() {
    if (_connected) {
      flutterReactiveBle
          .writeCharacteristicWithResponse(_rxCharacteristic, value: [
        0xff,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: discoveredList.length,
          itemBuilder: (context, i) {
            return ListTile(
              onTap: ()=>_connectToDevice.call(discoveredList[i].id),
              title: Text(discoveredList[i].name),
              subtitle: Text(discoveredList[i].id),
            );
          }),
      persistentFooterButtons: [
        // We want to enable this button if the scan has NOT started
        // If the scan HAS started, it should be disabled.
        _scanStarted
            // True condition
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {},
                child: const Icon(Icons.search),
              )
            // False condition
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: _startScan,
                child: const Icon(Icons.search),
              ),
        // _foundDeviceWaitingToConnect
        //     // True condition
        //     ? ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           primary: Colors.blue, // background
        //           onPrimary: Colors.white, // foreground
        //         ),
        //         onPressed: _connectToDevice.call(),
        //         child: const Icon(Icons.bluetooth),
        //       )
        //     // False condition
        //     : ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           primary: Colors.grey, // background
        //           onPrimary: Colors.white, // foreground
        //         ),
        //         onPressed: () {},
        //         child: const Icon(Icons.bluetooth),
        //       ),
        _connected
            // True condition
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: _partyTime,
                child: const Icon(Icons.celebration_rounded),
              )
            // False condition
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {},
                child: const Icon(Icons.celebration_rounded),
              ),
      ],
    );
  }
}
