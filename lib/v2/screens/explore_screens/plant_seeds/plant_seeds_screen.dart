import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/v2/components/alert_input_value.dart';
import 'package:seeds/v2/components/amount_entry_widget.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/components/plant_seeds_success_dialog.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/interactor/viewmodels/bloc.dart';

/// PLANT SEEDS SCREEN
class PlantSeedsScreen extends StatelessWidget {
  const PlantSeedsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantSeedsBloc(BlocProvider.of<RatesBloc>(context).state)..add(const LoadUserBalance()),
      child: Scaffold(
        appBar: AppBar(title: Text('Plant', style: Theme.of(context).textTheme.headline6)),
        body: BlocConsumer<PlantSeedsBloc, PlantSeedsState>(
          listenWhen: (_, current) => current.showPlantedSuccess,
          listener: (context, _) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<PlantSeedsBloc>(context),
                  child: const PlantSeedsSuccessDialog(),
                );
              },
            );
          },
          builder: (context, PlantSeedsState state) {
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
                            Text("Plant amount", style: Theme.of(context).textTheme.headline6),
                            const SizedBox(height: 16),
                            AmountEntryWidget(
                              onValueChange: (value) {
                                BlocProvider.of<PlantSeedsBloc>(context).add(OnAmountChange(amountChanged: value));
                              },
                              fiatAmount: state.fiatAmount,
                              enteringCurrencyName: currencySeedsCode,
                              autoFocus: state.isAutoFocus,
                            ),
                            const SizedBox(height: 24),
                            AlertInputValue('The value exceeds your balance', isVisible: state.showAlert),
                            const SizedBox(height: 24),
                            BalanceRow(
                              label: "Available Balance",
                              fiatAmount: state.availableBalanceFiat ?? '',
                              seedsAmount: state.availableBalance?.formattedQuantity ?? '',
                            ),
                            const DividerJungle(height: 24),
                            BalanceRow(
                              label: "Planted Balance",
                              fiatAmount: state.plantedBalance ?? '',
                              seedsAmount: state.plantedBalanceFiat ?? '',
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
                          title: 'Plant Seeds',
                          enabled: state.isPlantSeedsButtonEnabled,
                          onPressed: () =>
                              BlocProvider.of<PlantSeedsBloc>(context).add(const OnPlantSeedsButtonTapped()),
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
