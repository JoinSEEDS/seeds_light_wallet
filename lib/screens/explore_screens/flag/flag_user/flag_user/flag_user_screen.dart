import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/flag_user/components/flag_user_confirmation_dialog.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/flag_user/interactor/viewmodel/flag_user_bloc.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/flag_user/interactor/viewmodel/flag_user_page_commands.dart';

class FlagUserScreen extends StatelessWidget {
  const FlagUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alreadyVouched = ModalRoute.of(context)?.settings.arguments as List<MemberModel>?;

    return Scaffold(
      appBar: AppBar(title: const Text("Flag")),
      body: BlocProvider(
        create: (_) => FlagUserBloc(alreadyVouched ?? []),
        child: BlocConsumer<FlagUserBloc, FlagUserState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is ShowFlagUserConfirmation) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<FlagUserBloc>(context),
                    child: const FlagUserConfirmationDialog(),
                  );
                },
              );
            } else if (pageCommand is ShowFlagUserSuccess) {
              Navigator.of(context).pop(true);
            } else if (pageCommand is ShowErrorMessage) {
              SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
            }
            BlocProvider.of<FlagUserBloc>(context).add(const ClearPageCommand());
          },
          builder: (context, FlagUserState state) {
            switch (state.pageState) {
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
              case PageState.success:
                return Column(
                  children: [
                    Expanded(
                      child: SearchUser(
                        noShowUsers: state.noShowUsers.toList(),
                        onUserSelected: (selectedUser) {
                          BlocProvider.of<FlagUserBloc>(context).add(OnUserSelected(selectedUser));
                        },
                      ),
                    ),
                  ],
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
