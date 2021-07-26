import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_bloc.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_event.dart';

class GuardianApproveOrDenyScreen extends StatelessWidget {
  final GuardianRecoveryRequestData data;

  const GuardianApproveOrDenyScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
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
              'Account Recovery Request',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                data.guardianAccount +
                    ' has initiated their account recovery process through their Key Guardians. Accepting this request will help them to recover their account. Please make sure they are who they claim to be and are actually locked out of their account before accepting.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
          leftButtonTitle: 'Dismiss',
          rightButtonTitle: 'Accept Request',
          onLeftButtonPressed: () {
            BlocProvider.of<AppBloc>(context).add(OnDismissGuardianRecoveryTapped());
          },
          onRightButtonPressed: () {
            BlocProvider.of<AppBloc>(context).add(OnApproveGuardianRecoveryTapped(data));
          },
        ),
      ),
    );
  }
}
