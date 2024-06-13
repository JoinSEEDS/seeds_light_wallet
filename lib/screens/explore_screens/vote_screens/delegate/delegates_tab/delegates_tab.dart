import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/components/delegate_card.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/components/introducing_delegates_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/components/remove_delegate_confirmation_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegates_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegates_page_commands.dart';

class DelegatesTab extends StatelessWidget {
  const DelegatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DelegatesBloc()..add(const LoadDelegatesData()),
      child: BlocConsumer<DelegatesBloc, DelegatesState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<DelegatesBloc>(context).add(const ClearDelegatesPageCommand());
          if (pageCommand is ShowDelegateRemovalConfirmation) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<DelegatesBloc>(context),
                  child: const RemoveDelegateConfirmationDialog(),
                );
              },
            );
          } else if (pageCommand is ShowIntroducingDelegate) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) => const IntroducingDelegatesDialog(),
            );
          } else if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          }
        },
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const FullPageLoadingIndicator();
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pop(state.shouldRefreshCurrentDelegates);
                  return true;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            'Delegating your vote means to entrust the power of your vote to another Citizen.  Please choose your delegate carefully!',
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                      const SizedBox(height: 30),
                      DelegateCard(
                        onTapRemove: () => BlocProvider.of<DelegatesBloc>(context).add(const OnRemoveDelegateTapped()),
                        onTap: () => NavigationService.of(context).navigateTo(Routes.delegateAUser),
                        activeDelegate: state.activeDelegate,
                        delegate: state.delegate,
                      )
                    ],
                  ),
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
