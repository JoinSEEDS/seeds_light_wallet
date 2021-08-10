import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_bloc.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_event.dart';

class AccountUnderRecoveryScreen extends StatelessWidget {
  const AccountUnderRecoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          singleLargeButtonTitle: 'Cancel Recovery',
          onSingleLargeButtonPressed: () async {
            BlocProvider.of<AppBloc>(context).add(const OnStopGuardianActiveRecoveryTapped());
          },
          children: [
            Container(
              height: 200,
              width: 250,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/guardians/guardian_shield.png',
                    ),
                    fit: BoxFit.fitWidth),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Recovery Mode Initiated',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Someone has initiated the Recovery process for your account. If you did not request to recover your account please select cancel recovery.',
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
