import 'package:flutter/material.dart';
import 'package:forge_hrms/controller/home_controller.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:forge_hrms/utils/const_utils.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class HomeWebViewScreen extends StatefulWidget {
  const HomeWebViewScreen({super.key});

  @override
  State<HomeWebViewScreen> createState() => _HomeWebViewScreenState();
}

class _HomeWebViewScreenState extends State<HomeWebViewScreen> {
  final WebViewController controller = WebViewController();
  final homeController = Get.find<HomeController>();

  String getCurrentUrl() {
    homeController.currentWebUrl.value = homeController.isSwitchOn.value
        ? 'https://forgealumnus.com/WE-enable/login'
        : 'https://forgealumnus.com/forge/login';
    return homeController.isSwitchOn.value
        ? 'https://forgealumnus.com/WE-enable/login'
        : 'https://forgealumnus.com/forge/login';
  }

  @override
  void dispose() {
    controller.clearCache();
    homeController.isLoginPage.value = true;
    super.dispose();
  }

  void initWebView() {
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) {
          // Start loading
          homeController.isLoadingPage.value = true;
        },
        onPageFinished: (url) {
          homeController.isLoadingPage.value = false;

          if (url != null) {
            homeController.currentWebUrl.value = url;

            // ✅ Check if we are still on login URL
            bool isLoginUrl =
                url == 'https://forgealumnus.com/WE-enable/login' ||
                    url == 'https://forgealumnus.com/forge/login';
            print('🧭 WebView landed on: $url');
            print('🔐 isLoginPage = $isLoginUrl');

            homeController.isLoginPage.value = isLoginUrl;
          }
        },
        onNavigationRequest: (request) {
          // Optional: Update early before page load finishes
          final url = request.url;
          if (url != null) {
            bool isLoginUrl =
                url == 'https://forgealumnus.com/WE-enable/login' ||
                    url == 'https://forgealumnus.com/forge/login';

            homeController.isLoginPage.value = isLoginUrl;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    controller.loadRequest(Uri.parse(getCurrentUrl()));
  }

  @override
  void initState() {
    super.initState();
    homeController.loadSwitchState();

    // Ensure post-frame to avoid setState errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.isLoginPage.value = true;
      print("--Init---${homeController.isLoginPage.value}");
      initWebView();

      // Reactive switch listener — safe now
      ever(homeController.isSwitchOn, (val) {
        homeController.isLoadingPage.value = true;

        controller.loadRequest(Uri.parse(getCurrentUrl()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Obx(() {
        return Stack(
          children: [
            WebViewWidget(controller: controller),
            if (homeController.isLoadingPage.value)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
          ],
        );
      }),
    );
  }
}

// class HomeWebViewScreen extends StatefulWidget {
//   const HomeWebViewScreen({super.key});
//
//   @override
//   State<HomeWebViewScreen> createState() => _HomeWebViewScreenState();
// }
//
// class _HomeWebViewScreenState extends State<HomeWebViewScreen> {
//   WebViewController controller = WebViewController();
//   final homeController = Get.put<HomeController>(HomeController());
//   bool _isLoadingPage = true;
//
//   // String buildUrlWithQueryParams() {
//   //   final Uri url = Uri(
//   //       scheme: 'https',
//   //       host: 'hrms.forgealumnus.com',
//   //       path: '/employee/attendance',
//   //       queryParameters: {
//   //         'lat': '${ConstUtils.lat}',
//   //         'lng': '${ConstUtils.long}',
//   //       });
//   //   return url.toString();
//   // }
//   String buildUrlWithQueryParams() {
//     final Uri url = Uri(
//       scheme: 'https',
//       host: 'forgealumnus.com',
//       path: 'WE-enable/mentor/login',
//     );
//     return url.toString();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // url =
//     //     'https://hrms.forgealumnus.com/employee/attendance?lat=${ConstUtils.lat}&lng=${ConstUtils.long}';
//
//     init();
//   }
//
//   void init() {
//     controller.setJavaScriptMode(JavaScriptMode.unrestricted);
//     controller.setNavigationDelegate(
//       NavigationDelegate(
//         onUrlChange: (change) async {
//           if (change.url?.contains(
//                   "https://hrms.forgealumnus.com/employee/attendance") ==
//               true) {
//             final uri = Uri.parse(change.url!);
//             if (!uri.queryParameters.containsKey("lat") ||
//                 !uri.queryParameters.containsKey("lng")) {
//               await controller
//                   .loadRequest(Uri.parse(buildUrlWithQueryParams().toString()));
//             }
//           }
//         },
//         onPageFinished: (String url) {
//           setState(() {
//             _isLoadingPage = false;
//           });
//         },
//       ),
//     );
//     controller.loadRequest(Uri.parse(buildUrlWithQueryParams().toString()));
//
//     // final platformController = controller.platform;
//     // if (platformController is AndroidWebViewController) {
//     //   platformController.setGeolocationPermissionsPromptCallbacks(
//     //     onShowPrompt: (request) async {
//     //       // request location permission
//     //       final locationPermissionStatus =
//     //           await Permission.locationWhenInUse.request();
//     //
//     //       // return the response
//     //       return GeolocationPermissionsResponse(
//     //         allow: locationPermissionStatus == PermissionStatus.granted,
//     //         retain: false,
//     //       );
//     //     },
//     //   );
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.white,
//       child: Stack(
//         children: [
//           WebViewWidget(controller: controller),
//           // if (_isLoadingPage)
//           //    Center(
//           //     child: CircularProgressIndicator(
//           //       color: AppColors.primary
//           //     ),
//           //   ),
//         ],
//       ),
//     );
//   }
// }
