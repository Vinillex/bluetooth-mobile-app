// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as _i11;
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart' as _i10;

import '../pages/home_screen.dart' as _i1;
import '../pages/phone/browser_screen.dart' as _i3;
import '../pages/phone/custom_browser.dart' as _i6;
import '../pages/phone/phone_device_detail_screen.dart' as _i5;
import '../pages/phone/phone_device_list_screen.dart' as _i4;
import '../pages/phone/website_view_screen.dart' as _i7;
import '../pages/web/web_device_services_screen.dart' as _i2;

class AppRouter extends _i8.RootStackRouter {
  AppRouter([_i9.GlobalKey<_i9.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    WebDeviceServicesRoute.name: (routeData) {
      final args = routeData.argsAs<WebDeviceServicesRouteArgs>();
      return _i8.CustomPage<dynamic>(
        routeData: routeData,
        child: _i2.WebDeviceServicesScreen(
          key: args.key,
          bluetoothDevice: args.bluetoothDevice,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    BrowserRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
        routeData: routeData,
        child: _i3.BrowserScreen(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PhoneDeviceListRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i4.PhoneDeviceListScreen(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    PhoneDeviceDetailRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneDeviceDetailRouteArgs>();
      return _i8.CustomPage<dynamic>(
        routeData: routeData,
        child: _i5.PhoneDeviceDetailScreen(
          device: args.device,
          key: args.key,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    CustomBrowserRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
        routeData: routeData,
        child: _i6.CustomBrowserScreen(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    WebsiteViewRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i7.WebsiteViewScreen(),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(
          HomeRoute.name,
          path: '/',
        ),
        _i8.RouteConfig(
          WebDeviceServicesRoute.name,
          path: '/web-device-services-screen',
        ),
        _i8.RouteConfig(
          BrowserRoute.name,
          path: '/browser-screen',
        ),
        _i8.RouteConfig(
          PhoneDeviceListRoute.name,
          path: '/phone-device-list-screen',
        ),
        _i8.RouteConfig(
          PhoneDeviceDetailRoute.name,
          path: '/phone-device-detail-screen',
        ),
        _i8.RouteConfig(
          CustomBrowserRoute.name,
          path: '/custom-browser-screen',
        ),
        _i8.RouteConfig(
          WebsiteViewRoute.name,
          path: '/website-view-screen',
        ),
        _i8.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.WebDeviceServicesScreen]
class WebDeviceServicesRoute
    extends _i8.PageRouteInfo<WebDeviceServicesRouteArgs> {
  WebDeviceServicesRoute({
    _i9.Key? key,
    required _i10.BluetoothDevice bluetoothDevice,
  }) : super(
          WebDeviceServicesRoute.name,
          path: '/web-device-services-screen',
          args: WebDeviceServicesRouteArgs(
            key: key,
            bluetoothDevice: bluetoothDevice,
          ),
        );

  static const String name = 'WebDeviceServicesRoute';
}

class WebDeviceServicesRouteArgs {
  const WebDeviceServicesRouteArgs({
    this.key,
    required this.bluetoothDevice,
  });

  final _i9.Key? key;

  final _i10.BluetoothDevice bluetoothDevice;

  @override
  String toString() {
    return 'WebDeviceServicesRouteArgs{key: $key, bluetoothDevice: $bluetoothDevice}';
  }
}

/// generated route for
/// [_i3.BrowserScreen]
class BrowserRoute extends _i8.PageRouteInfo<void> {
  const BrowserRoute()
      : super(
          BrowserRoute.name,
          path: '/browser-screen',
        );

  static const String name = 'BrowserRoute';
}

/// generated route for
/// [_i4.PhoneDeviceListScreen]
class PhoneDeviceListRoute extends _i8.PageRouteInfo<void> {
  const PhoneDeviceListRoute()
      : super(
          PhoneDeviceListRoute.name,
          path: '/phone-device-list-screen',
        );

  static const String name = 'PhoneDeviceListRoute';
}

/// generated route for
/// [_i5.PhoneDeviceDetailScreen]
class PhoneDeviceDetailRoute
    extends _i8.PageRouteInfo<PhoneDeviceDetailRouteArgs> {
  PhoneDeviceDetailRoute({
    required _i11.DiscoveredDevice device,
    _i9.Key? key,
  }) : super(
          PhoneDeviceDetailRoute.name,
          path: '/phone-device-detail-screen',
          args: PhoneDeviceDetailRouteArgs(
            device: device,
            key: key,
          ),
        );

  static const String name = 'PhoneDeviceDetailRoute';
}

class PhoneDeviceDetailRouteArgs {
  const PhoneDeviceDetailRouteArgs({
    required this.device,
    this.key,
  });

  final _i11.DiscoveredDevice device;

  final _i9.Key? key;

  @override
  String toString() {
    return 'PhoneDeviceDetailRouteArgs{device: $device, key: $key}';
  }
}

/// generated route for
/// [_i6.CustomBrowserScreen]
class CustomBrowserRoute extends _i8.PageRouteInfo<void> {
  const CustomBrowserRoute()
      : super(
          CustomBrowserRoute.name,
          path: '/custom-browser-screen',
        );

  static const String name = 'CustomBrowserRoute';
}

/// generated route for
/// [_i7.WebsiteViewScreen]
class WebsiteViewRoute extends _i8.PageRouteInfo<void> {
  const WebsiteViewRoute()
      : super(
          WebsiteViewRoute.name,
          path: '/website-view-screen',
        );

  static const String name = 'WebsiteViewRoute';
}
