import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:seeds/i18n/widgets.i18n.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/constants/app_colors.dart';

Widget buildPasscodeScreen(
    {required Stream<bool> shouldTriggerVerification,
    required PasswordEnteredCallback passwordEnteredCallback,
    IsValidCallback? isValidCallback,
    CancelCallback? cancelCallback,
    required Widget title,
    Widget? bottomWidget,
    required BuildContext context}) {
  return PasscodeScreen(
    cancelButton: const SizedBox.shrink(),
    deleteButton: Text('Delete'.i18n, style: Theme.of(context).textTheme.subtitle2),
    passwordDigits: 4,
    title: title,
    backgroundColor: AppColors.primary,
    shouldTriggerVerification: shouldTriggerVerification,
    passwordEnteredCallback: passwordEnteredCallback,
    isValidCallback: isValidCallback,
    cancelCallback: cancelCallback,
    bottomWidget: bottomWidget,
    circleUIConfig: const CircleUIConfig(circleSize: 14),
  );
}

class UnlockWallet extends StatelessWidget {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return buildPasscodeScreen(
        title: Text('Enter Passcode'.i18n),
        shouldTriggerVerification: _verificationNotifier.stream,
        passwordEnteredCallback: (passcode) async {
          if (passcode == SettingsNotifier.of(context).passcode) {
            _verificationNotifier.add(true);
          } else {
            _verificationNotifier.add(false);
          }
        },
        isValidCallback: () {
          AuthNotifier.of(context).unlockWallet();
        },
        cancelCallback: () {},
        context: context);
  }
}

class LockWallet extends StatelessWidget {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: buildPasscodeScreen(
            title: Text('Choose Passcode'.i18n, style: Theme.of(context).textTheme.subtitle2),
            shouldTriggerVerification: _verificationNotifier.stream,
            passwordEnteredCallback: (passcode) {
              _verificationNotifier.add(true);
              SettingsNotifier.of(context).savePasscode(passcode);
            },
            isValidCallback: () {},
            cancelCallback: () {},
            bottomWidget: LockWalletBottomWidget(),
            context: context),
      ),
    );
  }
}

class LockWalletBottomWidget extends StatelessWidget {
  const LockWalletBottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: OutlinedButton(
        style: ButtonStyle(
          side: MaterialStateProperty.resolveWith<BorderSide>((states) => const BorderSide(color: AppColors.white)),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0));
          }),
        ),
        child: Text('Disable Passcode'.i18n, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2),
        onPressed: () {},
      ),
    );
  }
}
