import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/components/text_form_field_light.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/transfer/transfer.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/receive_enter_data_bloc.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_events.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_state.dart';

class ReceiveEnterDataScreen extends StatelessWidget {
  const ReceiveEnterDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReceiveEnterDataBloc(BlocProvider.of<RatesBloc>(context).state)..add(const LoadUserBalance()),
      child: Scaffold(
          appBar: AppBar(title: Text("Receive".i18n)),
          body: BlocConsumer<ReceiveEnterDataBloc, ReceiveEnterDataState>(
              listenWhen: (_, current) => current.pageCommand != null,
              listener: (BuildContext context, ReceiveEnterDataState state) {
                final pageCommand = state.pageCommand;
                if (pageCommand is NavigateToReceiveDetails) {
                  NavigationService.of(context).navigateTo(Routes.receiveQR, pageCommand.receiveDetailArguments);
                  BlocProvider.of<ReceiveEnterDataBloc>(context).add(const ClearReceiveEnterDataState());
                }
                if (state.pageCommand is ShowTransactionFail) {
                  SnackBarInfo('Receive creation failed, please try again.'.i18n, ScaffoldMessenger.of(context)).show();
                }
              },
              builder: (context, ReceiveEnterDataState state) {
                switch (state.pageState) {
                  case PageState.initial:
                    return const SizedBox.shrink();
                  case PageState.loading:
                    return const FullPageLoadingIndicator();
                  case PageState.success:
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 100),
                              AmountEntryWidget(
                                tokenDataModel: TokenDataModel(0, token: settingsStorage.selectedToken),
                                onValueChange: (value) {
                                  BlocProvider.of<ReceiveEnterDataBloc>(context)
                                      .add(OnAmountChange(amountChanged: value));
                                },
                                autoFocus: state.isAutoFocus,
                              ),
                              const SizedBox(height: 36),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                                child: Column(
                                  children: [
                                    TextFormFieldLight(
                                      labelText: "Memo".i18n,
                                      hintText: "Add a note".i18n,
                                      maxLength: blockChainMaxChars,
                                      onChanged: (String value) {
                                        BlocProvider.of<ReceiveEnterDataBloc>(context)
                                            .add(OnDescriptionChange(description: value));
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    BalanceRow(
                                      label: "Available Balance".i18n,
                                      fiatAmount: state.availableBalanceFiat,
                                      tokenAmount: state.availableBalanceToken,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(horizontalEdgePadding),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButtonLong(
                              title: 'Next'.i18n,
                              enabled: state.isNextButtonEnabled,
                              onPressed: () {
                                BlocProvider.of<ReceiveEnterDataBloc>(context).add(const OnNextButtonTapped());
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  default:
                    return const SizedBox.shrink();
                }
              })),
    );
  }
}
