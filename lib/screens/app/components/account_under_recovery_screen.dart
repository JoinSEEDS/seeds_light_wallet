import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/app/app.i18.dart';
import 'package:seeds/screens/app/interactor/viewmodels/app_bloc.dart';

class AccountUnderRecoveryScreen extends StatelessWidget {
  const AccountUnderRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          singleLargeButtonTitle: 'Cancel Recovery'.i18n,
          onSingleLargeButtonPressed: () {
            BlocProvider.of<AppBloc>(context)
                .add(const OnStopGuardianActiveRecoveryTapped());
          },
          children: [
            Container(
              height: 200,
              width: 250,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/guardians/guardian_shield.png'),
                    fit: BoxFit.fitWidth),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Recovery Mode Initiated'.i18n,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Someone has initiated the Recovery process for your account. If you did not request to recover your account please select cancel recovery.'
                    .i18n,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
