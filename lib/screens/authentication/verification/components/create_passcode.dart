import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/authentication/verification/verification.i18n.dart';
import 'package:seeds/screens/authentication/verification/components/passcode_screen.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/bloc.dart';

class CreatePasscode extends StatefulWidget {
  const CreatePasscode({Key? key}) : super(key: key);

  @override
  _CreatePasscodeState createState() => _CreatePasscodeState();
}

class _CreatePasscodeState extends State<CreatePasscode> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
      title: Text('Create Pincode'.i18n, style: Theme.of(context).textTheme.subtitle2),
      shouldTriggerVerification: _verificationNotifier.stream,
      onPasswordCompleted: (passcode) {
        BlocProvider.of<VerificationBloc>(context).add(OnCreatePasscode(passcode: passcode));
      },
    );
  }
}
