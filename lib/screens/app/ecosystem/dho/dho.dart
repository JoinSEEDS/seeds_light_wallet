import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide Action;
import 'package:rubber/rubber.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/seeds_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:eosdart/eosdart.dart' show Action;

class DHO extends StatelessWidget {
  Widget build(_) {
    return WebWallet(Config.dhoExplorer);
  }
}

enum Status { Loading, Login, Connected, Sign }

class WebWallet extends StatefulWidget {
  final String url;

  WebWallet({ this.url });

  @override
  _WebWalletState createState() => _WebWalletState();
}

class _WebWalletState extends State<WebWallet> with SingleTickerProviderStateMixin {
  RubberAnimationController bottomSheetController;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    bottomSheetController = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(percentage: 0.25),
        upperBoundValue: AnimationControllerValue(percentage: 0.5),
        lowerBoundValue: AnimationControllerValue(pixel: 53),
        duration: Duration(milliseconds: 400));

    super.initState();
  }

  Status status = Status.Loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        child: Stack(
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
              lowerLayer: WalletWebView(
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
                initialUrl: widget.url,
              ),
              upperLayer: WalletSheetView(
                status: status,
                actions: actions,
                onTransactionAccepted: transactionAccepted,
                onTransactionRejected: transactionRejected,
                title: widget.url.replaceAll("https://", ""),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Completer completer;

  void transactionAccepted() async {
    try {
      bottomSheetController.collapse();

      var response = await EosService.of(context, listen: false).sendTransaction(actions);

      var transactionId = response["transaction_id"];

      completer.complete(transactionId);
    } catch (err) {
      completer.completeError(err);
    }
  }

  void transactionRejected() {
    bottomSheetController.collapse();
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

class WalletSheetView extends StatefulWidget {
  final Status status;
  final List<Action> actions;
  final Function onTransactionAccepted;
  final Function onTransactionRejected;
  final String title;

  WalletSheetView({
    @required this.status,
    this.actions,
    this.onTransactionAccepted,
    this.onTransactionRejected,
    this.title,
  });

  @override
  _WalletSheetViewState createState() => _WalletSheetViewState();
}

class _WalletSheetViewState extends State<WalletSheetView> {
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
                onPressed: () {urlName
                  Navigator.of(context).pop();
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
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

class WalletWebView extends StatefulWidget {
  final Function onTransactionComplete;
  final Function onLoginMessage;
  final Function onLoginComplete;
  final Function onTransactionMessage;
  final Function confirmTransaction;
  final String initialUrl;

  WalletWebView({
    this.onLoginMessage,
    this.onTransactionMessage,
    this.onLoginComplete,
    this.onTransactionComplete,
    this.confirmTransaction,
    this.initialUrl
  });

  @override
  _WalletWebViewState createState() => _WalletWebViewState();
}

class _WalletWebViewState extends State<WalletWebView> {
  WebViewController dhoController;

  String get accountName => SettingsNotifier.of(context, listen: false).accountName;

  String compileCallbackJs(String callbackName, String response) => "window.LightWallet['$callbackName']('$response')";

  @override
  Widget build(BuildContext context) {
    return buildWebView();
  }

  @override
  void initState() {
    super.initState();

    // Future.delayed(Duration(seconds: 5)).then((_) {
    //   widget.confirmTransaction([
    //     Action()
    //       ..name = 'transfer'
    //       ..account = 'eosio.token'
    //       ..data = {
    //         'from': 'sevenflash42',
    //         'to': 'igorberlenko',
    //         'quantity': '10.0000 SEEDS',
    //         'memo': '',
    //       }
    //   ]);
    // });
  }

  WebView buildWebView() {
    return WebView(
      initialUrl: widget.initialUrl,
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
              var actions = jsonDecode(data['actions']).map<Action>((e) => Action.fromJson(e)).toList();

              var transactionId = await widget.confirmTransaction(actions);

              var invokeCallback = compileCallbackJs(callbackName, transactionId);
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

class TransactionSheet extends StatefulWidget {
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
  _TransactionSheetState createState() => _TransactionSheetState();
}

class _TransactionSheetState extends State<TransactionSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView(
            shrinkWrap: true,
            children: widget.actions.map(
              (action) {
                var data = Map<String, dynamic>.from(action.data);

                return Theme(
                  data: ThemeData(
                    accentColor: Colors.white,
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    title: Text(
                      "${action.account} -> ${action.name}",
                      style: TextStyle(
                        fontFamily: "heebo",
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    children: [
                      ...data.entries
                          .map(
                            (e) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  e.key,
                                  style: TextStyle(
                                    fontFamily: "heebo",
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  e.value.toString(),
                                  style: TextStyle(
                                    fontFamily: "heebo",
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      Divider(),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SeedsButton('Accept', onPressed: widget.onTransactionAccepted, color: AppColors.green),
              SeedsButton('Reject', onPressed: widget.onTransactionRejected, color: AppColors.red),
            ],
          ),
        ],
      ),
    );
  }
}
