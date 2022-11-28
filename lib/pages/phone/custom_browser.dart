import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CustomBrowserScreen extends StatefulWidget {
  @override
  _CustomBrowserScreenState createState() => new _CustomBrowserScreenState();
}

class _CustomBrowserScreenState extends State<CustomBrowserScreen> {

  final GlobalKey webViewKey = GlobalKey();

  final Battery battery = Battery();

  // InAppWebViewSettings settings = InAppWebViewSettings(
  //   // Setting this off for security. Off by default for SDK versions >= 16.
  //     allowFileAccessFromFileURLs: false,
  //     // Off by default, deprecated for SDK versions >= 30.
  //     allowUniversalAccessFromFileURLs: false,
  //
  //     // Keeping these off is less critical but still a good idea, especially if your app is not
  //     // using file:// or content:// URLs.
  //     allowFileAccess: false,
  //     allowContentAccess: false,
  //
  //     // Basic WebViewAssetLoader with custom domain
  //     webViewAssetLoader: WebViewAssetLoader(
  //         domain: "my.custom.domain.com",
  //         pathHandlers: [
  //           AssetsPathHandler(path: '/assets/')
  //         ]
  //     ),
  //
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WebView Asset Loader'),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest:
                URLRequest(url: Uri.parse("https://my.custom.domain.com/assets/flutter_assets/assets/index.html")),
                //initialFile: "https://my.custom.domain.com/assets/flutter_assets/assets/index.html",
                // initialSettings: settings,
                onWebViewCreated: (InAppWebViewController controller) {
                  controller.addJavaScriptHandler(handlerName: "batteryLevel", callback: (args) async {
                    final level = await battery.batteryLevel;
                    print("From the JavaScript side:");
                    print(level);
                    return level;
                  });
                },
              )),
        ]));
  }
}
