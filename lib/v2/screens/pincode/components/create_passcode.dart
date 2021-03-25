import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/features/biometrics/auth_commands.dart';
import 'package:seeds/i18n/passcode.i18n.dart';
import 'package:seeds/features/biometrics/auth_bloc.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';

class CreatePasscode extends StatelessWidget {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<AuthBloc>(context);
    return PasscodeScreen(
      cancelButton: const SizedBox.shrink(),
      deleteButton: Text('Delete'.i18n, style: Theme.of(context).textTheme.subtitle2),
      passwordDigits: 4,
      title: Text('Enter Pincode'.i18n, style: Theme.of(context).textTheme.subtitle2),
      backgroundColor: AppColors.primary,
      shouldTriggerVerification: _verificationNotifier.stream,
      passwordEnteredCallback: (passcode) async {
        _verificationNotifier.add(true);
        SettingsNotifier.of(context).savePasscode(passcode);
      },
      bottomWidget: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: OutlineButton(
          borderSide: const BorderSide(color: AppColors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child:
              Text('Disable Pincode'.i18n, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2),
          onPressed: () => bloc.execute(DisablePasswordCmd()),
        ),
      ),
      circleUIConfig: const CircleUIConfig(circleSize: 14),
    );
  }
}
