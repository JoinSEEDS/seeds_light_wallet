import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/passcode.i18n.dart';
import 'package:seeds/v2/screens/verification/interactor/viewmodels/bloc.dart';

class VerifyPasscode extends StatefulWidget {
  const VerifyPasscode({Key key}) : super(key: key);

  @override
  _VerifyPasscodeState createState() => _VerifyPasscodeState();
}

class _VerifyPasscodeState extends State<VerifyPasscode> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<VerificationBloc, VerificationState>(
            listenWhen: (previous, current) => previous.isValidPasscode != current.isValidPasscode,
            listener: (context, state) => _verificationNotifier.add(state.isValidPasscode),
          ),
          BlocListener<VerificationBloc, VerificationState>(
            listenWhen: (_, current) => current.onBiometricAuthorized,
            listener: (context, _) => Navigator.of(context).pop(),
          ),
          BlocListener<VerificationBloc, VerificationState>(
            listenWhen: (_, current) => current.showInfoSnack != null,
            listener: (context, _) {
              BlocProvider.of<VerificationBloc>(context).add(const ResetShowSnack());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.canopy,
                  content: Text(
                    'Pincode does not match',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              );
            },
          ),
        ],
        child: PasscodeScreen(
          cancelButton: const SizedBox.shrink(),
          deleteButton: Text('Delete'.i18n, style: Theme.of(context).textTheme.subtitle2),
          passwordDigits: 4,
          title: Text('Re-enter Pincode'.i18n, style: Theme.of(context).textTheme.subtitle2),
          backgroundColor: AppColors.primary,
          shouldTriggerVerification: _verificationNotifier.stream,
          passwordEnteredCallback: (passcode) =>
              BlocProvider.of<VerificationBloc>(context).add(OnVerifyPasscode(passcode: passcode)),
          isValidCallback: () => BlocProvider.of<VerificationBloc>(context).add(const OnValidVerifyPasscode()),
          bottomWidget: const SizedBox.shrink(),
          circleUIConfig: const CircleUIConfig(circleSize: 14),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}
