import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/passcode.i18n.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/viewmodels/bloc.dart';

class CreatePasscode extends StatefulWidget {
  const CreatePasscode({Key? key}) : super(key: key);

  @override
  _CreatePasscodeState createState() => _CreatePasscodeState();
}

class _CreatePasscodeState extends State<CreatePasscode> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
      cancelButton: const SizedBox.shrink(),
      deleteButton: Text('Delete'.i18n, style: Theme.of(context).textTheme.subtitle2),
      passwordDigits: 4,
      title: Text('Create Pincode'.i18n, style: Theme.of(context).textTheme.subtitle2),
      backgroundColor: AppColors.primary,
      shouldTriggerVerification: _verificationNotifier.stream,
      passwordEnteredCallback: (passcode) async {
        BlocProvider.of<VerificationBloc>(context).add(OnCreatePasscode(passcode: passcode));
      },
      circleUIConfig: const CircleUIConfig(circleSize: 14),
    );
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}
