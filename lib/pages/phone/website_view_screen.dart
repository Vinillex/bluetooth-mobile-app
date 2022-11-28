import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_view_ble/web_view_ble.dart';

class WebsiteViewScreen extends StatefulWidget {
  const WebsiteViewScreen({Key? key}) : super(key: key);

  @override
  State<WebsiteViewScreen> createState() => _WebsiteViewState();
}

class _WebsiteViewState extends State<WebsiteViewScreen> {
  var url = 'https://googlechrome.github.io/samples/web-bluetooth/index.html';

  // var url = 'https://jeroen1602.github.io/flutter_web_bluetooth/#/';

  final urlController = TextEditingController();
  InAppWebViewController? webViewController;
  bool canGoBack = false;

  @override
  void initState() {
    askBlePermission();
    super.initState();
  }

  askBlePermission() async {
    var blePermission = await Permission.bluetooth.status;
    if (blePermission.isDenied) {
      Permission.bluetooth.request();
    }
    // Android Vr > 12 required These Ble Permission
    if (Platform.isAndroid) {
      var bleConnectPermission = await Permission.bluetoothConnect.status;
      var bleScanPermission = await Permission.bluetoothScan.status;
      if (bleConnectPermission.isDenied) {
        Permission.bluetoothConnect.request();
      }
      if (bleScanPermission.isDenied) {
        Permission.bluetoothScan.request();
      }
    }
  }

  onLoadStop(controller, context) async {
    url = url.toString();
    urlController.text = this.url;
    WebViewBle.init(controller: controller, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flowser"),
        centerTitle: true,
        leading: canGoBack
            ? IconButton(
            onPressed: () {
              webViewController?.goBack();
            },
            icon: Icon(Icons.arrow_back_ios))
            : const SizedBox(),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
              controller: urlController,
              keyboardType: TextInputType.url,
              onSubmitted: (value) {
                var url = Uri.parse(value);
                if (url.scheme.isEmpty) {
                  url = Uri.parse("https://www.google.com/search?q=" + value);
                }
                webViewController?.loadUrl(urlRequest: URLRequest(url: url));
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(url)),
                    onLoadStop: (cntrl, url) async {
                      onLoadStop(cntrl, context);
                      webViewController = cntrl;
                      bool _canGoBack = await cntrl.canGoBack();
                      setState(() {
                        canGoBack = _canGoBack;
                      });
                    },
                    onWebViewCreated: (controller) {
                      controller.addJavaScriptHandler(
                          handlerName: "onButtonClick",
                          callback: (args) async {
                            //final level = await battery.batteryLevel;
                            print("From the JavaScript side:");
                            // print(level);
                            // return level;
                          });
                      // async function onButtonClick() {
                      //   try {
                      //     log('Requesting Bluetooth Device...');
                      //     const device = await navigator.bluetooth.requestDevice({
                      //       filters: [{services: ['battery_service']}]});
                      //
                      //     log('Connecting to GATT Server...');
                      //     const server = await device.gatt.connect();
                      //
                      //     log('Getting Battery Service...');
                      //     const service = await server.getPrimaryService('battery_service');
                      //
                      //     log('Getting Battery Level Characteristic...');
                      //     const characteristic = await service.getCharacteristic('battery_level');
                      //
                      //     log('Reading Battery Level...');
                      //     const value = await characteristic.readValue();
                      //
                      //     log('> Battery Level is ' + value.getUint8(0) + '%');
                      //   } catch(error) {
                      //     log('Argh! ' + error);
                      //   }
                      // }
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      logSuccess(
                          "ConsoleMessage : ${consoleMessage.messageLevel.toString()} :  ${consoleMessage.message} ");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
