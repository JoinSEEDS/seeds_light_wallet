import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/alert_input_value.dart';
import 'package:seeds/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/components/plant_seeds_success_dialog.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_bloc.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_page_command.dart';
import 'package:seeds/utils/build_context_extension.dart';

class PlantSeedsScreen extends StatelessWidget {
  const PlantSeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantSeedsBloc(BlocProvider.of<RatesBloc>(context).state)..add(const LoadUserBalance()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.plantSeedsAppBarTitle)),
        body: BlocConsumer<PlantSeedsBloc, PlantSeedsState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;
            if (pageCommand is ShowPlantSeedsSuccess) {
              const PlantSeedsSuccessDialog().show(context, BlocProvider.of<PlantSeedsBloc>(context));
            }
            if (pageCommand is ShowError) {
              eventBus.fire(ShowSnackBar(pageCommand.error.localizedDescription(context)));
            }
          },
          buildWhen: (previous, current) => previous.pageState != current.pageState,
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return FullPageErrorIndicator(errorMessage: state.error?.localizedDescription(context));
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
                              const SizedBox(height: 16),
                              Text(context.loc.plantSeedsPlantAmount, style: Theme.of(context).textTheme.headline6),
                              const SizedBox(height: 16),
                              AmountEntryWidget(
                                tokenDataModel: TokenDataModel(0),
                                onValueChange: (value) {
                                  BlocProvider.of<PlantSeedsBloc>(context).add(OnAmountChange(amountChanged: value));
                                },
                                autoFocus: state.isAutoFocus,
                              ),
                              const SizedBox(height: 24),
                              AlertInputValue(context.loc.plantSeedsNotEnoughBalanceAlert, isVisible: state.showAlert),
                              const SizedBox(height: 24),
                              BalanceRow(
                                label: context.loc.plantSeedsAvailableBalance,
                                fiatAmount: state.availableBalanceFiat,
                                tokenAmount: state.availableBalance,
                              ),
                              const DividerJungle(height: 24),
                              BalanceRow(
                                label: context.loc.plantSeedsPlantedBalance,
                                fiatAmount: state.plantedBalanceFiat,
                                tokenAmount: state.plantedBalance,
                              ),
                            ],
                          ),
                        ),
                      ),
                      BlocBuilder<PlantSeedsBloc, PlantSeedsState>(
                        buildWhen: (previous, current) {
                          return previous.isPlantSeedsButtonEnabled != current.isPlantSeedsButtonEnabled;
                        },
                        builder: (context, state) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButtonLong(
                              title: context.loc.plantSeedsPlantButtonTitle,
                              enabled: state.isPlantSeedsButtonEnabled,
                              onPressed: () =>
                                  BlocProvider.of<PlantSeedsBloc>(context).add(const OnPlantSeedsButtonTapped()),
                            ),
                          );
                        },
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
