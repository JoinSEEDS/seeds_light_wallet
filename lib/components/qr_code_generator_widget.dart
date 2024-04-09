import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/global_error.dart';

class QrCodeGeneratorWidget extends StatelessWidget {
  final String data;
  final double size;

  const QrCodeGeneratorWidget({super.key, required this.data, required this.size});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      size: size,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      errorStateBuilder: (_, err) {
        return Center(child: Text(GlobalError.unknown.localizedDescription(context), textAlign: TextAlign.center));
      },
    );
  }
}
