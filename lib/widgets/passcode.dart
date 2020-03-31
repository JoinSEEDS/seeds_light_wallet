import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:teloswallet/providers/notifiers/auth_notifier.dart';
import 'package:teloswallet/providers/notifiers/settings_notifier.dart';

Widget buildPasscodeScreen({
  shouldTriggerVerification,
  passwordEnteredCallback,
  isValidCallback,
  cancelCallback,
  title = "Enter Passcode",
}) {
  return PasscodeScreen(
    passwordDigits: 4,
    title: title,
    cancelLocalizedText: "",
    deleteLocalizedText: "Delete",
    backgroundColor: const Color(0xFF24b0d6),
    shouldTriggerVerification: shouldTriggerVerification,
    passwordEnteredCallback: passwordEnteredCallback,
    isValidCallback: isValidCallback,
    cancelCallback: cancelCallback,
  );
}

class UnlockWallet extends StatelessWidget {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return buildPasscodeScreen(
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
    );
  }
}

class LockWallet extends StatelessWidget {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return buildPasscodeScreen(
      title: "Choose Passcode",
      shouldTriggerVerification: _verificationNotifier.stream,
      passwordEnteredCallback: (passcode) {
        _verificationNotifier.add(true);
        SettingsNotifier.of(context).savePasscode(passcode);
      },
      isValidCallback: () {},
      cancelCallback: () {},
    );
  }
}
