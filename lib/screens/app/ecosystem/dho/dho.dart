import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide Action;
import 'package:seeds/constants/config.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:eosdart/eosdart.dart' show Action;

class DHO extends StatefulWidget {
  @override
  _DHOState createState() => _DHOState();
}

class _DHOState extends State<DHO> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          "Explore DHO",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[],
        backgroundColor: Colors.pink,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          DHOWebView(),
        ],
      ),
    );
  }
}

class DHOWebView extends StatefulWidget {
  @override
  _DHOWebViewState createState() => _DHOWebViewState();
}

class _DHOWebViewState extends State<DHOWebView> {
  WebViewController dhoController;

  String get accountName =>
      SettingsNotifier.of(context, listen: false).accountName;

  String compileCallbackJs(String callbackName, String response) =>
      "window.LightWallet['$callbackName']('$response')";

  @override
  Widget build(BuildContext context) {
    return buildWebView();
  }

  WebView buildWebView() {
    return WebView(
      initialUrl: Config.dhoExplorer,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController controller) {
        dhoController = controller;
      },
      javascriptChannels: Set.from([
        JavascriptChannel(
          name: "LightWalletChannel",
          onMessageReceived: (JavascriptMessage message) async {
            try {
              var data = jsonDecode(message.message);

              print(data);

              if (data['messageType'] == 'login') {
                var callbackName = data['callbackName'];

                var invokeCallback =
                    compileCallbackJs(callbackName, accountName);
                dhoController.evaluateJavascript(invokeCallback);
              } else if (data['messageType'] == 'sendTransaction') {
                var callbackName = data['callbackName'];
                var actions = data['actions'];

                var transactionId = await confirmTransaction(actions);

                var invokeCallback =
                    compileCallbackJs(callbackName, transactionId);
                dhoController.evaluateJavascript(invokeCallback);
              } else {
                throw new ArgumentError("messageType is not supported");
              }
            } catch (e) {
              print('Cannot process message: ' + e);
            }
          },
        )
      ]),
    );
  }

  Future<String> confirmTransaction(Action action) async {
    var completer = Completer();

    var data = Map<String, dynamic>.from(action.data);

    Scaffold.of(context).showBottomSheet(
      (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            Column(
              children: <Widget>[
                ...data.entries
                    .map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            e.key,
                            style: TextStyle(
                              fontFamily: "heebo",
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            e.value.toString(),
                            style: TextStyle(
                              fontFamily: "heebo",
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
            SizedBox(height: 8),
            MainButton(
              margin: EdgeInsets.only(top: 25),
              title: 'Confirm Transaction'.i18n,
              onPressed: () async {
                try {
                  var response = await EosService.of(context, listen: false)
                      .sendTransaction(
                    account: action.account,
                    name: action.name,
                    data: data,
                  );

                  var transactionId = response["transaction_id"];

                  completer.complete(transactionId);
                } catch (e) {
                  completer.completeError(e);
                }
              },
            ),
          ],
        ),
      ),
    );

    return completer.future;
  }
}
