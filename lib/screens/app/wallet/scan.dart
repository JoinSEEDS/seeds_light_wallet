import 'package:flutter/material.dart' hide Action;
import 'package:eosdart/eosdart.dart' show Action;
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';

import 'package:dart_esr/dart_esr.dart' hide Action;

import 'package:qr_mobile_vision/qr_camera.dart';

enum Steps { initial, processing, success, error }

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Scan> {
  String qrcode;
  Steps step = Steps.initial;

  void processIdentity(SigningRequest request) {}

  void processAction(dynamic action) async {
    final data =
        await EosService.of(context, listen: false).fillActionPlaceholders(
      account: action["account"],
      name: action["name"],
      data: action["data"],
    );

    NavigationService.of(context).navigateTo(
      Routes.customTransaction,
      CustomTransactionArguments(
        account: action["account"],
        name: action["name"],
        data: data,
      ),
    );
  }

  void qrCodeCallback(String code) async {
    if (this.step == Steps.processing || this.step == Steps.success) return;

    setState(() {
      this.step = Steps.processing;
    });

    try {
      final esr = SigningRequestManager.from(code,
          options: defaultSigningRequestEncodingOptions(
            nodeUrl: EosService.of(context, listen: false).baseURL,
          ));

      final type = esr.data.req[0];

      setState(() {
        this.step = Steps.success;
      });

      switch (type) {
        case 'identity':
          processIdentity(esr.data);
          break;
        case 'action':
          processAction(esr.data.req[1]);
          break;
        case 'action[]':
          processAction(Action.fromJson(Map.from(esr.data.req[1][0])));
          break;
        case 'transaction':
          processAction(Action.fromJson(Map.from(esr.data.req[1].actions[0])));
          break;
      }
    } catch (e) {
      print(e);

      setState(() {
        this.step = Steps.error;
      });
    }
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
          "Scan Signing Requests",
          style: TextStyle(fontFamily: "worksans", color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            this.step == Steps.error
                ? LinearProgressIndicator(
                    backgroundColor: Colors.red,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  )
                : Container(),
            this.step == Steps.success
                ? LinearProgressIndicator(
                    backgroundColor: Colors.green,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  )
                : Container(),
            this.step == Steps.processing
                ? LinearProgressIndicator()
                : Container(),
            new Expanded(
                child: new Center(
              child: QrCamera(
                qrCodeCallback: qrCodeCallback,
                child: new Container(),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
