import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/passcode.i18n.dart';
import 'package:seeds/v2/screens/verification/interactor/viewmodels/bloc.dart';

class CreatePasscode extends StatefulWidget {
  const CreatePasscode({Key key}) : super(key: key);

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
      title: Text('Enter Pincode'.i18n, style: Theme.of(context).textTheme.subtitle2),
      backgroundColor: AppColors.primary,
      shouldTriggerVerification: _verificationNotifier.stream,
      passwordEnteredCallback: (passcode) async {
        BlocProvider.of<VerificationBloc>(context).add(OnCreatePasscode(passcode: passcode));
      },
      bottomWidget: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: OutlinedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.resolveWith<BorderSide>((states) => const BorderSide(color: AppColors.white)),
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0));
              }),
            ),
            child:
                Text('Disable Pincode'.i18n, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2),
            onPressed: () => BlocProvider.of<VerificationBloc>(context).add(const TryAgainBiometric())),
      ),
      circleUIConfig: const CircleUIConfig(circleSize: 14),
    );
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}
