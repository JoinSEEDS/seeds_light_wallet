import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebView extends StatefulWidget {
  const InAppWebView({Key? key}) : super(key: key);

  @override
  _InAppWebViewState createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://ptm-dev.hypha.earth/',
        gestureNavigationEnabled: true,
        backgroundColor: AppColors.white,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) => _webViewController = webViewController,
        onProgress: (progress) => print('WebView is loading (progress : $progress%)'),
        onWebResourceError: (error) {
          print(error);
        },
        javascriptChannels: {
          JavascriptChannel(
            name: "LightWalletChannel",
            onMessageReceived: (JavascriptMessage message) async {
              // Decode message
              final data = jsonDecode(message.message);

              if (data['messageType'] == 'login') {
                final callbackName = data['callbackName'];
                // Inject JS code (notify web)
                await _webViewController
                    .runJavascript("window.LightWallet['$callbackName']('${settingsStorage.accountName}')");
              } else if (data['messageType'] == 'sendTransaction') {
                final callbackName = data['callbackName'];
                // Decode actions
                final actions = jsonDecode(data['actions']);
                // Verify transaction to back-end
                final transactionId = await confirmTransaction(actions);
                // Inject JS code (notify web)
                await _webViewController.runJavascript("window.LightWallet['$callbackName'('$transactionId')");
              } else {
                throw ArgumentError("messageType is not supported");
              }
            },
          )
        },
        onPageStarted: (url) {
          print('Page started loading: $url');
        },
      ),
    );
  }
}
