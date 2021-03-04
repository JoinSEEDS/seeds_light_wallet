import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/esr_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';

enum Steps { scan, processing, success, error }

class Scan extends StatefulWidget {
  final shouldSendResultsBack;

  @override
  _ScanState createState() => new _ScanState();

  Scan(this.shouldSendResultsBack);
}

class _ScanState extends State<Scan> {
  String action, account, data, error, qrcode;
  Steps step = Steps.scan;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _handledQrCode = false;

  @override
  void initState() {
    super.initState();
  }

  void processIdentityRequest(SeedsESR esr) async {
    try {
      var response = await EsrService().getIdentityResponse(
        request: esr,
        accountName: SettingsNotifier.of(context, listen: false).accountName,
        walletPrivateKey: SettingsNotifier.of(context, listen: false).privateKey,
      );

      await post(
        response.callback,
        body: response.body,
      );
    } catch (e) {
      print("scan error: " + e);
      setState(() {
        this.error = 'Invalid QR code';
        this.step = Steps.error;
      });
    }

    Navigator.of(context).pop();
  }

  void processTransactionRequest(SeedsESR esr) async {
    try {
      var arguments = await EsrService().getTransactionArguments(
        request: esr,
        accountName: SettingsNotifier.of(context, listen: false).accountName,
      );

      NavigationService.of(context).navigateTo(
        Routes.customTransaction,
        arguments,
      );
    } catch (e) {
      print("scan error: " + e);
      setState(() {
        this.error = 'Invalid QR code';
        this.step = Steps.error;
      });
    }
  }

  void processSigningRequest(SeedsESR esr) async {
    if (esr.manager.data.req[0] == "identity") {
      return processIdentityRequest(esr);
    } else {
      return processTransactionRequest(esr);
    }
  }

  void _showToast(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;

    controller.scannedDataStream.listen(
      (String scanResult) async {
        if (_handledQrCode) {
          return;
        }

        _handledQrCode = true;

        if (scanResult == null) {
          Navigator.of(context).pop();
        } else {
          setState(() {
            this.step = Steps.processing;
            this.qrcode = scanResult;
          });

          if (widget.shouldSendResultsBack) {
            Navigator.pop(context, scanResult);
          } else {
            var esr;
            print("Scanning QR Code: " + scanResult);
            try {
              esr = SeedsESR(uri: scanResult);
            } catch (e) {
              print("can't parse ESR " + e.toString());
              print("ignoring... show toast");
              _showToast(context, "Invalid QR code");

              setState(() {
                _handledQrCode = false;
                this.step = Steps.scan;
              });
            }
            if (esr != null) {
              processSigningRequest(esr);
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    switch (step) {
      case Steps.scan:
        widget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  showNativeAlertDialog: true,
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
                    color: Colors.black,
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
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
        break;
      case Steps.error:
        widget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: OutlineButton(
                  child: Text(
                    'Try Again',
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      _handledQrCode = false;
                      this.step = Steps.scan;
                    });
                  },
                ),
              ),
            ],
          ),
        );
        break;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Scanner",
          style: TextStyle(fontFamily: "worksans", color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: widget,
    );
  }
}
