import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/i18n/guardians.i18n.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/search_result_row.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/invite_guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_state.dart';

class InviteGuardians extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myGuardians = ModalRoute.of(context)?.settings.arguments as Set<MemberModel>?;

    return BlocProvider(
        create: (context) => InviteGuardiansBloc(myGuardians ?? {}),
        child: BlocListener<InviteGuardiansBloc, InviteGuardiansState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {},
          child: BlocBuilder<InviteGuardiansBloc, InviteGuardiansState>(builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Invite Guardians"),
                ),
                body: Column(
                  children: [
                    const SizedBox(height: 24),
                    SvgPicture.asset('assets/images/guardians/invite_guardian_mail.svg'),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "The users below will be sent an invite to become your Guardian.".i18n,
                        style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: state.selectedGuardians
                            .map((e) => SearchResultRow(
                                  account: e.account,
                                  name: e.nickname ?? e.account,
                                  imageUrl: e.image,
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FlatButtonLong(
                        title: 'Send Invite',
                        onPressed: () {
                          // TODO(gguij002): TODO next pr
                          // FirebaseDatabaseService()
                          //     .sendGuardiansInvite(SettingsNotifier.of(context).accountName, widget.selectedUsers!.toList())
                          //     .catchError((onError) => onSendInviteError(onError))
                          //     .then((value) => NavigationService.of(context).navigateTo(Routes.inviteGuardiansSent))
                        },
                      ),
                    ),
                  ],
                ));
          }),
        ));
  }
}
