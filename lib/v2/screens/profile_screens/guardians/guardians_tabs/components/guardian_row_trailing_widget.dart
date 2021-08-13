import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_events.dart';
import 'package:seeds/v2/i18n/profile_screens/guardians/guardians.i18n.dart';

class GuardianRowTrailingWidget extends StatelessWidget {
  final GuardianModel guardian;

  const GuardianRowTrailingWidget({Key? key, required this.guardian}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (guardian.status) {
      case GuardianStatus.requestedMe:
        return Wrap(
          children: [
            TextButton(
                onPressed: () {
                  BlocProvider.of<GuardiansBloc>(context).add(OnAcceptGuardianTapped(guardian.uid));
                },
                child: Text("Accept".i18n, style: Theme.of(context).textTheme.subtitle3)),
            TextButton(
                onPressed: () {
                  BlocProvider.of<GuardiansBloc>(context).add(OnDeclineGuardianTapped(guardian.uid));
                },
                child: Text("Decline".i18n, style: Theme.of(context).textTheme.subtitle3Red))
          ],
        );
      case GuardianStatus.requestSent:
        return TextButton(
            onPressed: () {
              BlocProvider.of<GuardiansBloc>(context).add(OnCancelGuardianRequestTapped(guardian.uid));
            },
            child: Text("Cancel Request".i18n, style: Theme.of(context).textTheme.subtitle3Red));
      case GuardianStatus.alreadyGuardian:
        {
          if (guardian.recoveryStartedDate != null) {
            switch (guardian.type) {
              case GuardianType.myGuardian:
                return Text("Recovery Started".i18n, style: Theme.of(context).textTheme.subtitle3Red);
              case GuardianType.imGuardian:
                if (guardian.recoveryApprovedDate != null) {
                  return Text("Recovery Started".i18n, style: Theme.of(context).textTheme.subtitle3Red);
                } else {
                  return ElevatedButton(
                      onPressed: () {
                        // TODO(gguij002): Next PR handle this
                        // tileOnTap!(user, guardian);
                      },
                      child: Text("Action Required".i18n, style: Theme.of(context).textTheme.subtitle3Red));
                }

              default:
                return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
          break; // ignore: dead_code
        }
      default:
        return const SizedBox.shrink();
    }
  }
}
