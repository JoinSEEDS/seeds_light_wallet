import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/alert_input_value.dart';
import 'package:seeds/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/global_error.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/invite/components/invite_link_dialog.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_bloc.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_page_command.dart';
import 'package:seeds/utils/build_context_extension.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InviteBloc(BlocProvider.of<RatesBloc>(context).state)
        ..add(const LoadUserBalance()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.inviteScreenAppBarTitle),
          actions: [
            TextButton(
              onPressed: () => NavigationService.of(context)
                  .navigateTo(Routes.manageInvites),
              child: Text(
                context.loc.inviteScreenManageInvitesTitle,
                style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis,
              ),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        body: BlocConsumer<InviteBloc, InviteState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;
            if (pageCommand is ShowInviteLinkView) {
              Navigator.of(context).pop(); // pop invite screen
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<InviteBloc>(context),
                    child: const InviteLinkDialog(),
                  );
                },
              );
            }
            if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(
                  pageCommand.message.localizedDescription(context)));
            }
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
                return SafeArea(
                  minimum: const EdgeInsets.all(horizontalEdgePadding),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height -
                              Scaffold.of(context).appBarMaxHeight!,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Text(context.loc.inviteScreenInputAmountTitle,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 16),
                              AmountEntryWidget(
                                tokenDataModel: TokenDataModel(0),
                                onValueChange: (value) {
                                  BlocProvider.of<InviteBloc>(context).add(
                                      OnAmountChange(amountChanged: value));
                                },
                                autoFocus: state.isAutoFocus,
                              ),
                              const SizedBox(height: 24),
                              AlertInputValue(
                                  state.errorMessage
                                          ?.localizedDescription(context) ??
                                      GlobalError.unknown
                                          .localizedDescription(context),
                                  isVisible: state.alertMessage != null),
                              const SizedBox(height: 24),
                              BalanceRow(
                                label: context.loc.inviteScreenBalanceTitle,
                                fiatAmount: state.availableBalanceFiat,
                                tokenAmount: state.availableBalance,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButtonLong(
                          title: context.loc.inviteScreenButtonTitle,
                          enabled: state.isCreateInviteButtonEnabled,
                          onPressed: () => BlocProvider.of<InviteBloc>(context)
                              .add(const OnCreateInviteButtonTapped()),
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
      ),
    );
  }
}
