import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/alert_input_value.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'components/claim_unplant_seeds_balance_row.dart';
import 'components/unplant_seeds_amount_entry.dart';
import 'components/unplant_seeds_success_dialog.dart';
import 'interactor/viewmodels/unplant_seeds_bloc.dart';
import 'interactor/viewmodels/unplant_seeds_event.dart';
import 'interactor/viewmodels/unplant_seeds_page_commands.dart';
import 'interactor/viewmodels/unplant_seeds_state.dart';

/// UNPLANT SEEDS SCREEN
class UnplantSeedsScreen extends StatelessWidget {
  const UnplantSeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UnplantSeedsBloc(BlocProvider.of<RatesBloc>(context).state)..add(const LoadUserPlantedBalance()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Unplant')),
        body: BlocConsumer<UnplantSeedsBloc, UnplantSeedsState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is ShowUnplantSeedsSuccess) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<UnplantSeedsBloc>(context),
                    child: UnplantSeedsSuccessDialog(
                      unplantedInputAmountFiat: pageCommand.unplantedInputAmountFiat,
                      unplantedInputAmount: pageCommand.unplantedInputAmount,
                    ),
                  );
                },
              );
            }
            if (pageCommand is ShowErrorMessage) {
              SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
            }
          },
          builder: (context, UnplantSeedsState state) {
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
                        padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                        height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!,
                        child: Column(
                          children: [
                            const SizedBox(height: 26),
                            Text('Unplant amount', style: Theme.of(context).textTheme.headline6),
                            const SizedBox(height: 16),
                            UnplantSeedsAmountEntry(
                              controller: state.controller,
                              unplantedBalanceFiat: state.unplantedInputAmountFiat,
                              tokenDataModel: TokenDataModel(0),
                              onValueChange: (value) {
                                BlocProvider.of<UnplantSeedsBloc>(context).add(OnAmountChange(amountChanged: value));
                              },
                              autoFocus: state.onFocus,
                              onTapMax: () {
                                BlocProvider.of<UnplantSeedsBloc>(context)
                                    .add(OnMaxButtonTap(maxAmount: state.plantedBalance?.amount.toString() ?? '0'));
                              },
                            ),
                            const SizedBox(height: 24),
                            AlertInputValue('Not enough balance', isVisible: state.showOverBalanceAlert),
                            AlertInputValue('Need to keep at least 5 planted seeds',
                                isVisible: state.showMinPlantedBalanceAlert),
                            const SizedBox(height: 60),
                            if (state.showUnclaimedBalance)
                              ClaimUnplantSeedsBalanceRow(
                                  onTapClaim: () {},
                                  isClaimButtonEnable: false,
                                  tokenAmount: TokenDataModel(0),
                                  fiatAmount: FiatDataModel(0)),
                            const SizedBox(height: 10),
                            const DividerJungle(),
                            const SizedBox(height: 10),
                            BalanceRow(
                                label: "Planted Balance",
                                tokenAmount: state.plantedBalance,
                                fiatAmount: state.plantedBalanceFiat)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(horizontalEdgePadding),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButtonLong(
                          title: 'Unplant Seeds',
                          enabled: state.isUnplantSeedsButtonEnabled,
                          onPressed: () => {BlocProvider.of<UnplantSeedsBloc>(context).add(OnUnplantSeedsButtonTap())},
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
