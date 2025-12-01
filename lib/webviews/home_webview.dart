import 'package:flutter/material.dart';
import 'package:forge_hrms/controller/home_controller.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:forge_hrms/utils/const_utils.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:file_picker/file_picker.dart';

class HomeWebViewScreen extends StatefulWidget {
  final String url;
  final String weEnable;
  const HomeWebViewScreen({super.key, required this.url, required this.weEnable});

  @override
  State<HomeWebViewScreen> createState() => _HomeWebViewScreenState();
}

class _HomeWebViewScreenState extends State<HomeWebViewScreen> {
  final WebViewController controller = WebViewController();
  final homeController = Get.find<HomeController>();
  bool _isDisposed = false; // Add this flag

  String getCurrentUrl() {
    homeController.currentWebUrl.value = homeController.isSwitchOn.value
        ? widget.weEnable
        : widget.url;
    return homeController.isSwitchOn.value
        ? widget.weEnable
        : widget.url;
  }

  @override
  void dispose() {
    _isDisposed = true; // Set flag first

    // Clear cache but don't update any controllers
    controller.clearCache().then((_) {
      // Only update controller if not disposed
      if (!_isDisposed) {
        homeController.isLoginPage.value = true;
      }
    });

    super.dispose();
  }

  // URL ચેક કરવા માટે નવી મેથડ
  bool _isLoginUrl(String url) {
    return url == widget.weEnable || url == widget.url;
  }

  // લૉગિન ડિટેક્ટ કરવા માટે નવી મેથડ
  bool _isDashboardUrl(String url) {
    // તમારા ઍપ્લિકેશનના ડૅશબોર્ડ URL અહીં ઍડ કરો
    List<String> dashboardUrls = [
      'https://forgealumnus.com/forge/dashboard',
      'https://forgealumnus.com/WE-enable/dashboard',
      '/dashboard',
      '/home',
      '/profile'
    ];

    return dashboardUrls.any((dashboardUrl) =>
    url.contains(dashboardUrl) || url.endsWith(dashboardUrl));
  }

  void initWebView() {
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(Colors.white);
    controller.enableZoom(false);

    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) {
          if (!_isDisposed) {
            homeController.isLoadingPage.value = true;
          }
        },
        onPageFinished: (url) {
          if (!_isDisposed) {
            homeController.isLoadingPage.value = false;

            if (url != null) {
              homeController.currentWebUrl.value = url;

              // ✅ લૉગિન URL ચેક કરો
              bool isLoginUrl = _isLoginUrl(url);
              print('🧭 WebView landed on: $url');
              print('🔐 isLoginPage = $isLoginUrl');

              homeController.isLoginPage.value = isLoginUrl;

              // ✅ લૉગિન સ્ટેટ ચેક કરો
              if (_isDashboardUrl(url)) {
                // જો ડૅશબોર્ડ પર છે તો લૉગિન થઈ ગયો છે
                homeController.setUserLoggedIn(true);
                print('✅ User is logged in - Dashboard detected');
              } else if (isLoginUrl) {
                // જો લૉગિન પેજ પર છે તો લૉગઆઉટ થયો છે
                homeController.setUserLoggedIn(false);
                print('❌ User is logged out - Login page detected');
              }
            }
          }
        },
        onNavigationRequest: (request) {
          if (!_isDisposed) {
            final url = request.url;
            if (url != null) {
              bool isLoginUrl = _isLoginUrl(url);
              homeController.isLoginPage.value = isLoginUrl;
            }
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    _setupFilePickerForAndroid();
    _setupFilePickerForIOS();
    controller.loadRequest(Uri.parse(getCurrentUrl()));
  }

  // બાકીનો file picker કોડ સમાન રહેશે...
  void _setupFilePickerForAndroid() {
    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
      AndroidWebViewController.enableDebugging(true);

      androidController.setOnShowFileSelector((params) async {
        print("📁 Android file picker opened");
        try {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: params.acceptTypes.isEmpty ? false : params.isCaptureEnabled,
            type: _getFileType(params.acceptTypes),
          );

          if (result == null || result.files.isEmpty) return [];
          final file = result.files.single.path;
          if (file == null) return [];
          return [Uri.file(file).toString()];
        } catch (e) {
          print("❌ Android file picker error: $e");
          return [];
        }
      });
    }
  }

  void _setupFilePickerForIOS() {
    if (controller.platform is WebKitWebViewController) {
      print("🍎 iOS WebView - file picker will work natively");
    }
  }

  FileType _getFileType(List<String> acceptTypes) {
    if (acceptTypes.isEmpty) {
      return FileType.any;
    }
    final acceptType = acceptTypes.first.toLowerCase();
    if (acceptType.contains('image')) {
      return FileType.image;
    } else if (acceptType.contains('video')) {
      return FileType.video;
    } else if (acceptType.contains('audio')) {
      return FileType.audio;
    } else if (acceptType.contains('pdf')) {
      return FileType.custom;
    } else {
      return FileType.any;
    }
  }

  @override
  void initState() {
    super.initState();
    homeController.loadSwitchState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        homeController.isLoginPage.value = true;
        homeController.setUserLoggedIn(false); // શરૂઆતમાં લૉગઆઉટ સ્ટેટ
        print("--Init---${homeController.isLoginPage.value}");
        initWebView();

        ever(homeController.isSwitchOn, (val) {
          if (!_isDisposed) {
            homeController.isLoadingPage.value = true;
            controller.loadRequest(Uri.parse(getCurrentUrl()));
          }
        });
      }
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
            if (homeController.isLoadingPage.value && !_isDisposed)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
          ],
        );
      }),
    );
  }
}