import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/components/delegate_card.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/components/introducing_delegates_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/components/remove_delegate_confirmation_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_state.dart';

class DelegatesTab extends StatelessWidget {
  const DelegatesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DelegateBloc()..add(const LoadDelegateData()),
      child: BlocConsumer<DelegateBloc, DelegateState>(
        listener: (context, state) {
          final pageCommand = state.pageCommand;

          if (pageCommand is ShowDelegateRemovalConfirmation) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<DelegateBloc>(context),
                  child: const RemoveDelegateConfirmationDialog(),
                );
              },
            );
          } else if (pageCommand is ShowOnboardingDelegate) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) => const IntroducingDelegatesDialog(),
            );
          } else if (pageCommand is ShowErrorMessage) {
            SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
          }

          BlocProvider.of<DelegateBloc>(context).add(ClearPageCommand());
        },
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.initial:
              return const SizedBox.shrink();
            case PageState.loading:
              return const FullPageLoadingIndicator();
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          'Delegating your vote means to entrust the power of your vote to another Citizen.  Please choose your delegate carefully!',
                          style: Theme.of(context).textTheme.subtitle2),
                    ),
                    const SizedBox(height: 30),
                    DelegateCard(
                        onTapRemove: () => BlocProvider.of<DelegateBloc>(context).add(const RemoveDelegateTap()),
                        onTap: () => NavigationService.of(context).navigateTo(Routes.delegateAUser),
                        activeDelegate: state.activeDelegate,
                        delegate: state.delegate)
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
