import 'package:flutter/material.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class AboutUsWebViewScreen extends StatefulWidget {
  const AboutUsWebViewScreen({super.key});

  @override
  State<AboutUsWebViewScreen> createState() => _AboutUsWebViewScreenState();
}

class _AboutUsWebViewScreenState extends State<AboutUsWebViewScreen> {
  late final WebViewController controller;
  bool _isLoadingPage = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoadingPage = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse("https://forgealumnus.com/about-us"));
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
          //   const Center(
          //     child: CircularProgressIndicator(
          //       color: Color(0XFF023363),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
