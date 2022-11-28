import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:bluetooth_app/pages/phone/custom_browser.dart';
import 'package:bluetooth_app/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BrowserScreen extends StatefulWidget {
  @override
  _BrowserScreenState createState() => new _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  // late PullToRefreshController pullToRefreshController;
  // final browser = InAppBrowser();
  final Battery battery = Battery();

  @override
  void initState() {
    super.initState();

    // pullToRefreshController = PullToRefreshController(
    //   options: PullToRefreshOptions(
    //     color: Colors.black,
    //   ),
    //   onRefresh: () async {
    //     if (Platform.isAndroid) {
    //       browser.webViewController.reload();
    //     } else if (Platform.isIOS) {
    //       browser.webViewController.loadUrl(
    //           urlRequest:
    //               URLRequest(url: await browser.webViewController.getUrl()));
    //     }
    //   },
    // );
    // browser.pullToRefreshController = pullToRefreshController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "InAppBrowser",
        )),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    context.router.push(CustomBrowserRoute());
                  },
                  child: Text("Open In-App Browser")),
            ])));
  }
}
