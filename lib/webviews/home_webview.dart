import 'package:flutter/material.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:forge_hrms/utils/const_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class HomeWebViewScreen extends StatefulWidget {
  const HomeWebViewScreen({super.key});

  @override
  State<HomeWebViewScreen> createState() => _HomeWebViewScreenState();
}

class _HomeWebViewScreenState extends State<HomeWebViewScreen> {
  WebViewController controller = WebViewController();
  bool _isLoadingPage = true;

  // String buildUrlWithQueryParams() {
  //   final Uri url = Uri(
  //       scheme: 'https',
  //       host: 'hrms.forgealumnus.com',
  //       path: '/employee/attendance',
  //       queryParameters: {
  //         'lat': '${ConstUtils.lat}',
  //         'lng': '${ConstUtils.long}',
  //       });
  //   return url.toString();
  // }
  String buildUrlWithQueryParams() {
    final Uri url = Uri(
      scheme: 'https',
      host: 'forgealumnus.com',
      path: 'WE-enable/mentor/login',
    );
    return url.toString();
  }

  @override
  void initState() {
    super.initState();
    // url =
    //     'https://hrms.forgealumnus.com/employee/attendance?lat=${ConstUtils.lat}&lng=${ConstUtils.long}';

    init();
  }

  void init() {
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(
      NavigationDelegate(
        onUrlChange: (change) async {
          if (change.url?.contains(
                  "https://hrms.forgealumnus.com/employee/attendance") ==
              true) {
            final uri = Uri.parse(change.url!);
            if (!uri.queryParameters.containsKey("lat") ||
                !uri.queryParameters.containsKey("lng")) {
              await controller
                  .loadRequest(Uri.parse(buildUrlWithQueryParams().toString()));
            }
          }
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoadingPage = false;
          });
        },
      ),
    );
    controller.loadRequest(Uri.parse(buildUrlWithQueryParams().toString()));

    // final platformController = controller.platform;
    // if (platformController is AndroidWebViewController) {
    //   platformController.setGeolocationPermissionsPromptCallbacks(
    //     onShowPrompt: (request) async {
    //       // request location permission
    //       final locationPermissionStatus =
    //           await Permission.locationWhenInUse.request();
    //
    //       // return the response
    //       return GeolocationPermissionsResponse(
    //         allow: locationPermissionStatus == PermissionStatus.granted,
    //         retain: false,
    //       );
    //     },
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          // if (_isLoadingPage)
          //    Center(
          //     child: CircularProgressIndicator(
          //       color: AppColors.primary
          //     ),
          //   ),
        ],
      ),
    );
  }
}
