import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_events.dart';

class GuardianRowWidget extends StatelessWidget {
  final GuardianModel guardianModel;

  const GuardianRowWidget({
    Key? key,
    required this.guardianModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        trailing: GuardianRowTrailingWidget(guardian: guardianModel),
        leading: ProfileAvatar(
          size: 60,
          image: guardianModel.image,
          account: guardianModel.uid,
          nickname: guardianModel.nickname,
        ),
        title: Text(
          (!guardianModel.nickname.isNullOrEmpty) ? guardianModel.nickname! : guardianModel.uid,
          style: Theme.of(context).textTheme.button,
        ),
        subtitle: Text(guardianModel.uid, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
        onTap: () {
          // TODO(gguij002): Next PR handle this
          // tileOnTap!(user, guardian);
        });
  }
}

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
                child: Text("Accept", style: Theme.of(context).textTheme.subtitle3),
                onPressed: () {
                  BlocProvider.of<GuardiansBloc>(context).add(OnAcceptGuardianTapped(guardian.uid));
                }),
            TextButton(
                child: Text("Decline", style: Theme.of(context).textTheme.subtitle3Red),
                onPressed: () {
                  BlocProvider.of<GuardiansBloc>(context).add(OnDeclineGuardianTapped(guardian.uid));
                })
          ],
        );
      case GuardianStatus.requestSent:
        return TextButton(
            child: Text("Cancel Request", style: Theme.of(context).textTheme.subtitle3Red),
            onPressed: () {
              BlocProvider.of<GuardiansBloc>(context).add(OnCancelGuardianRequestTapped(guardian.uid));
            });
      case GuardianStatus.alreadyGuardian:
        {
          if (guardian.recoveryStartedDate != null) {
            switch (guardian.type) {
              case GuardianType.myGuardian:
                return Text("Recovery Started", style: Theme.of(context).textTheme.subtitle3Red);
              case GuardianType.imGuardian:
                if (guardian.recoveryApprovedDate != null) {
                  return Text("Recovery Started", style: Theme.of(context).textTheme.subtitle3Red);
                } else {
                  return ElevatedButton(
                      onPressed: () {
                        // TODO(gguij002): Next PR handle this
                        // tileOnTap!(user, guardian);
                      },
                      child: Text("Action Required", style: Theme.of(context).textTheme.subtitle3Red));
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
