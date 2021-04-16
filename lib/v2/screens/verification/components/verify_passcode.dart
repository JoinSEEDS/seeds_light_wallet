import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/passcode.i18n.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/screens/verification/interactor/viewmodels/bloc.dart';

class VerifyPasscode extends StatefulWidget {
  const VerifyPasscode({Key? key}) : super(key: key);

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
            listener: (context, state) => _verificationNotifier.add(state.isValidPasscode!),
          ),
          BlocListener<VerificationBloc, VerificationState>(
            listenWhen: (_, current) => current.showSuccessDialog != null,
            listener: (context, _) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) => CustomDialog(
                  icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
                  children: [
                    Text(
                      'Succesful'.i18n,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      'Pincode created successfully.'.i18n,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    const SizedBox(height: 30.0),
                  ],
                  singleLargeButtonTitle: 'Close'.i18n,
                ),
              );
            },
          ),
          BlocListener<VerificationBloc, VerificationState>(
            listenWhen: (_, current) => current.onBiometricAuthorized != null,
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
          bottomWidget: settingsStorage.biometricActive!
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                            (states) => const BorderSide(color: AppColors.white)),
                        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0));
                        }),
                      ),
                      child: Text('Disable Pincode'.i18n,
                          textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2),
                      onPressed: () => BlocProvider.of<VerificationBloc>(context).add(const TryAgainBiometric())),
                )
              : const SizedBox.shrink(),
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
