import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seeds/v2/components/scanner/interactor/scanner_bloc.dart';
import 'package:seeds/v2/components/scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/components/scanner/interactor/viewmodels/scanner_state.dart';
import 'package:seeds/v2/components/scanner/seeds_qr_code_scanner_widget.dart';

/// Scanner SCREEN
class ScannerWidget extends StatefulWidget {
  final ScannerBloc _scannerBloc = ScannerBloc();
  final ValueSetter<String> resultCallBack;

  ScannerWidget({Key? key, required this.resultCallBack}) : super(key: key);

  void scan() => _scannerBloc.add(Scan());

  void showLoading() => _scannerBloc.add(ShowLoading());

  void stop() => _scannerBloc.add(Stop());

  @override
  _ScannerWidgetState createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _controller;
  bool _handledQrCode = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget._scannerBloc,
      child: BlocBuilder<ScannerBloc, ScannerState>(
        builder: (context, state) {
          if (state.scanStatus is Stop) {
            _controller.dispose();
            const SizedBox.shrink();
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              SeedsQRCodeScannerWidget(
                onQRViewCreated: _onQRViewCreated,
                qrKey: _qrKey,
              ),
              Center(child: buildStateView(state))
            ],
          );
        },
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    _controller = controller;

    _controller.scannedDataStream.listen((Barcode event) {
      print("scannedDataStream");
      if (_handledQrCode || event.code.isEmpty) {
        return;
      }

      setState(() => _handledQrCode = true);

      widget.resultCallBack(event.code);
    });
  }

  Widget buildStateView(state) {
    switch (state.scanStatus) {
      case ScanStatus.scan:
        _handledQrCode = false;
        return const SizedBox.shrink();
      case ScanStatus.success:
        _handledQrCode = true;
        return const SizedBox.shrink();
      case ScanStatus.processing:
        _handledQrCode = true;
        return const CircularProgressIndicator();
      case ScanStatus.stop:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}
