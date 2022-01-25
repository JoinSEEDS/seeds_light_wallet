import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/search_result_row.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/interactor/viewmodels/invite_guardians_bloc.dart';

class InviteGuardians extends StatelessWidget {
  const InviteGuardians({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myGuardians = ModalRoute.of(context)?.settings.arguments as Set<ProfileModel>?;

    return BlocProvider(
      create: (_) => InviteGuardiansBloc(myGuardians ?? {}),
      child: BlocListener<InviteGuardiansBloc, InviteGuardiansState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;

          BlocProvider.of<InviteGuardiansBloc>(context).add(const InviteGuardianClearPageCommand());
          if (pageCommand is NavigateToRoute) {
            NavigationService.of(context).navigateTo(pageCommand.route);
          } else if (pageCommand is ShowErrorMessage) {
            SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
          }
        },
        child: BlocBuilder<InviteGuardiansBloc, InviteGuardiansState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: Text("Invite Guardians".i18n)),
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Image(image: AssetImage('assets/images/guardians/invite_guardian_mail.png')),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "The users below will be sent an invite to become your Guardian.".i18n,
                        style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [for (final i in state.selectedGuardians) SearchResultRow(member: i)],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FlatButtonLong(
                        title: 'Send Invite'.i18n,
                        onPressed: () {
                          BlocProvider.of<InviteGuardiansBloc>(context).add(const OnSendInviteTapped());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
