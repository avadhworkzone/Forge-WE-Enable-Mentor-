import 'package:flutter/material.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class PrivacyPolicyWebViewScreen extends StatefulWidget {
  final String privacyUrl;
  const PrivacyPolicyWebViewScreen({super.key, required this.privacyUrl});

  @override
  State<PrivacyPolicyWebViewScreen> createState() =>
      _PrivacyPolicyWebViewScreenState();
}

class _PrivacyPolicyWebViewScreenState
    extends State<PrivacyPolicyWebViewScreen> {
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
      ..loadRequest(Uri.parse(widget.privacyUrl));
      // ..loadRequest(Uri.parse("https://forgealumnus.com/privacy/policy"));
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
