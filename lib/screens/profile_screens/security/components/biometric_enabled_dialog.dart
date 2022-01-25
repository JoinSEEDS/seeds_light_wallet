import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

class BiometricEnabledDialog extends StatelessWidget {
  const BiometricEnabledDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return CustomDialog(
      icon: const Icon(Icons.fingerprint, size: 52, color: AppColors.green1),
      singleLargeButtonTitle: localization.securityBiometricEnabledConfirmationButtonTitle,
      children: [
        Text(localization.securityBiometricEnabledTitle, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 24.0),
        Text(
          localization.securityBiometricEnabledDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
