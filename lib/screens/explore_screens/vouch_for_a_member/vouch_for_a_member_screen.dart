import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/components/vouch_for_member_confirmation_dialog.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/components/vouch_success_dialog.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_bloc.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_page_commands.dart';

class VouchForAMemberScreen extends StatelessWidget {
  const VouchForAMemberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VouchForAMemberBloc(),
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
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<VouchForAMemberBloc>(context),
                  child: const VouchSuccessDialog(),
                );
              },
            );
          } else if (pageCommand is ShowErrorMessage) {
            SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
          }
          BlocProvider.of<VouchForAMemberBloc>(context).add(const ClearPageCommand());
        },
        builder: (context, VouchForAMemberState state) {
          switch (state.pageState) {
            case PageState.loading:
              return const Scaffold(body: FullPageLoadingIndicator());
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return Scaffold(
                appBar: AppBar(title: const Text("Vouch")),
                body: Column(
                  children: [
                    Expanded(
                      child: SearchUser(
                        noShowUsers: state.noShowUsers,
                        onUserSelected: (selectedUser) {
                          BlocProvider.of<VouchForAMemberBloc>(context).add(OnUserSelected(selectedUser));
                        },
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
