import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';

import 'package:dartesr/eosio_signing_request.dart';

enum Steps { init, scan, processing, success, error }

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Scan> {
  String action, account, data, error, qrcode;
  Steps step = Steps.init;

  @override
  void initState() {
    super.initState();
    scan();
  }

  Future scan() async {
    setState(() {
      this.step = Steps.scan;
    });

    try {
      ScanResult scanResult = await BarcodeScanner.scan();
      setState(() {
        this.step = Steps.processing;
        this.qrcode = scanResult.rawContent;
      });
      processSigningRequest();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.error = 'The user did not grant the camera permission!';
          this.step = Steps.error;
        });
      } else {
        setState(() {
          this.error = 'Unknown error: $e';
          this.step = Steps.error;
        });
      }
    } on FormatException {
      setState(() {
        this.error =
            'null (User returned using the "back"-button before scanning anything. Result)';
        this.step = Steps.error;
      });
    } catch (e) {
      setState(() {
        this.error = 'Scan unknown error: $e';
        this.step = Steps.error;
      });
    }
  }

  void processSigningRequest() async {
    try {
      final esr = await EosioSigningRequest.factory(
        EosService.of(context, listen: false).client,
        this.qrcode,
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
        this.error = 'Invalid QR code: $e';
        this.step = Steps.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    switch (step) {
      case Steps.init:
        widget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(
              'Initialize Camera...',
              style: TextStyle(
                fontFamily: "heebo",
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
        break;
      case Steps.scan:
        widget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(
              'Scan QR Code...',
              style: TextStyle(
                fontFamily: "heebo",
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
        break;
      case Steps.processing:
        widget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Processing QR Code...',
                style: TextStyle(
                  fontFamily: "heebo",
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
        break;
      case Steps.success:
        widget = Center(
          child: Text(
            'Success!',
            style: TextStyle(
              fontFamily: "heebo",
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
        break;
      case Steps.error:
        widget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlineButton(
              child: Text('Try Again'),
              onPressed: scan,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                this.error,
                style: TextStyle(
                  fontFamily: "heebo",
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
        break;
    }

    return Scaffold(
      body: widget,
    );
  }
}
