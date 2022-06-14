import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seeds/components/scanner/components/qr_code_view.dart';
import 'package:seeds/components/scanner/interactor/viewmodels/scanner_bloc.dart';
import 'package:seeds/utils/string_extension.dart';

class ScannerView extends StatefulWidget {
  final ScannerBloc _scannerBloc = ScannerBloc();
  final ValueSetter<String> onCodeScanned;

  ScannerView({super.key, required this.onCodeScanned});

  void scan() => _scannerBloc.add(const Scan());

  @override
  _ScannerViewState createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  // This key is necessary for iOS in order to get the render context
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget._scannerBloc,
      child: Stack(
        alignment: Alignment.center,
        children: [
          BlocBuilder<ScannerBloc, ScannerState>(
            builder: (_, state) {
              return QRCodeView(
                qrKey: _qrKey,
                onQRViewCreated: (controller) async {
                  _controller = controller;
                  _controller.scannedDataStream.listen((event) {
                    if (state.gotValidQR || event.code.isNullOrEmpty) {
                      return;
                    } else {
                      widget._scannerBloc.add(const ShowLoading());
                      widget.onCodeScanned(event.code!);
                    }
                  });
                },
              );
            },
          ),
          BlocBuilder<ScannerBloc, ScannerState>(
            builder: (_, state) {
              switch (state.scanStatus) {
                case ScanStatus.processing:
                  return const Center(child: CircularProgressIndicator());
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
