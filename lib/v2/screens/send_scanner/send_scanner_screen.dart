import 'package:flutter/material.dart';
import 'package:seeds/v2/components/scanner/scanner_screen.dart';

/// Scanner SCREEN
class SendScannerScreen extends StatefulWidget {
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
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: Column(
        children: [_scannerScreen],
      ),
    );
  }

  Future<void> onResult(String scanResult) async {
    _scannerScreen.showLoading();

    /// "TODO(gguij002): Next PR will take care of making network calls and validation. This is dummy for testing."
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    _scannerScreen.scan();
  }
}
