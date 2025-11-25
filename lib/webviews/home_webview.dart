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

  String getCurrentUrl() {
    homeController.currentWebUrl.value = homeController.isSwitchOn.value
        ? widget.weEnable
        : widget.url;
    return homeController.isSwitchOn.value
        ? widget.weEnable
        : widget.url;
  }

  // String getCurrentUrl() {
  //   homeController.currentWebUrl.value = homeController.isSwitchOn.value
  //       ? 'https://forgealumnus.com/WE-enable/login'
  //       : 'https://forgealumnus.com/forge/login';
  //   return homeController.isSwitchOn.value
  //       ? 'https://forgealumnus.com/WE-enable/login'
  //       : 'https://forgealumnus.com/forge/login';
  // }

  @override
  void dispose() {
    controller.clearCache();
    homeController.isLoginPage.value = true;
    super.dispose();
  }

  // Initialize WebView with file picker support
  void initWebView() {
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(Colors.white);
    controller.enableZoom(false);

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
                url == widget.weEnable ||
                    url == widget.url;
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
                url == widget.weEnable ||
                    url == widget.url;

            homeController.isLoginPage.value = isLoginUrl;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    // Setup file picker for Android
    _setupFilePickerForAndroid();

    // Setup file picker for iOS
    _setupFilePickerForIOS();

    controller.loadRequest(Uri.parse(getCurrentUrl()));
  }

  // Setup file picker for Android
  void _setupFilePickerForAndroid() {
    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;

      // Enable debugging (optional)
      AndroidWebViewController.enableDebugging(true);

      // Setup file selector
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

  // Setup file picker for iOS
  void _setupFilePickerForIOS() {
    if (controller.platform is WebKitWebViewController) {
      print("🍎 iOS WebView - file picker will work natively");
      // iOS handles file inputs automatically through WKWebView
      // No additional setup needed
    }
  }

  // Determine file type based on accept types
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

  // Inject JavaScript to enhance file input visibility
  void _injectFileInputEnhancementScript() {
    final script = """
      console.log("Enhancing file inputs");
      const inputs = document.querySelectorAll('input[type="file"]');
      inputs.forEach(input => {
        input.style.opacity = "1";
        input.style.position = "relative";
        input.style.zIndex = "9999";
      });
    """;

    controller.runJavaScript(script);
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