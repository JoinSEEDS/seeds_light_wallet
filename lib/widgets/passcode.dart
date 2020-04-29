import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/biometrics/auth_commands.dart';
import 'package:seeds/features/biometrics/auth_bloc.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';

Widget buildPasscodeScreen({
  shouldTriggerVerification,
  passwordEnteredCallback,
  isValidCallback,
  cancelCallback,
  title = "Enter Passcode",
  Widget bottomWidget,
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
    bottomWidget: bottomWidget,
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
    AuthBloc bloc = Provider.of(context);

    return buildPasscodeScreen(
      title: "Choose Passcode",
      shouldTriggerVerification: _verificationNotifier.stream,
      passwordEnteredCallback: (passcode) {
        _verificationNotifier.add(true);
        SettingsNotifier.of(context).savePasscode(passcode);
      },
      isValidCallback: () {},
      cancelCallback: () {},
      bottomWidget: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: MaterialButton(
          child: Container(
            padding: const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Text(
              "Disable Passcode",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w300
              ),
            ),
          ),
          onPressed: () {
            bloc.execute(DisablePasswordCmd());
          },
        ),
      ),
    );
  }
}
