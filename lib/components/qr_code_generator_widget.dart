import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/i18n/components/components.i18n.dart';

class QrCodeGeneratorWidget extends StatelessWidget {
  final String data;
  final double size;

  const QrCodeGeneratorWidget({Key? key, required this.data, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: data,
      size: size,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      errorStateBuilder: (_, err) {
        return Center(child: Text('Oops, Something Went Wrong'.i18n, textAlign: TextAlign.center));
      },
    );
  }
}
