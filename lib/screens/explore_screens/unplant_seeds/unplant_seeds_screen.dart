import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/alert_input_value.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/components/claim_seeds_succes_dialog.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/components/claim_unplant_seeds_balance_row.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/components/unplant_seeds_amount_entry.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/components/unplant_seeds_success_dialog.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_bloc.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_page_commands.dart';

class UnplantSeedsScreen extends StatefulWidget {
  const UnplantSeedsScreen({super.key});

  @override
  State<UnplantSeedsScreen> createState() => _UnplantSeedsScreenState();
}

class _UnplantSeedsScreenState extends State<UnplantSeedsScreen> {
  TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

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
            } else if (pageCommand is ShowClaimSeedsSuccess) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return ClaimSeedsSuccessDialog(
                    claimSeedsAmountFiat: pageCommand.claimAmountFiat,
                    claimSeedsAmount: pageCommand.claimAmount,
                  );
                },
              );
            } else if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            } else if (pageCommand is UpdateTextController) {
              _amountController = TextEditingController.fromValue(pageCommand.textEditingValue);
            }
          },
          builder: (context, state) {
            switch (state.pageState) {
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
                          height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!,
                          child: Column(
                            children: [
                              const SizedBox(height: 26),
                              Text('Unplant amount', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 16),
                              UnplantSeedsAmountEntry(
                                controller: _amountController,
                                unplantedBalanceFiat: state.unplantedInputAmountFiat,
                                tokenDataModel: TokenDataModel(0, token: seedsToken),
                                onValueChange: (value) {
                                  BlocProvider.of<UnplantSeedsBloc>(context).add(OnAmountChange(value));
                                },
                                autoFocus: state.onFocus,
                                onTapMax: () {
                                  BlocProvider.of<UnplantSeedsBloc>(context)
                                      .add(OnMaxButtonTapped(state.plantedBalance?.amount.toString() ?? '0'));
                                },
                              ),
                              const SizedBox(height: 24),
                              AlertInputValue('Not enough balance', isVisible: state.showOverBalanceAlert),
                              AlertInputValue('Need to keep at least 5 planted seeds',
                                  isVisible: state.showMinPlantedBalanceAlert),
                              const SizedBox(height: 60),
                              if (state.showUnclaimedBalance)
                                ClaimUnplantSeedsBalanceRow(
                                    onTapClaim: () =>
                                        BlocProvider.of<UnplantSeedsBloc>(context).add(const OnClaimButtonTapped()),
                                    isClaimButtonEnable: state.isClaimButtonEnabled,
                                    tokenAmount: state.availableClaimBalance,
                                    fiatAmount: state.availableClaimBalanceFiat),
                              const SizedBox(height: 10),
                              const DividerJungle(),
                              const SizedBox(height: 10),
                              BalanceRow(
                                label: "Planted Balance",
                                tokenAmount: state.plantedBalance,
                                fiatAmount: state.plantedBalanceFiat,
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButtonLong(
                          title: 'Unplant Seeds',
                          enabled: state.isUnplantSeedsButtonEnabled,
                          onPressed: () =>
                              BlocProvider.of<UnplantSeedsBloc>(context).add(const OnUnplantSeedsButtonTapped()),
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
