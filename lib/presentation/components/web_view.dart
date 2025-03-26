import 'package:flutter/material.dart';
import 'package:goshops/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String? url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (Uri.parse(request.url).queryParameters['status'] == 'error') {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            } else if (request.url.contains('payment-success')) {
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            } else if (request.url.contains('payment-error')) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            } else if ((request.url.contains(AppConstants.webUrl))) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url ?? ""));
    super.initState();
  }

  // We can't do controller.dispose here, because there is no function in this controller
  @override
  void dispose() {
    controller.clearCache();
    controller.clearLocalStorage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: WebViewWidget(controller: controller)));
  }
}
