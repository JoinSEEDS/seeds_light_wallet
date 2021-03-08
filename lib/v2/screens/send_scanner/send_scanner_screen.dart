import 'package:flutter/material.dart';
import 'package:seeds/v2/screens/scanner/scanner_screen.dart';

/// Scanner SCREEN
class SendScannerScreen extends StatefulWidget {
  // final ScannerBloc _scannerBloc = ScannerBloc();

  // SendScannerScreen({Key key, this.scannerAppbarTitle, this.scannerLabel}) : super(key: key);

  @override
  _SendScannerScreenState createState() => _SendScannerScreenState();
}

class _SendScannerScreenState extends State<SendScannerScreen> {

  ScannerScreen _scannerScreen;

  @override
  void initState() {
    super.initState();
    _scannerScreen = ScannerScreen(resultCallback: onResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TITLE")),
      body: Column(
        children: [_scannerScreen],
      ),
    );
  }

  Future<void> onResult(String scanResult)  async {
    _scannerScreen.showLoading();
    print("BEFOREEE Scanning QR Code: " + scanResult);
    await Future.delayed(Duration(milliseconds: 3000), () {});
    print("Scanning QR Code: " + scanResult);
    _scannerScreen.scan();
  }
}
