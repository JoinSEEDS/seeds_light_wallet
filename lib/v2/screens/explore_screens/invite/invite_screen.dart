import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/v2/components/alert_input_value.dart';
import 'package:seeds/v2/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/snack_bar_info.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/explore_screens/invite/components/invite_link_dialog.dart';
import 'package:seeds/v2/screens/explore_screens/invite/interactor/viewmodels/bloc.dart';

/// INVITE SCREEN
class InviteScreen extends StatelessWidget {
  const InviteScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InviteBloc(BlocProvider.of<RatesBloc>(context).state)..add(const LoadUserBalance()),
      child: Scaffold(
        appBar: AppBar(title: Text('Invite', style: Theme.of(context).textTheme.headline7)),
        body: BlocConsumer<InviteBloc, InviteState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            BlocProvider.of<InviteBloc>(context).add(const ClearInviteScreenPageCommand());
            if (state.pageCommand is ShowInviteLinkDialog) {
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
            if (state.pageCommand is ShowTransactionFailSnackBar) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarInfo(title: 'Invite creation failed, try again.', context: context),
              );
            }
          },
          builder: (context, InviteState state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!,
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Text('Invite amount', style: Theme.of(context).textTheme.headline6),
                            const SizedBox(height: 16),
                            AmountEntryWidget(
                              onValueChange: (value) {
                                BlocProvider.of<InviteBloc>(context).add(OnAmountChange(amountChanged: value));
                              },
                              autoFocus: state.isAutoFocus,
                            ),
                            const SizedBox(height: 24),
                            AlertInputValue(state.alertMessage ?? '', isVisible: state.alertMessage != null),
                            const SizedBox(height: 24),
                            BalanceRow(
                              label: 'Available Balance',
                              fiatAmount: state.availableBalanceFiat ?? '',
                              seedsAmount: state.availableBalance?.formattedQuantity ?? '',
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
                          title: 'Create invite',
                          enabled: state.isCreateInviteButtonEnabled,
                          onPressed: () => BlocProvider.of<InviteBloc>(context).add(const OnCreateInviteButtonTapped()),
                        ),
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
