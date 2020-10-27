import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';

import 'package:seeds/i18n/scan.i18n.dart';

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
      bool shouldKeepScanning = true;
      while (shouldKeepScanning) {
        ScanResult scanResult = await BarcodeScanner.scan();
        if (scanResult.type == ResultType.Cancelled) {
          shouldKeepScanning = false;
          Navigator.of(context).pop();
          break;
        } else {
          setState(() {
            this.step = Steps.processing;
            this.qrcode = scanResult.rawContent;
          });

          // QUESTION: Why do we not check for other URL types like deep link for invite here?
          var esr;
          //print("Scanning QR Code: " + scanResult.rawContent);
          try {
            esr = SeedsESR(uri: scanResult.rawContent);
            await esr.resolve(account: SettingsNotifier.of(context, listen: false).accountName);

          } catch (e) {
            print("can't parse ESR " + e.toString());
            print("ignoring...");
          }
          if (esr != null && canProcess(esr)) {
            shouldKeepScanning = false;
            processSigningRequest(esr);
            break;
          }
        }
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.error = 'Please enable camera access to scan QR codes!'.i18n;
          this.step = Steps.error;
        });
      } else {
        setState(() {
          this.error = 'Unknown error: $e';
          this.step = Steps.error;
        });
      }
    } on FormatException catch (e) {
      print("format exception: " + e.toString());
    } catch (e) {
      setState(() {
        this.error = 'Scan unknown error: $e';
        this.step = Steps.error;
      });
    }
  }

  bool canProcess(SeedsESR esr) {
    return esr.actions.first.account.isNotEmpty && esr.actions.first.name.isNotEmpty;
  }

  void processSigningRequest(SeedsESR esr) async {
    var action = esr.actions.first;
    try {

      if (action.account.isNotEmpty && action.name.isNotEmpty) {
        setState(() {
          this.step = Steps.success;
        });

        Map<String, dynamic> data = Map<String, dynamic>.from(action.data);

        NavigationService.of(context).navigateTo(
            Routes.customTransaction,
            CustomTransactionArguments(
              account: action.account,
              name: action.name,
              data: data,
            ), true);
      } else {
        print("unable to read QR, continuing");
        scan();
      }
    } catch (e) {
      print("scan error: " + e);
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
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
        break;
      case Steps.scan:
        widget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text(
                // this never actually shows
                'Scan QR Code...',
                style: TextStyle(
                  fontFamily: "heebo",
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
        break;
      case Steps.processing:
        widget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Processing QR Code...',
                  style: TextStyle(
                    fontFamily: "heebo",
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case Steps.success:
        widget = Center(
          child: Text(
            'Success!',
            style: TextStyle(
              fontFamily: "heebo",
              fontSize: 24,
              color: Colors.white,
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
              child: Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.white,
              onPressed: scan,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                this.error,
                style: TextStyle(
                  fontFamily: "heebo",
                  fontSize: 18,
                  color: Colors.redAccent,
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
      backgroundColor: Colors.black,
    );
  }
}
