import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_app/pages/phone/custom_browser.dart';
import 'package:bluetooth_app/pages/web/web_device_services_screen.dart';

import '../pages/phone/browser_screen.dart';
import '../pages/home_screen.dart';
import '../pages/phone/phone_device_detail_screen.dart';
import '../pages/phone/phone_device_list_screen.dart';
import '../pages/phone/website_view_screen.dart';

// @CupertinoAutoRouter
// @AdaptiveAutoRouter
// @CustomAutoRouter
@CustomAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    CustomRoute(
      initial: true,
      page: HomeScreen,
    ),
    CustomRoute(
      page: WebDeviceServicesScreen,
    ),
    CustomRoute(
      page: BrowserScreen,
    ),
    CustomRoute(
      page: PhoneDeviceListScreen,
    ),
    CustomRoute(
      page: PhoneDeviceDetailScreen,
    ),
    CustomRoute(
      page: CustomBrowserScreen,
    ),
    CustomRoute(
      page: WebsiteViewScreen,
    ),
    RedirectRoute(path: '*', redirectTo: ''),
  ],
)
class $AppRouter {}
