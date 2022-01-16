import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/alert_input_value.dart';
import 'package:seeds/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/explore_screens/invite/invite.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/invite/components/invite_link_dialog.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_bloc.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InviteBloc(BlocProvider.of<RatesBloc>(context).state)..add(const LoadUserBalance()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Invite'.i18n),
          actions: [
            IconButton(
              onPressed: () => NavigationService.of(context).navigateTo(Routes.manageInvites),
              icon: const Icon(Icons.settings),
            )
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
              SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
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
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Text('Invite amount'.i18n, style: Theme.of(context).textTheme.headline6),
                              const SizedBox(height: 16),
                              AmountEntryWidget(
                                tokenDataModel: TokenDataModel(0),
                                onValueChange: (value) {
                                  BlocProvider.of<InviteBloc>(context).add(OnAmountChange(amountChanged: value));
                                },
                                autoFocus: state.isAutoFocus,
                              ),
                              const SizedBox(height: 24),
                              AlertInputValue(state.alertMessage ?? '', isVisible: state.alertMessage != null),
                              const SizedBox(height: 24),
                              BalanceRow(
                                label: 'Available Balance'.i18n,
                                fiatAmount: state.availableBalanceFiat,
                                tokenAmount: state.availableBalance,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FlatButtonLong(
                            title: 'Create invite'.i18n,
                            enabled: state.isCreateInviteButtonEnabled,
                            onPressed: () =>
                                BlocProvider.of<InviteBloc>(context).add(const OnCreateInviteButtonTapped()),
                          ),
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
