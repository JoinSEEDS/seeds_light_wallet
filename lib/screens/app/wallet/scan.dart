import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';

import 'package:dartesr/eosio_signing_request.dart';

import 'package:qr_mobile_vision/qr_camera.dart';

enum Steps { initial, processing, success, error }

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Scan> {
  String qrcode;
  Steps step = Steps.initial;

  void qrCodeCallback(String code) async {
    if (this.step == Steps.processing) return;

    print(EosService.of(context, listen: false).client);

    setState(() {
      this.step = Steps.processing;
    });

    try {
      print("QR Code: " + code);

      final esr = await EosioSigningRequest.factory(
        EosService.of(context, listen: false).client,
        code,
        SettingsNotifier.of(context, listen: false).accountName,
      );

      assert(esr.action.account.isNotEmpty);
      assert(esr.action.name.isNotEmpty);

      setState(() {
        this.step = Steps.success;
      });

      Map<String, dynamic> data = Map<String, dynamic>.from(esr.action.data);

      NavigationService.of(context).navigateTo(
          Routes.customTransaction,
          CustomTransactionArguments(
            account: esr.action.account,
            name: esr.action.name,
            data: data,
          ),
          true);
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
