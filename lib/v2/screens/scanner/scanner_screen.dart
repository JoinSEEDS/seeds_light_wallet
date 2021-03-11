import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/screens/scanner/interactor/scanner_bloc.dart';
import 'package:seeds/v2/screens/scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/screens/scanner/interactor/viewmodels/scanner_state.dart';

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

    double width = MediaQuery. of(context). size. width;

    return BlocProvider(
      create: (BuildContext context) => widget._scannerBloc,
      child: BlocBuilder<ScannerBloc, ScannerState>(builder: (context, ScannerState state) {
        return Center(
          child: Container(
            width: width * 0.9,
            height: width * 0.9,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: width * 0.9,
                    height: width * 0.9,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      showNativeAlertDialog: true,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: width * 0.9,
                    height: width * 0.9,
                    decoration: ShapeDecoration(
                        shape: QrScannerOverlayShape(
                            borderLength: width * 0.2,
                            borderRadius: 30,
                            borderWidth: 8,
                            borderColor: AppColors.green1,
                            cutOutSize: width * 0.9,
                            overlayColor: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),
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


