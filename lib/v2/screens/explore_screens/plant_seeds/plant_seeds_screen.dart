import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/v2/components/amount_entry_widget.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/constants/app_colors.dart';
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
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
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
                      if (state.showToast) const SizedBox(height: 24),
                      if (state.showToast)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
                              decoration: BoxDecoration(
                                color: AppColors.darkGreen2,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'The value exceeds your balance',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                          ],
                        ),
                      const Spacer(),
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
                      const SizedBox(height: 16),
                      FlatButtonLong(
                        title: 'Plant Seeds',
                        enabled: state.isPlantSeedsButtonEnabled,
                        onPressed: () => BlocProvider.of<PlantSeedsBloc>(context).add(const OnPlantSeedsButtonTapped()),
                      )
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
