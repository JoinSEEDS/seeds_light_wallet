import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/guardian_row_trailing_widget.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';
import 'package:seeds/utils/string_extension.dart';

class GuardianRowWidget extends StatelessWidget {
  final GuardianModel guardianModel;

  const GuardianRowWidget({super.key, required this.guardianModel});

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
        style: Theme.of(context).textTheme.labelLarge,
      ),
      subtitle: Text(guardianModel.uid, style: Theme.of(context).textTheme.subtitle2OpacityEmphasis),
      onTap: () {
        BlocProvider.of<GuardiansBloc>(context).add(OnGuardianRowTapped(guardianModel));
      },
    );
  }
}
