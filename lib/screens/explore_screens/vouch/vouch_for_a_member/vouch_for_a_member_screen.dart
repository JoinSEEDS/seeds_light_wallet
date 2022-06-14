import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vouch/vouch_for_a_member/components/vouch_for_member_confirmation_dialog.dart';
import 'package:seeds/screens/explore_screens/vouch/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_bloc.dart';
import 'package:seeds/screens/explore_screens/vouch/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_page_commands.dart';

class VouchForAMemberScreen extends StatelessWidget {
  const VouchForAMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alreadyVouched = ModalRoute.of(context)?.settings.arguments as List<ProfileModel>?;

    return Scaffold(
      appBar: AppBar(title: const Text("Vouch")),
      body: BlocProvider(
        create: (_) => VouchForAMemberBloc(alreadyVouched ?? []),
        child: BlocConsumer<VouchForAMemberBloc, VouchForAMemberState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is ShowVouchForMemberConfirmation) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<VouchForAMemberBloc>(context),
                    child: const VouchForMemberConfirmationDialog(),
                  );
                },
              );
            } else if (pageCommand is ShowVouchForMemberSuccess) {
              Navigator.of(context).pop(true);
            } else if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            }
            BlocProvider.of<VouchForAMemberBloc>(context).add(const ClearPageCommand());
          },
          builder: (context, VouchForAMemberState state) {
            switch (state.pageState) {
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
              case PageState.success:
                return SearchUser(
                  noShowUsers: state.noShowUsers.toList(),
                  onUserSelected: (selectedUser) {
                    BlocProvider.of<VouchForAMemberBloc>(context).add(OnUserSelected(selectedUser));
                  },
                );

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
