import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:functional_data/functional_data.dart';

import '../../ble/ble_device_connector.dart';
import '../../ble/ble_device_interactor.dart';
import '../../get_its.dart';

class DeviceInteractionTab extends StatefulWidget {
  const DeviceInteractionTab({
    required this.deviceId,
    required this.connectionStatus,
    required this.deviceConnector,
    required this.discoverServices,
    Key? key,
  }) : super(key: key);

  final String deviceId;
  final DeviceConnectionState connectionStatus;
  final BleDeviceConnector deviceConnector;
  final Future<List<DiscoveredService>> Function() discoverServices;

  @override
  _DeviceInteractionTabState createState() => _DeviceInteractionTabState();
}

class _DeviceInteractionTabState extends State<DeviceInteractionTab> {
  late List<DiscoveredService> discoveredServices;

  @override
  void initState() {
    discoveredServices = [];
    super.initState();
  }

  Future<void> discoverServices() async {
    final result = await widget.discoverServices();
    setState(() {
      discoveredServices = result;
    });
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      top: 8.0, bottom: 16.0, start: 16.0),
                  child: Text(
                    "ID: ${widget.deviceId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16.0),
                  child: Text(
                    "Status: ${widget.connectionStatus}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: (widget.connectionStatus ==
                                DeviceConnectionState.disconnected)
                            ? () async {
                                print('call');
                                await widget.deviceConnector.connect
                                    .call(widget.deviceId);
                                print('finish');
                                setState(() {});
                              }
                            : null,
                        child: const Text("Connect"),
                      ),
                      ElevatedButton(
                        onPressed: (widget.connectionStatus ==
                                DeviceConnectionState.connected)
                            ? () async {
                                print('dis call');
                                await widget.deviceConnector.disconnect
                                    .call(widget.deviceId);
                              }
                            : null,
                        child: const Text("Disconnect"),
                      ),
                      ElevatedButton(
                        onPressed: (widget.connectionStatus ==
                                DeviceConnectionState.connected)
                            ? () {
                                discoverServices.call();
                              }
                            : null,
                        child: const Text("Discover Services"),
                      ),
                    ],
                  ),
                ),
                if (widget.connectionStatus == DeviceConnectionState.connected)
                  _ServiceDiscoveryList(
                    deviceId: widget.deviceId,
                    discoveredServices: discoveredServices,
                  ),
              ],
            ),
          ),
        ],
      );
}

class _ServiceDiscoveryList extends StatefulWidget {
  const _ServiceDiscoveryList({
    required this.deviceId,
    required this.discoveredServices,
    Key? key,
  }) : super(key: key);

  final String deviceId;
  final List<DiscoveredService> discoveredServices;

  @override
  _ServiceDiscoveryListState createState() => _ServiceDiscoveryListState();
}

class _ServiceDiscoveryListState extends State<_ServiceDiscoveryList> {
  late final List<int> _expandedItems;
  //final TextEditingController controller = TextEditingController();
  // String notificationText = '';
  // String readText = '';

  @override
  void initState() {
    _expandedItems = [];
    super.initState();
  }

  // String _charactisticsSummary(DiscoveredCharacteristic c) {
  //   final props = <String>[];
  //   if (c.isReadable) {
  //     props.add("read");
  //   }
  //   if (c.isWritableWithoutResponse) {
  //     props.add("write without response");
  //   }
  //   if (c.isWritableWithResponse) {
  //     props.add("write with response");
  //   }
  //   if (c.isNotifiable) {
  //     props.add("notify");
  //   }
  //   if (c.isIndicatable) {
  //     props.add("indicate");
  //   }
  //
  //   return props.join("\n");
  // }



  List<ExpansionPanel> buildPanels() {
    final panels = <ExpansionPanel>[];

    widget.discoveredServices.asMap().forEach(
          (index, service) => panels.add(
            ExpansionPanel(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 16.0),
                    child: Text(
                      'Characteristics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => CharacteristicTile(
                      characteristic: service.characteristics[index],
                      deviceId: widget.deviceId,
                      service: service,
                    ),
                    itemCount: service.characteristicIds.length,
                  ),
                ],
              ),
              headerBuilder: (context, isExpanded) => ListTile(
                title: Text(
                  '${service.serviceId}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              isExpanded: _expandedItems.contains(index),
            ),
          ),
        );

    return panels;
  }

  @override
  Widget build(BuildContext context) => widget.discoveredServices.isEmpty
      ? const SizedBox()
      : Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 20.0,
            start: 20.0,
            end: 20.0,
          ),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                setState(() {
                  if (isExpanded) {
                    _expandedItems.remove(index);
                  } else {
                    _expandedItems.add(index);
                  }
                });
              });
            },
            children: [
              ...buildPanels(),
            ],
          ),
        );
}

class CharacteristicTile extends StatelessWidget {
  final DiscoveredCharacteristic characteristic;
  final String deviceId;
  final DiscoveredService service;

  const CharacteristicTile(
      {Key? key,
      required this.characteristic,
      required this.deviceId,
      required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noResponseController = TextEditingController();
    final TextEditingController _responseController = TextEditingController();
    final qCharacteristics = QualifiedCharacteristic(
        serviceId: service.serviceId,
        characteristicId: characteristic.characteristicId,
        deviceId: deviceId);
    final ValueNotifier<String> _notifiable = ValueNotifier<String>('');
    final ValueNotifier<String> _readable = ValueNotifier<String>('');
    final FlutterReactiveBle _ble = FlutterReactiveBle();
    return Container(
      child: Padding(
        padding: EdgeInsets.all(
          20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${characteristic.characteristicId}\n(${charactisticsSummary(characteristic)})',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            (characteristic.isReadable)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _readable,
                        builder: (context, value, _) {
                          return Text(_readable.value);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // final qCharacteristics = QualifiedCharacteristic(
                          //     serviceId: service.serviceId,
                          //     characteristicId: characteristic.characteristicId,
                          //     deviceId: deviceId);
                          final data = await _ble
                              .readCharacteristic(qCharacteristics);
                          print(data.length);
                          _readable.value = Utf8Decoder().convert(data);
                        },
                        child: Text('Read'),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            (characteristic.isIndicatable || characteristic.isNotifiable)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _notifiable,
                        builder: (context, value, _) {
                          return Text(_notifiable.value);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // final qCharacteristics = QualifiedCharacteristic(
                          //     serviceId: service.serviceId,
                          //     characteristicId: characteristic.characteristicId,
                          //     deviceId: deviceId);
                          _ble
                              .subscribeToCharacteristic(qCharacteristics)
                              .listen((data) {
                            _notifiable.value = Utf8Decoder().convert(data);
                          }, onError: (dynamic error) {
                            print('Error : ${error.toString()}');
                          });
                        },
                        child: Text('Subscribe'),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            (characteristic.isWritableWithoutResponse)
                ? TextFormField(
                    controller: _noResponseController,
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 10,
            ),
            (characteristic.isWritableWithoutResponse)
                ? ElevatedButton(
                    onPressed: () async {
                      // final qCharacteristics = QualifiedCharacteristic(
                      //     serviceId: service.serviceId,
                      //     characteristicId: characteristic.characteristicId,
                      //     deviceId: deviceId);
                      final Uint8List data =
                          Utf8Encoder().convert(_noResponseController.text);
                      await _ble.writeCharacteristicWithoutResponse(
                          qCharacteristics,
                          value: data);
                    },
                    child: Text(
                      'Write without response',
                    ),
                  )
                : SizedBox.shrink(),
            (characteristic.isWritableWithResponse)
                ? TextFormField(
                    controller: _responseController,
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 10,
            ),
            (characteristic.isWritableWithResponse)
                ? ElevatedButton(
                    onPressed: () async {
                      final Uint8List data =
                          Utf8Encoder().convert(_responseController.text);
                      await _ble.writeCharacteristicWithResponse(
                        qCharacteristics,
                        value: data,
                      );
                    },
                    child: Text(
                      'Write',
                    ),
                  )
                : SizedBox.shrink(),
            //Text(characteristic.)
          ],
        ),
      ),
    );
  }
}

String charactisticsSummary(DiscoveredCharacteristic c) {
  final props = <String>[];
  if (c.isReadable) {
    props.add("read");
  }
  if (c.isWritableWithoutResponse) {
    props.add("write without response");
  }
  if (c.isWritableWithResponse) {
    props.add("write with response");
  }
  if (c.isNotifiable) {
    props.add("notify");
  }
  if (c.isIndicatable) {
    props.add("indicate");
  }

  return props.join("\n");
}
