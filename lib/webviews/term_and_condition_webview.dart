import 'package:flutter/material.dart';
import 'package:forge_hrms/utils/color_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermAndConditionWebViewScreen extends StatefulWidget {
  final String termsConditionUrl;
  const TermAndConditionWebViewScreen({
    super.key,
    required this.termsConditionUrl
  });

  @override
  State<TermAndConditionWebViewScreen> createState() =>
      _TermAndConditionWebViewScreenState();
}

class _TermAndConditionWebViewScreenState
    extends State<TermAndConditionWebViewScreen> {
  late final WebViewController controller;
  bool _isLoadingPage = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (!_isDisposed) {
              setState(() {
                _isLoadingPage = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (!_isDisposed) {
              setState(() {
                _isLoadingPage = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.termsConditionUrl));
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoadingPage)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0XFF023363),
              ),
            ),
        ],
      ),
    );
  }
}