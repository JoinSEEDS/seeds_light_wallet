import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/components/delegate_card.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/components/remove_delegate_success_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_state.dart';

class DelegateScreen extends StatelessWidget {
  const DelegateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trust & Delegates'),
      ),
      body: BlocProvider(
        create: (context) => DelegateBloc()..add(const LoadDelegateData()),
        child: BlocConsumer<DelegateBloc, DelegateState>(
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is ShowDelegateRemovalSuccess) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<DelegateBloc>(context),
                    child: const RemoveDelegateSuccessDialog(),
                  );
                },
              );
            } else if (pageCommand is ShowErrorMessage) {
              SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
            }

            BlocProvider.of<DelegateBloc>(context).add(ClearPageCommand());
          },
          builder: (context, DelegateState state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return Column(
                  children: <Widget>[
                    DelegateCard(
                        onTapRemove: () {
                          BlocProvider.of<DelegateBloc>(context).add(const RemoveDelegate());
                        },
                        onTap: () {
                          NavigationService.of(context).navigateTo(Routes.delegateAUser);
                        },
                        activeDelegate: state.activeDelegate)
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
