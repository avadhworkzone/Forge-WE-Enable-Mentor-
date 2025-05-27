import 'package:flutter/material.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class TermAndConditionWebViewScreen extends StatefulWidget {
  const TermAndConditionWebViewScreen({super.key});

  @override
  State<TermAndConditionWebViewScreen> createState() =>
      _TermAndConditionWebViewScreenState();
}

class _TermAndConditionWebViewScreenState
    extends State<TermAndConditionWebViewScreen> {
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
      ..loadRequest(Uri.parse("https://forgealumnus.com/terms"));
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
