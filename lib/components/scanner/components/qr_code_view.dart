import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seeds/design/app_colors.dart';

class QRCodeView extends StatelessWidget {
  final GlobalKey? qrKey;
  final QRViewCreatedCallback onQRViewCreated;

  const QRCodeView({required this.onQRViewCreated, super.key, this.qrKey});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.85;
    return Center(
      child: Container(
        width: width,
        height: width,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: width,
                height: width,
                child: QRView(
                  key: qrKey!,
                  onQRViewCreated: onQRViewCreated,
                ),
              ),
            ),
            Center(
              child: Container(
                width: width,
                height: width,
                decoration: ShapeDecoration(
                    shape: QrScannerOverlayShape(
                        borderLength: width * 0.2,
                        borderRadius: 30,
                        borderWidth: 8,
                        borderColor: AppColors.green1,
                        cutOutSize: width,
                        overlayColor: AppColors.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
