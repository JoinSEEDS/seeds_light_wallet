import 'dart:io';
import 'package:flutter/material.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/local/util/seeds_esr.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/utils/result_extension.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final msg = 'Success';
          await _webViewController.runJavascript('lightWalletResponseCallback($msg)');
          await _webViewController.runJavascript('window.lightWalletResponseCallback($msg)');
        },
        child: const Text(
          'Send String to JS',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://ptm-dev.hypha.earth/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) => _webViewController = webViewController,
          onPageStarted: (url) => print('Page started loading: $url'),
          onProgress: (progress) => print('WebView is loading (progress : $progress%)'),
          onWebResourceError: (error) => print(error),
          javascriptChannels: {
            JavascriptChannel(
              name: "lw",
              onMessageReceived: (javascriptMessage) async {
                final esr = SeedsESR(uri: javascriptMessage.message);
                final result = await esr
                    .resolve(account: settingsStorage.accountName)
                    .then((value) => esr.processResolvedRequest())
                    .catchError((_) {
                  print(" processQrCode : Error processing QR code");
                  return ErrorResult("Error processing QR code");
                });
                final scanQrCodeResult = result.asValue!.value as ScanQrCodeResultData;
                // ignore: unawaited_futures, use_build_context_synchronously
                final wasSuccess = await NavigationService.of(context).navigateTo(
                    Routes.sendConfirmation, SendConfirmationArguments(transaction: scanQrCodeResult.transaction));
                // if (wasSuccess != null) {
                //   final msg = 'Success';
                //   await _webViewController.runJavascript('lightWalletResponseCallback($msg)');
                // }

                // Decode message
                // final data = jsonDecode(javascriptMessage.message);
                /* 
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
                } */
              },
            )
          },
        ),
      ),
    );
  }
}
