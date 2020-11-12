import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide Action;
import 'package:rubber/rubber.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:eosdart/eosdart.dart' show Action;

enum Status { Loading, Login, Connected, Sign }

class DHO extends StatefulWidget {
  @override
  _DHOState createState() => _DHOState();
}

class _DHOState extends State<DHO> with SingleTickerProviderStateMixin {
  RubberAnimationController bottomSheetController;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    bottomSheetController = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(percentage: 0.25),
        upperBoundValue: AnimationControllerValue(percentage: 0.5),
        lowerBoundValue: AnimationControllerValue(pixel: 50),
        duration: Duration(milliseconds: 400));

    super.initState();
  }

  Status status = Status.Loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          status == Status.Loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(AppColors.blue),
                  ),
                )
              : Container(),
          RubberBottomSheet(
            animationController: bottomSheetController,
            lowerLayer: DHOWebView(
              confirmTransaction: confirmTransaction,
              onTransactionMessage: () {
                setState(() {
                  status = Status.Sign;
                });
              },
              onLoginMessage: () {
                setState(() {
                  status = Status.Login;
                });
              },
              onTransactionComplete: () {
                setState(() {
                  status = Status.Connected;
                });
              },
              onLoginComplete: () {
                Future.delayed(Duration(seconds: 1)).then((_) {
                  setState(() {
                    status = Status.Connected;
                  });
                });
              },
            ),
            upperLayer: WalletView(
              status: status,
              actions: actions,
              onTransactionAccepted: transactionAccepted,
              onTransactionRejected: transactionRejected,
            ),
          ),
        ],
      ),
    );
  }

  Completer completer;

  void transactionAccepted() async {
    try {
      var response =
          await EosService.of(context, listen: false).sendTransaction(actions);

      var transactionId = response["transaction_id"];

      completer.complete(transactionId);
    } catch (err) {
      completer.completeError(err);
    }
  }

  void transactionRejected() {
    completer.completeError("Transaction rejected by user");
    // completer.completeError(err);
  }

  List<Action> actions;

  Future<String> confirmTransaction(List<Action> transactionActions) async {
    completer = Completer<String>();

    setState(() {
      status = Status.Sign;
      actions = transactionActions;
    });

    bottomSheetController.expand();

    return completer.future;
  }
}

class WalletView extends StatefulWidget {
  final Status status;
  final List<Action> actions;
  final Function onTransactionAccepted;
  final Function onTransactionRejected;

  WalletView({
    @required this.status,
    this.actions,
    this.onTransactionAccepted,
    this.onTransactionRejected,
  });

  @override
  _WalletViewState createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  String get statusText {
    switch (widget.status) {
      case Status.Loading:
        return "loading";
      case Status.Login:
        return "authorization";
      case Status.Connected:
        return "connected";
      case Status.Sign:
        return "sign transaction";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'dho.hypha.earth',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Status: $statusText',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          widget.status == Status.Sign && widget.actions.isNotEmpty
              ? TransactionSheet(
                  actions: widget.actions,
                  onTransactionAccepted: widget.onTransactionAccepted,
                  onTransactionRejected: widget.onTransactionRejected,
                )
              : Container(),
        ],
      ),
    );
  }
}

class DHOWebView extends StatefulWidget {
  Function onTransactionComplete;
  Function onLoginMessage;
  Function onLoginComplete;
  Function onTransactionMessage;
  Function confirmTransaction;

  DHOWebView({
    this.onLoginMessage,
    this.onTransactionMessage,
    this.onLoginComplete,
    this.onTransactionComplete,
    this.confirmTransaction,
  });

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

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5)).then((_) {
      widget.confirmTransaction([
        Action()
          ..name = 'transfer'
          ..account = 'eosio.token'
          ..data = {'from': 'igorberlenko'}
      ]);
    });
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
            var data = jsonDecode(message.message);

            print(data);

            if (data['messageType'] == 'login') {
              widget.onLoginMessage();

              var callbackName = data['callbackName'];

              var invokeCallback = compileCallbackJs(callbackName, accountName);
              dhoController.evaluateJavascript(invokeCallback);

              widget.onLoginComplete();
            } else if (data['messageType'] == 'sendTransaction') {
              widget.onTransactionMessage();

              var callbackName = data['callbackName'];
              var actions = jsonDecode(data['actions'])
                  .map<Action>((e) => Action.fromJson(e))
                  .toList();

              var transactionId = await widget.confirmTransaction(actions);

              var invokeCallback =
                  compileCallbackJs(callbackName, transactionId);
              dhoController.evaluateJavascript(invokeCallback);

              widget.onTransactionComplete();
            } else {
              throw new ArgumentError("messageType is not supported");
            }
          },
        )
      ]),
    );
  }
}

class TransactionSheet extends StatelessWidget {
  const TransactionSheet({
    Key key,
    @required this.onTransactionAccepted,
    @required this.onTransactionRejected,
    @required this.actions,
  }) : super(key: key);

  final Function onTransactionAccepted;
  final Function onTransactionRejected;
  final List<Action> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 8),
          ...actions.map(
            (action) {
              var data = Map<String, dynamic>.from(action.data);

              return Column(
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
                  Divider(),
                ],
              );
            },
          ),
          SizedBox(height: 8),
          MainButton(
              margin: EdgeInsets.only(top: 25),
              title: 'Accept'.i18n,
              onPressed: onTransactionAccepted),
          MainButton(
              margin: EdgeInsets.only(top: 25),
              title: 'Reject'.i18n,
              onPressed: onTransactionRejected),
        ],
      ),
    );
  }
}
