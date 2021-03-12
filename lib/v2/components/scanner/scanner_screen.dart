import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seeds/v2/components/scanner/interactor/scanner_bloc.dart';
import 'package:seeds/v2/components/scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/components/scanner/interactor/viewmodels/scanner_state.dart';
import 'package:seeds/v2/components/scanner/seeds_qr_code_scanner_widget.dart';

/// Scanner SCREEN
class ScannerScreen extends StatefulWidget {
  final ScannerBloc _scannerBloc = ScannerBloc();
  final Function resultCallback;

  ScannerScreen({Key key, this.resultCallback}) : super(key: key);

  void scan() {
    _scannerBloc.add(Scan());
  }

  void showError(String errorMessage) {
    _scannerBloc.add(ShowError(error: errorMessage));
  }

  void showLoading() {
    _scannerBloc.add(ShowLoading());
  }

  void resultCallBack(String scanResult) {
    resultCallback(scanResult);
  }

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  bool _handledQrCode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => widget._scannerBloc,
      child: BlocBuilder<ScannerBloc, ScannerState>(builder: (context, ScannerState state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SeedsQRCodeScannerWidget(
              onQRViewCreated: _onQRViewCreated,
              qrKey: qrKey,
            ),
            Center(child: buildStateView(state))
          ],
        );
      }),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;

    controller.scannedDataStream.listen(
      (String scanResult) async {
        if (_handledQrCode) {
          return;
        }
        setState(() {
          _handledQrCode = true;
        });

        if (scanResult == null) {
        } else {
          widget.resultCallBack(scanResult);
        }
      },
    );
  }

  Widget buildStateView(state) {
    switch (state.pageState) {
      case PageState.scan:
        _handledQrCode = false;
        return const SizedBox.shrink();
      case PageState.success:
        _handledQrCode = true;
        return const SizedBox.shrink();
      case PageState.processing:
        return const CircularProgressIndicator();
      case PageState.error:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}
