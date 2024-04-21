import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:seeds/components/scanner/interactor/viewmodels/scanner_bloc.dart';

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
  //final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

   @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => widget._scannerBloc,
      child: Container(
        constraints: BoxConstraints.expand(height:mediaSize.width*0.9, width:mediaSize.width*0.9),
        child: Stack(
          alignment: Alignment.center,
          children: [
            BlocBuilder<ScannerBloc, ScannerState>(
              builder: (_, state) {
                  return MobileScanner(
                    onDetect: (capture) {
                      if (state.gotValidQR ) {
                          return;
                      } else {
                        widget._scannerBloc.add(const ShowLoading());
                        widget.onCodeScanned(capture.barcodes.first.rawValue!);
                      }
                    });
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
      )
    );
  }
}
